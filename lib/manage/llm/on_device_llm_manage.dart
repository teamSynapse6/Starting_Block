import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/core/domain/model_source.dart';
import 'package:flutter_gemma/flutter_gemma.dart' as gemma;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/manage/api/llm_api_manage.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

enum LlmResponseEngine {
  server,
  onDevice,
}

class LlmModelDownloadSnapshot {
  final String modelName;
  final int progress;
  final int downloadedChunks;
  final int totalChunks;
  final bool isDownloading;
  final String errorMessage;

  const LlmModelDownloadSnapshot({
    required this.modelName,
    required this.progress,
    required this.downloadedChunks,
    required this.totalChunks,
    required this.isDownloading,
    this.errorMessage = '',
  });

  bool get hasError => errorMessage.isNotEmpty;
}

class OnDeviceLlmManage {
  static const String _engineKey = 'llm_response_engine';
  static const String _selectedModelKey = 'llm_selected_model_name';
  static const int _maxTokens = 4096;
  static const int _recentMessageLimit = 6;
  static const int _maxConcurrentChunkDownloads = 4;

  static gemma.InferenceModel? _activeModel;
  static gemma.InferenceChat? _activeChat;
  static String? _activeModelName;
  static final Map<String, Future<void>> _downloadTasks = {};
  static final Map<String, LlmModelDownloadSnapshot> _downloadSnapshots = {};
  static final StreamController<LlmModelDownloadSnapshot>
      _downloadEventController =
      StreamController<LlmModelDownloadSnapshot>.broadcast();

  static Stream<LlmModelDownloadSnapshot> get downloadEvents =>
      _downloadEventController.stream;

  static Future<LlmResponseEngine> getSelectedEngine() async {
    final prefs = await SharedPreferences.getInstance();
    final engine = prefs.getString(_engineKey);
    return engine == LlmResponseEngine.onDevice.name
        ? LlmResponseEngine.onDevice
        : LlmResponseEngine.server;
  }

  static Future<String?> getSelectedModelName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedModelKey);
  }

  static Future<void> saveServerSelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_engineKey, LlmResponseEngine.server.name);
    await prefs.remove(_selectedModelKey);
  }

  static Future<void> saveOnDeviceSelection(String modelName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_engineKey, LlmResponseEngine.onDevice.name);
    await prefs.setString(_selectedModelKey, modelName);
  }

  static Future<List<String>> getInstalledModelNames() {
    return gemma.FlutterGemmaPlugin.instance.modelManager
        .getInstalledModels(gemma.ModelManagementType.inference);
  }

  static Future<bool> isInstalled(String modelName) {
    return gemma.FlutterGemmaPlugin.instance.modelManager
        .isModelInstalled(_buildSpec(modelName));
  }

  static String modelId(String modelName) {
    return _modelId(modelName);
  }

  static String localModelName(LlmModelInfo model) {
    return _modelId(model.localModelName);
  }

  static String serverModelName(String localModelName) {
    return _serverModelNameFromLocal(localModelName);
  }

  static Future<LlmModelDownloadSnapshot> getDownloadSnapshot(
      LlmModelInfo model) async {
    final localModelName = model.localModelName;
    final cached = _downloadSnapshots[localModelName];
    if (cached != null) {
      return cached;
    }

    final installed = await isInstalled(localModelName);
    if (installed) {
      return LlmModelDownloadSnapshot(
        modelName: localModelName,
        progress: 100,
        downloadedChunks: model.chunkCount,
        totalChunks: model.chunkCount,
        isDownloading: false,
      );
    }

    final downloadedChunks = await _countDownloadedChunks(model);
    final progress = _progressFromChunks(downloadedChunks, model.chunkCount);
    final snapshot = LlmModelDownloadSnapshot(
      modelName: localModelName,
      progress: progress,
      downloadedChunks: downloadedChunks,
      totalChunks: model.chunkCount,
      isDownloading: _downloadTasks.containsKey(localModelName),
    );
    _downloadSnapshots[localModelName] = snapshot;
    return snapshot;
  }

  static Future<void> downloadModel(LlmModelInfo model) {
    final localModelName = model.localModelName;
    final runningTask = _downloadTasks[localModelName];
    if (runningTask != null) {
      return runningTask;
    }

    final task = _downloadModelInChunks(model);
    _downloadTasks[localModelName] = task;
    task.whenComplete(() {
      _downloadTasks.remove(localModelName);
    });
    return task;
  }

  static Future<void> deleteModel(String modelName) async {
    final spec = _buildSpec(modelName);
    await gemma.FlutterGemmaPlugin.instance.modelManager.deleteModel(spec);
    await _deleteChunkDirectory(modelName);
    _downloadSnapshots.remove(modelName);
    final selectedModelName = await getSelectedModelName();
    if (selectedModelName == modelName) {
      await saveServerSelection();
    }
    if (_activeModelName == modelName) {
      await closeActiveSession();
      await _activeModel?.close();
      _activeModel = null;
      _activeModelName = null;
    }
  }

  static Stream<String> generateReply({
    required String modelName,
    required String userMessage,
    required String context,
    required List<Message> recentMessages,
  }) async* {
    final installed = await isInstalled(modelName);
    if (!installed) {
      throw StateError('다운로드된 온디바이스 모델을 찾을 수 없어요.');
    }

    final spec = _buildSpec(modelName);
    gemma.FlutterGemmaPlugin.instance.modelManager.setActiveModel(spec);
    await _ensureActiveModel(modelName);
    await closeActiveSession();

    final modelType = _inferModelType(modelName);
    final chat = await _activeModel!.openChat(
      temperature: 0.7,
      topK: 40,
      topP: 0.9,
      tokenBuffer: 512,
      modelType: modelType,
      systemInstruction: _systemInstruction,
    );
    _activeChat = chat;

    final prompt = _buildPrompt(
      context: context,
      userMessage: userMessage,
      recentMessages: recentMessages,
    );
    await chat.addQuery(gemma.Message.text(text: prompt, isUser: true));

    try {
      await for (final response in chat.generateChatResponseAsync()) {
        if (response is gemma.TextResponse) {
          yield response.token;
        } else if (response is gemma.ThinkingResponse) {
          debugPrint('On-device LLM thinking: ${response.content}');
        }
      }
    } finally {
      if (identical(_activeChat, chat)) {
        await closeActiveSession();
      }
    }
  }

  static Future<void> stopGeneration() async {
    await _activeChat?.stopGeneration();
  }

  static Future<void> closeActiveSession() async {
    final chat = _activeChat;
    _activeChat = null;
    await chat?.close();
  }

  static Future<void> _ensureActiveModel(String modelName) async {
    if (_activeModel != null && _activeModelName == modelName) {
      return;
    }

    await closeActiveSession();
    await _activeModel?.close();
    _activeModel = await gemma.FlutterGemma.getActiveModel(
      maxTokens: _maxTokens,
      preferredBackend: gemma.PreferredBackend.gpu,
      maxConcurrentSessions: 1,
    );
    _activeModelName = modelName;
  }

  static Future<void> _downloadModelInChunks(LlmModelInfo model) async {
    final chunkCount = model.chunkCount;
    final serverModelName = model.modelName;
    final localModelName = model.localModelName;
    if (chunkCount <= 0) {
      throw StateError('모델 chunk 정보가 없습니다.');
    }

    try {
      final initialDownloadedChunks = await _countDownloadedChunks(model);
      _emitDownloadSnapshot(
        modelName: localModelName,
        downloadedChunks: initialDownloadedChunks,
        totalChunks: chunkCount,
        isDownloading: true,
      );

      final chunkBase = await _resolveChunkIndexBase(serverModelName);
      var nextChunkIndex = 0;
      var downloadedChunks = initialDownloadedChunks;

      Future<void> worker() async {
        while (true) {
          final chunkIndex = nextChunkIndex;
          nextChunkIndex += 1;
          if (chunkIndex >= chunkCount) {
            return;
          }

          final chunkFile = await _chunkFile(localModelName, chunkIndex);
          if (await chunkFile.exists() && await chunkFile.length() > 0) {
            continue;
          }

          await _downloadChunk(
            modelName: serverModelName,
            chunkIndex: chunkIndex,
            serverChunkNum: chunkIndex + chunkBase,
            chunkFile: chunkFile,
          );
          downloadedChunks += 1;
          _emitDownloadSnapshot(
            modelName: localModelName,
            downloadedChunks: downloadedChunks,
            totalChunks: chunkCount,
            isDownloading: true,
          );
        }
      }

      final workerCount = min(_maxConcurrentChunkDownloads, chunkCount);
      await Future.wait(List.generate(workerCount, (_) => worker()));
      final outputFile = await _mergeChunks(model);
      final spec = _buildSpec(localModelName, filePath: outputFile.path);
      await gemma.FlutterGemmaPlugin.instance.modelManager
          .ensureModelReadyFromSpec(spec);
      await _deleteChunkDirectory(localModelName);
      _emitDownloadSnapshot(
        modelName: localModelName,
        downloadedChunks: chunkCount,
        totalChunks: chunkCount,
        isDownloading: false,
      );
    } catch (error) {
      _emitDownloadSnapshot(
        modelName: localModelName,
        downloadedChunks: await _countDownloadedChunks(model),
        totalChunks: chunkCount,
        isDownloading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
      rethrow;
    }
  }

  static Future<int> _resolveChunkIndexBase(String modelName) async {
    final zeroBasedStatus = await _headChunk(modelName, 0);
    if (zeroBasedStatus >= 200 && zeroBasedStatus < 300) {
      return 0;
    }

    final oneBasedStatus = await _headChunk(modelName, 1);
    if (oneBasedStatus >= 200 && oneBasedStatus < 300) {
      return 1;
    }

    return 0;
  }

  static Future<int> _headChunk(String modelName, int chunkNum) async {
    final uri = LlmApi.getModelChunkDownloadUri(modelName, chunkNum);
    var headers = await LlmApi.getHeaders();
    var response = await http.head(uri, headers: headers);
    if (response.statusCode == 401) {
      await UserInfoManageApi.updateAccessToken();
      headers = await LlmApi.getHeaders();
      response = await http.head(uri, headers: headers);
    }
    return response.statusCode;
  }

  static Future<void> _downloadChunk({
    required String modelName,
    required int chunkIndex,
    required int serverChunkNum,
    required File chunkFile,
  }) async {
    final tempFile = File('${chunkFile.path}.part');
    await tempFile.parent.create(recursive: true);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }

    final client = http.Client();
    try {
      await _downloadChunkWithClient(
        client: client,
        modelName: modelName,
        serverChunkNum: serverChunkNum,
        tempFile: tempFile,
        retryCount: 1,
      );
      if (await chunkFile.exists()) {
        await chunkFile.delete();
      }
      await tempFile.rename(chunkFile.path);
    } catch (_) {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      rethrow;
    } finally {
      client.close();
    }
  }

  static Future<void> _downloadChunkWithClient({
    required http.Client client,
    required String modelName,
    required int serverChunkNum,
    required File tempFile,
    required int retryCount,
  }) async {
    final uri = LlmApi.getModelChunkDownloadUri(modelName, serverChunkNum);
    final request = http.Request('GET', uri);
    request.headers.addAll(await LlmApi.getHeaders());
    final response = await client.send(request);

    if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return _downloadChunkWithClient(
        client: client,
        modelName: modelName,
        serverChunkNum: serverChunkNum,
        tempFile: tempFile,
        retryCount: retryCount - 1,
      );
    }

    if (response.statusCode != 200) {
      throw Exception('chunk 다운로드 실패: ${response.statusCode}');
    }

    final sink = tempFile.openWrite();
    await response.stream.pipe(sink);
  }

  static Future<File> _mergeChunks(LlmModelInfo model) async {
    final localModelName = model.localModelName;
    final outputFile = File(await _modelFilePath(localModelName));
    final tempOutputFile = File('${outputFile.path}.part');
    await tempOutputFile.parent.create(recursive: true);
    if (await tempOutputFile.exists()) {
      await tempOutputFile.delete();
    }

    final sink = tempOutputFile.openWrite();
    try {
      for (var index = 0; index < model.chunkCount; index += 1) {
        final chunkFile = await _chunkFile(localModelName, index);
        if (!await chunkFile.exists()) {
          throw Exception('누락된 모델 chunk가 있습니다.');
        }
        await sink.addStream(chunkFile.openRead());
      }
    } finally {
      await sink.close();
    }

    if (await outputFile.exists()) {
      await outputFile.delete();
    }
    return tempOutputFile.rename(outputFile.path);
  }

  static void _emitDownloadSnapshot({
    required String modelName,
    required int downloadedChunks,
    required int totalChunks,
    required bool isDownloading,
    String errorMessage = '',
  }) {
    final snapshot = LlmModelDownloadSnapshot(
      modelName: modelName,
      progress: _progressFromChunks(downloadedChunks, totalChunks),
      downloadedChunks: downloadedChunks,
      totalChunks: totalChunks,
      isDownloading: isDownloading,
      errorMessage: errorMessage,
    );
    _downloadSnapshots[modelName] = snapshot;
    _downloadEventController.add(snapshot);
  }

  static int _progressFromChunks(int downloadedChunks, int totalChunks) {
    if (totalChunks <= 0) {
      return 0;
    }
    return ((downloadedChunks / totalChunks) * 100).floor().clamp(0, 100);
  }

  static Future<int> _countDownloadedChunks(LlmModelInfo model) async {
    final localModelName = model.localModelName;
    var count = 0;
    for (var index = 0; index < model.chunkCount; index += 1) {
      final chunkFile = await _chunkFile(localModelName, index);
      if (await chunkFile.exists() && await chunkFile.length() > 0) {
        count += 1;
      }
    }
    return count;
  }

  static Future<File> _chunkFile(String modelName, int chunkIndex) async {
    final directory = await _chunkDirectory(modelName);
    return File('${directory.path}${Platform.pathSeparator}$chunkIndex.chunk');
  }

  static Future<Directory> _chunkDirectory(String modelName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final directory = Directory(
      '${documentsDirectory.path}${Platform.pathSeparator}model_chunks'
      '${Platform.pathSeparator}${_modelId(modelName)}',
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  static Future<void> _deleteChunkDirectory(String modelName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final directory = Directory(
      '${documentsDirectory.path}${Platform.pathSeparator}model_chunks'
      '${Platform.pathSeparator}${_modelId(modelName)}',
    );
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  static Future<String> _modelFilePath(String modelName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return '${documentsDirectory.path}${Platform.pathSeparator}${_modelId(modelName)}';
  }

  static gemma.InferenceModelSpec _buildSpec(
    String modelName, {
    String? filePath,
  }) {
    final modelSource = filePath == null
        ? ModelSource.network(
            LlmApi.getModelDownloadUri(_serverModelNameFromLocal(modelName))
                .toString(),
          )
        : ModelSource.file(filePath);
    return gemma.InferenceModelSpec(
      name: _modelId(modelName),
      modelSource: modelSource,
      replacePolicy: gemma.ModelReplacePolicy.keep,
      modelType: _inferModelType(modelName),
      fileType: _inferFileType(modelName),
    );
  }

  static String _modelId(String modelName) {
    return Uri.parse('/$modelName').pathSegments.last;
  }

  static String _serverModelNameFromLocal(String localModelName) {
    final modelId = _modelId(localModelName);
    final lowerModelId = modelId.toLowerCase();
    const extensions = ['.litertlm', '.bin', '.tflite'];
    for (final extension in extensions) {
      if (lowerModelId.endsWith(extension)) {
        return modelId.substring(0, modelId.length - extension.length);
      }
    }
    return modelId;
  }

  static gemma.ModelFileType _inferFileType(String modelName) {
    final lowerName = modelName.toLowerCase();
    if (lowerName.endsWith('.bin') || lowerName.endsWith('.tflite')) {
      return gemma.ModelFileType.binary;
    }
    if (lowerName.endsWith('.litertlm')) {
      return gemma.ModelFileType.litertlm;
    }
    return gemma.ModelFileType.litertlm;
  }

  static gemma.ModelType _inferModelType(String modelName) {
    final lowerName = modelName.toLowerCase();
    if (lowerName.contains('gemma-4') || lowerName.contains('gemma4')) {
      return gemma.ModelType.gemma4;
    }
    if (lowerName.contains('gemma')) {
      return gemma.ModelType.gemmaIt;
    }
    if (lowerName.contains('qwen3')) {
      return gemma.ModelType.qwen3;
    }
    if (lowerName.contains('qwen')) {
      return gemma.ModelType.qwen;
    }
    if (lowerName.contains('deepseek')) {
      return gemma.ModelType.deepSeek;
    }
    if (lowerName.contains('llama') || lowerName.contains('hyperclova')) {
      return gemma.ModelType.llama;
    }
    if (lowerName.contains('phi')) {
      return gemma.ModelType.phi;
    }
    return gemma.ModelType.general;
  }

  static String _buildPrompt({
    required String context,
    required String userMessage,
    required List<Message> recentMessages,
  }) {
    final conversation = _recentConversationText(
      recentMessages,
      userMessage: userMessage,
    );

    return '''
아래 공고 컨텍스트와 최근 대화를 참고해 사용자의 질문에 답변해 주세요.

규칙:
- 컨텍스트에 근거가 있는 내용은 구체적으로 답변합니다.
- 컨텍스트만으로 확실하지 않은 내용은 모른다고 말하고, 확인이 필요한 항목을 안내합니다.
- 지원사업 공고와 무관한 내용을 추측해서 만들지 않습니다.
- 답변은 자연스러운 한국어로 작성합니다.

[공고 컨텍스트]
${context.trim().isEmpty ? '제공된 컨텍스트가 없습니다.' : context.trim()}

[최근 대화]
${conversation.isEmpty ? '최근 대화가 없습니다.' : conversation}

[사용자 질문]
$userMessage
''';
  }

  static String _recentConversationText(
    List<Message> messages, {
    required String userMessage,
  }) {
    final filtered =
        messages.where((message) => message.message.trim().isNotEmpty).toList();
    if (filtered.isNotEmpty &&
        filtered.last.isUser &&
        filtered.last.message.trim() == userMessage.trim()) {
      filtered.removeLast();
    }
    final start = filtered.length > _recentMessageLimit
        ? filtered.length - _recentMessageLimit
        : 0;
    return filtered
        .sublist(start)
        .map((message) =>
            '${message.isUser ? '사용자' : 'AI'}: ${message.message.trim()}')
        .join('\n');
  }

  static const String _systemInstruction = '''
당신은 스타팅블록 앱의 공고 분석 AI입니다.
사용자가 보고 있는 창업 지원사업 공고의 첨부파일과 공고 정보를 바탕으로 정확하고 간결하게 답변합니다.
''';
}
