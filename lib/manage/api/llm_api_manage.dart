import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/api/api_baseurl.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class LlmSseParser {
  String _buffer = '';

  List<LlmStreamEvent> addChunk(String chunk) {
    _buffer += chunk.replaceAll('\r\n', '\n');
    final frames = <LlmStreamEvent>[];

    while (_buffer.contains('\n\n')) {
      final index = _buffer.indexOf('\n\n');
      final frame = _buffer.substring(0, index);
      _buffer = _buffer.substring(index + 2);
      final parsed = _parseFrame(frame);
      if (parsed != null) {
        frames.add(parsed);
      }
    }

    return frames;
  }

  List<LlmStreamEvent> close() {
    if (_buffer.trim().isEmpty) {
      _buffer = '';
      return [];
    }
    final parsed = _parseFrame(_buffer);
    _buffer = '';
    return parsed == null ? [] : [parsed];
  }

  LlmStreamEvent? _parseFrame(String frame) {
    String event = 'message';
    final dataLines = <String>[];

    for (final rawLine in frame.split('\n')) {
      final line = rawLine.trimRight();
      if (line.isEmpty || line.startsWith(':')) {
        continue;
      }
      if (line.startsWith('event:')) {
        event = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        dataLines.add(line.substring(5).trimLeft());
      }
    }

    if (dataLines.isEmpty) {
      return null;
    }

    final dataText = dataLines.join('\n');
    if (dataText == '[DONE]') {
      return const LlmStreamEvent(event: 'done', data: {});
    }

    try {
      final decoded = jsonDecode(dataText);
      if (decoded is Map<String, dynamic>) {
        return LlmStreamEvent(event: event, data: decoded);
      }
      return LlmStreamEvent(event: event, data: {'value': decoded});
    } catch (_) {
      return LlmStreamEvent(event: event, data: {'text': dataText});
    }
  }
}

class LlmApi {
  static dynamic _decodeJsonResponse(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, String>> getHeaders() async {
    String? accessToken = await UserTokenManage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

  static String baseUrl = apiBaseUrl;
  static String llmStart = 'llm/start';
  static String llmChat = 'llm/chat';
  static String llmRetrieval = 'llm/retrieval';
  static String llmReplySave = 'llm/reply-save';
  static String llmStream = 'llm/stream';
  static String llmStatus = 'llm/status';
  static String llmHistory = 'llm/history';
  static String llmList = 'llm/list';
  static String llmCancel = 'llm/cancel';
  static String llmEnd = 'llm/delete';
  static String modelList = 'model/list';
  static String modelDownload = 'model/download';
  static String modelConfig = 'model/config';

  //대화를 위한 쓰레드 생성 메소드
  static Future<String> getLlmStart({int retryCount = 1}) async {
    final llmStartUrl = Uri.parse('$baseUrl/$llmStart');
    final headers = await getHeaders();
    final response = await http.post(llmStartUrl, headers: headers);
    if (response.statusCode == 200) {
      final responseData = _decodeJsonResponse(response);
      final threadId = responseData is Map<String, dynamic>
          ? responseData['thread_id']?.toString() ?? ''
          : responseData?.toString() ?? '';
      debugPrint('쓰레드 ID: $threadId');
      return threadId;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getLlmStart(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getLlmStatus(String threadId,
      {int retryCount = 1}) async {
    final uri = Uri.parse('$baseUrl/$llmStatus').replace(
      queryParameters: {'thread_id': threadId},
    );
    final headers = await getHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return _decodeJsonResponse(response) as Map<String, dynamic>;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getLlmStatus(threadId, retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getLlmHistory(String threadId,
      {int retryCount = 1}) async {
    final uri = Uri.parse('$baseUrl/$llmHistory').replace(
      queryParameters: {'thread_id': threadId},
    );
    final headers = await getHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return _decodeJsonResponse(response) as Map<String, dynamic>;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getLlmHistory(threadId, retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  static Future<List<LlmConversationSummary>> getLlmList(
      {int retryCount = 1}) async {
    final uri = Uri.parse('$baseUrl/$llmList');
    final headers = await getHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final responseData = _decodeJsonResponse(response);
      if (responseData is List) {
        return responseData
            .whereType<Map<String, dynamic>>()
            .map(LlmConversationSummary.fromJson)
            .toList();
      }
      return [];
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getLlmList(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  //채팅 메소드 (SSE 스트리밍)
  static Stream<LlmStreamEvent> postLlmChat(
      String threadId, String message, int announcementId,
      {int retryCount = 1}) async* {
    final llmChatUrl = Uri.parse('$baseUrl/$llmChat');
    final request = LlmChatRequest(
      threadId: threadId,
      message: message,
      announcementId: announcementId,
    );
    yield* _postLlmSse(llmChatUrl, request.toJson(), retryCount: retryCount);
  }

  static Stream<LlmStreamEvent> postLlmRetrieval(LlmChatRequest request,
      {int retryCount = 1}) async* {
    final uri = Uri.parse('$baseUrl/$llmRetrieval');
    yield* _postLlmSse(uri, request.toJson(), retryCount: retryCount);
  }

  static Stream<LlmStreamEvent> _postLlmSse(Uri uri, Map<String, dynamic> body,
      {int retryCount = 1}) async* {
    final headers = await getHeaders();

    final client = http.Client();
    try {
      final request = http.Request('POST', uri);
      request.headers.addAll(headers);
      request.body = jsonEncode(body);

      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode == 200) {
        final parser = LlmSseParser();
        await for (final chunk
            in streamedResponse.stream.transform(utf8.decoder)) {
          for (final event in parser.addChunk(chunk)) {
            yield event;
          }
        }
        for (final event in parser.close()) {
          yield event;
        }
      } else if (streamedResponse.statusCode == 401 && retryCount > 0) {
        await UserInfoManageApi.updateAccessToken();
        yield* _postLlmSse(uri, body, retryCount: retryCount - 1);
      } else {
        throw Exception('서버 오류: ${streamedResponse.statusCode}');
      }
    } finally {
      client.close();
    }
  }

  static Future<String> saveLlmReply(LlmReplySaveRequest request,
      {int retryCount = 1}) async {
    final uri = Uri.parse('$baseUrl/$llmReplySave');
    final headers = await getHeaders();
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final decoded = _decodeJsonResponse(response);
      return decoded?.toString() ?? '';
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return saveLlmReply(request, retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  static Future<List<LlmModelInfo>> getLlmModelList(
      {int retryCount = 1}) async {
    final uri = Uri.parse('$baseUrl/$modelList');
    final headers = await getHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final decoded = _decodeJsonResponse(response);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(LlmModelInfo.fromJson)
            .where((model) => model.modelName.isNotEmpty)
            .toList();
      }
      return [];
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getLlmModelList(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  static Future<List<LlmGenerationConfig>> getLlmModelConfigList(
      {int retryCount = 1}) async {
    final uri = Uri.parse('$baseUrl/$modelConfig');
    final headers = await getHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final decoded = _decodeJsonResponse(response);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(LlmGenerationConfig.fromJson)
            .where((config) => config.modelName.isNotEmpty)
            .toList();
      }
      return [];
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getLlmModelConfigList(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  static Uri getModelDownloadUri(String modelName) {
    final baseUri = Uri.parse(baseUrl);
    return baseUri.replace(
      pathSegments: [
        ...baseUri.pathSegments.where((segment) => segment.isNotEmpty),
        'model',
        'download',
        modelName,
      ],
    );
  }

  static Uri getModelChunkDownloadUri(String modelName, int chunkNum) {
    final baseUri = Uri.parse(baseUrl);
    return baseUri.replace(
      pathSegments: [
        ...baseUri.pathSegments.where((segment) => segment.isNotEmpty),
        'model',
        'download',
        modelName,
        chunkNum.toString(),
      ],
    );
  }

  static Future<String?> getModelDownloadToken() {
    return UserTokenManage.getAccessToken();
  }

  static Stream<LlmStreamEvent> reconnectLlmStream(String threadId,
      {int afterSeq = 0, int retryCount = 1}) async* {
    final uri = Uri.parse('$baseUrl/$llmStream').replace(
      queryParameters: {
        'thread_id': threadId,
        'after_seq': afterSeq.toString(),
      },
    );
    final headers = await getHeaders();

    final client = http.Client();
    try {
      final request = http.Request('GET', uri);
      request.headers.addAll(headers);

      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode == 200) {
        final parser = LlmSseParser();
        await for (final chunk
            in streamedResponse.stream.transform(utf8.decoder)) {
          for (final event in parser.addChunk(chunk)) {
            yield event;
          }
        }
        for (final event in parser.close()) {
          yield event;
        }
      } else if (streamedResponse.statusCode == 401 && retryCount > 0) {
        await UserInfoManageApi.updateAccessToken();
        yield* reconnectLlmStream(threadId,
            afterSeq: afterSeq, retryCount: retryCount - 1);
      } else {
        throw Exception('서버 오류: ${streamedResponse.statusCode}');
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> cancelLlmChat(String threadId,
      {int retryCount = 1}) async {
    final uri = Uri.parse('$baseUrl/$llmCancel').replace(
      queryParameters: {'thread_id': threadId},
    );
    final headers = await getHeaders();
    final response = await http.post(uri, headers: headers);
    if (response.statusCode == 200) {
      return _boolFromResponse(response, key: 'cancelled');
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return cancelLlmChat(threadId, retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  //대화 종료를 위한 쓰레드 삭제 메소드
  static Future<bool> deleteLlmEnd(String threadId,
      {int retryCount = 1}) async {
    final llmEndUrl = Uri.parse('$baseUrl/$llmEnd').replace(
      queryParameters: {'thread_id': threadId},
    );
    final headers = await getHeaders();
    final response = await http.delete(llmEndUrl, headers: headers);
    if (response.statusCode == 200) {
      return _boolFromResponse(response, key: 'deleted');
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return deleteLlmEnd(threadId, retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  static bool _boolFromResponse(http.Response response, {required String key}) {
    if (response.bodyBytes.isEmpty) {
      return true;
    }
    try {
      final decoded = _decodeJsonResponse(response);
      if (decoded is bool) {
        return decoded;
      }
      if (decoded is Map<String, dynamic>) {
        final value = decoded[key];
        return value is bool ? value : value?.toString() != 'false';
      }
      final text = decoded?.toString().toLowerCase() ?? '';
      return text != 'false';
    } catch (_) {
      return response.body.trim().toLowerCase() != 'false';
    }
  }
}
