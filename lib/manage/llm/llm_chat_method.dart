part of '../../screen/llm_chat/llm_chat_screen.dart';

mixin LlmChatMethods on State<LlmChatScreen> {
  ScrollController get _scrollController;
  LlmChatScrollManager get _scrollManager;
  TextEditingController get _controller;

  StreamSubscription<LlmStreamEvent>? get _streamSubscription;
  set _streamSubscription(StreamSubscription<LlmStreamEvent>? value);

  bool get _isTyped;
  set _isTyped(bool value);
  set _isInitializing(bool value);
  bool get _isSending;
  set _isSending(bool value);
  bool get _isStreaming;
  set _isStreaming(bool value);
  bool get _isOnDeviceGeneration;
  set _isOnDeviceGeneration(bool value);
  bool get _hasRunningGeneration;
  set _hasRunningGeneration(bool value);
  bool get _didPrepareToLeave;
  set _didPrepareToLeave(bool value);

  int get _reconnectAttempts;
  set _reconnectAttempts(int value);
  int get _announcementId;

  String? get _threadId;
  set _threadId(String? value);
  set _statusText(String value);
  String get _thinkingText;
  set _thinkingText(String value);
  LlmResponseEngine get _selectedEngine;
  set _selectedEngine(LlmResponseEngine value);
  String? get _selectedModelName;
  set _selectedModelName(String? value);
  List<String> get _installedModelNames;
  set _installedModelNames(List<String> value);
  List<Message> get _messages;
  set _messages(List<Message> value);

  void _showQueueModal(String message);
  void _hideQueueModal();

  void _handleTextInputChange() {
    final isTyped = _controller.text.trim().isNotEmpty;
    if (isTyped != _isTyped && mounted) {
      setState(() {
        _isTyped = isTyped;
      });
    }
  }

  Future<void> initializeWidget() async {
    try {
      var threadId = widget.threadId;

      if (threadId.isEmpty) {
        threadId = await LlmApi.getLlmStart();
      }

      LlmBackgroundStreamWatcher.stop(threadId);

      if (!mounted) {
        return;
      }
      setState(() {
        _threadId = threadId;
      });

      await _loadModelSelection();
      await _syncFromServer(reconnectIfRunning: true);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _messages = [
          Message(
            isUser: false,
            message: '대화 정보를 불러오는 중 오류가 발생했습니다.',
            time: LlmChatTimeFormatter.formatCurrentTime(DateTime.now()),
          ),
        ];
        _isInitializing = false;
      });
    }
  }

  Future<void> _loadModelSelection() async {
    try {
      final installedModels = await OnDeviceLlmManage.getInstalledModelNames();
      final selectedEngine = await OnDeviceLlmManage.getSelectedEngine();
      final selectedModelName = await OnDeviceLlmManage.getSelectedModelName();
      final resolvedSelectedModelName = selectedModelName == null
          ? null
          : await OnDeviceLlmManage.resolveInstalledModelName(
              selectedModelName,
            );
      final canUseOnDevice = selectedEngine == LlmResponseEngine.onDevice &&
          resolvedSelectedModelName != null &&
          installedModels.contains(resolvedSelectedModelName);

      if (!canUseOnDevice && selectedEngine == LlmResponseEngine.onDevice) {
        await OnDeviceLlmManage.saveServerSelection();
      } else if (canUseOnDevice &&
          selectedModelName != resolvedSelectedModelName) {
        await OnDeviceLlmManage.saveOnDeviceSelection(
            resolvedSelectedModelName);
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _installedModelNames = installedModels;
        _selectedEngine = canUseOnDevice
            ? LlmResponseEngine.onDevice
            : LlmResponseEngine.server;
        _selectedModelName = canUseOnDevice ? resolvedSelectedModelName : null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _installedModelNames = [];
        _selectedEngine = LlmResponseEngine.server;
        _selectedModelName = null;
      });
    }
  }

  Future<void> _handleModelSelectionChanged(String? value) async {
    if (value == null || _isStreaming || _isSending) {
      return;
    }

    if (value == _serverModelValue) {
      await OnDeviceLlmManage.saveServerSelection();
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedEngine = LlmResponseEngine.server;
        _selectedModelName = null;
      });
      return;
    }

    await OnDeviceLlmManage.saveOnDeviceSelection(value);
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedEngine = LlmResponseEngine.onDevice;
      _selectedModelName = value;
    });
  }

  String get _serverModelValue => 'server';

  String get _selectedModelValue {
    if (_selectedEngine == LlmResponseEngine.onDevice &&
        _selectedModelName != null &&
        _installedModelNames.contains(_selectedModelName)) {
      return _selectedModelName!;
    }
    return _serverModelValue;
  }

  Future<void> _syncFromServer({required bool reconnectIfRunning}) async {
    final threadId = _threadId;
    if (threadId == null || threadId.isEmpty) {
      return;
    }

    final status = await LlmApi.getLlmStatus(threadId);
    final history = await LlmApi.getLlmHistory(threadId);
    final messages = LlmChatMessageManager.messagesFromHistory(history);
    final generation = LlmChatMessageManager.mapValue(status['generation']);
    final session = LlmChatMessageManager.mapValue(status['session']);

    if (session == null && messages.isEmpty) {
      final newThreadId = await LlmApi.getLlmStart();
      if (!mounted) {
        return;
      }
      setState(() {
        _threadId = newThreadId;
        _messages = [];
        _isInitializing = false;
        _isSending = false;
        _isStreaming = false;
        _isOnDeviceGeneration = false;
        _hasRunningGeneration = false;
      });
      return;
    }

    final generationStatus = generation?['status']?.toString() ?? '';
    final generationStage = generation?['stage']?.toString() ?? '';
    final isRunning = generationStatus == 'queued' ||
        generationStatus == 'running' ||
        generationStatus == 'cancelling';
    final pendingUserMessage = generation?['message']?.toString() ?? '';
    final partialResponse = generation?['partial_response']?.toString() ?? '';
    final thinkingResponse = generation?['thinking_response']?.toString() ?? '';

    final nextMessages = [...messages];
    if (isRunning && pendingUserMessage.isNotEmpty) {
      final hasPendingUser = nextMessages.isNotEmpty &&
          nextMessages.last.isUser &&
          nextMessages.last.message == pendingUserMessage;
      if (!hasPendingUser) {
        nextMessages.add(Message(
          isUser: true,
          message: pendingUserMessage,
          time: LlmChatTimeFormatter.formatCurrentTime(DateTime.now()),
        ));
      }
    }
    if (isRunning) {
      LlmChatMessageManager.upsertAssistantMessageInList(
        nextMessages,
        partialResponse,
        LlmChatTimeFormatter.formatCurrentTime(DateTime.now()),
      );
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _messages = nextMessages;
      _thinkingText = thinkingResponse;
      _statusText =
          isRunning ? LlmChatStageText.statusMessage(generationStage) : '';
      _isInitializing = false;
      _isSending = false;
      _isStreaming = isRunning;
      _isOnDeviceGeneration = false;
      _hasRunningGeneration = isRunning;
    });

    await _saveMetaFromMessages(hasRunningGeneration: isRunning);
    _scrollToBottom();

    if (isRunning) {
      _handleQueueByStage(generationStage);
    } else {
      _hideQueueModal();
    }

    if (isRunning && reconnectIfRunning) {
      _listenToStream(LlmApi.reconnectLlmStream(threadId));
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _controller.text.trim();
    final threadId = _threadId;
    if (messageText.isEmpty || threadId == null || threadId.isEmpty) {
      return;
    }

    final selectedModelName = _selectedModelName;
    final useOnDevice = _selectedEngine == LlmResponseEngine.onDevice &&
        selectedModelName != null &&
        selectedModelName.isNotEmpty;

    FocusScope.of(context).unfocus();
    final now = LlmChatTimeFormatter.formatCurrentTime(DateTime.now());

    setState(() {
      _messages.add(Message(isUser: true, message: messageText, time: now));
      _messages.add(Message(isUser: false, message: '', time: now));
      _controller.clear();
      _isTyped = false;
      _isSending = true;
      _isStreaming = true;
      _isOnDeviceGeneration = useOnDevice;
      _hasRunningGeneration = true;
      _statusText = 'AI가 질문을 확인하고 있어요.';
      _thinkingText = '';
    });
    _reconnectAttempts = 0;
    _scrollToBottom();

    await _saveMetaFromMessages(hasRunningGeneration: true);
    if (useOnDevice) {
      unawaited(_runOnDeviceFlow(
        threadId: threadId,
        messageText: messageText,
        modelName: selectedModelName,
      ));
    } else {
      _isOnDeviceGeneration = false;
      _listenToStream(
        LlmApi.postLlmChat(threadId, messageText, _announcementId),
      );
    }
  }

  void _listenToStream(Stream<LlmStreamEvent> stream) {
    _streamSubscription?.cancel();
    _isOnDeviceGeneration = false;
    _streamSubscription = stream.listen(
      _handleStreamEvent,
      onError: (_) => _recoverAfterStreamError(),
      onDone: () {
        if (mounted && _isStreaming) {
          _recoverAfterStreamError();
        }
      },
      cancelOnError: true,
    );
  }

  Future<void> _runOnDeviceFlow({
    required String threadId,
    required String messageText,
    required String modelName,
  }) async {
    final retrievalBuffer = StringBuffer();
    String fallbackRawData = '';
    final retrievalDone = Completer<void>();

    try {
      _streamSubscription?.cancel();
      _streamSubscription = LlmApi.postLlmRetrieval(
        LlmChatRequest(
          threadId: threadId,
          message: messageText,
          announcementId: _announcementId,
        ),
      ).listen(
        (event) {
          if (!mounted || retrievalDone.isCompleted) {
            return;
          }

          if (event.isStatus) {
            final stage = event.stage;
            setState(() {
              _statusText = LlmChatStageText.statusMessage(stage);
              _hasRunningGeneration = !LlmChatStageText.isFinishedStage(stage);
            });
            _handleQueueByStage(stage);
            return;
          }

          if (event.isError) {
            _hideQueueModal();
            final message = event.detail.isNotEmpty
                ? event.detail
                : '공고 내용을 찾는 중 오류가 발생했습니다.';
            retrievalDone.completeError(Exception(message));
            return;
          }

          if (event.isDone) {
            fallbackRawData =
                event.rawData.isNotEmpty ? event.rawData : event.retrievalData;
            final doneText = event.retrievalText;
            if (doneText.trim().isNotEmpty) {
              retrievalBuffer.write(doneText);
            }
            retrievalDone.complete();
            return;
          }

          final text = event.retrievalText;
          if (text.trim().isNotEmpty) {
            retrievalBuffer.write(text);
          }
        },
        onError: retrievalDone.completeError,
        onDone: () {
          if (!retrievalDone.isCompleted) {
            retrievalDone.complete();
          }
        },
        cancelOnError: true,
      );

      await retrievalDone.future;
      await _streamSubscription?.cancel();
      _streamSubscription = null;

      if (!mounted || !_isOnDeviceGeneration) {
        return;
      }

      final retrievalContext = retrievalBuffer.toString().trim();
      final context =
          retrievalContext.isNotEmpty ? retrievalContext : fallbackRawData;
      await _runOnDeviceGeneration(
        modelName: modelName,
        messageText: messageText,
        retrievalContext: context,
      );
    } catch (error) {
      await _recoverAfterStreamError(
        fallbackMessage: _errorMessage(error),
        allowReconnect: false,
      );
    }
  }

  Future<void> _runOnDeviceGeneration({
    required String modelName,
    required String messageText,
    required String retrievalContext,
  }) async {
    final replyBuffer = StringBuffer();

    try {
      _hideQueueModal();
      if (!mounted) {
        return;
      }
      setState(() {
        _statusText = LlmChatStageText.statusMessage('llm_model_ready');
        _isSending = true;
        _isStreaming = true;
        _isOnDeviceGeneration = true;
        _hasRunningGeneration = true;
      });

      await for (final token in OnDeviceLlmManage.generateReply(
        modelName: modelName,
        userMessage: messageText,
        context: retrievalContext,
        recentMessages: _messages,
      )) {
        if (!mounted) {
          return;
        }
        replyBuffer.write(token);
        setState(() {
          LlmChatMessageManager.appendAssistantMessage(_messages, token);
          _statusText = LlmChatStageText.statusMessage('llm_generating');
          _isSending = false;
          _isStreaming = true;
          _isOnDeviceGeneration = true;
          _hasRunningGeneration = true;
        });
        await _saveMetaFromMessages(hasRunningGeneration: true);
        _scrollToBottom();
      }

      final reply = replyBuffer.toString().trim().isNotEmpty
          ? replyBuffer.toString()
          : (_messages.isNotEmpty && !_messages.last.isUser
              ? _messages.last.message
              : '');

      if (reply.trim().isEmpty) {
        throw StateError('온디바이스 AI가 빈 답변을 반환했습니다.');
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _statusText = LlmChatStageText.statusMessage('llm_response_generated');
      });

      var didSaveReply = true;
      try {
        await LlmApi.saveLlmReply(
          LlmReplySaveRequest(
            threadId: _threadId ?? '',
            announcementId: _announcementId,
            modelName: OnDeviceLlmManage.serverModelName(modelName),
            reply: reply,
          ),
        );
      } catch (_) {
        didSaveReply = false;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('답변은 생성됐지만 서버에 저장하지 못했습니다.')),
          );
        }
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _thinkingText = '';
        _statusText = '';
        _isSending = false;
        _isStreaming = false;
        _isOnDeviceGeneration = false;
        _hasRunningGeneration = false;
      });
      await _saveMetaFromMessages(hasRunningGeneration: false);
      if (didSaveReply) {
        await _syncFromServer(reconnectIfRunning: false);
      }
    } catch (error) {
      await _recoverAfterStreamError(
        fallbackMessage: _errorMessage(error),
        allowReconnect: false,
      );
    }
  }

  Future<void> _handleStreamEvent(LlmStreamEvent event) async {
    if (!mounted) {
      return;
    }

    if (event.isStatus) {
      final stage = event.stage;
      setState(() {
        _statusText = LlmChatStageText.statusMessage(stage);
        _hasRunningGeneration = !LlmChatStageText.isFinishedStage(stage);
      });
      _handleQueueByStage(stage);
      return;
    }

    if (event.isThinking) {
      setState(() {
        _thinkingText += event.text;
        _statusText = 'AI가 답변을 생각하고 있어요.';
      });
      _scrollToBottom();
      return;
    }

    if (event.isToken) {
      _hideQueueModal();
      setState(() {
        LlmChatMessageManager.appendAssistantMessage(_messages, event.text);
        _isSending = false;
        _isStreaming = true;
        _hasRunningGeneration = true;
      });
      await _saveMetaFromMessages(hasRunningGeneration: true);
      _scrollToBottom();
      return;
    }

    if (event.isDone) {
      _hideQueueModal();
      final response = event.response;
      setState(() {
        if (response.isNotEmpty) {
          LlmChatMessageManager.replaceAssistantMessage(_messages, response);
        }
        _thinkingText = '';
        _statusText = '';
        _isSending = false;
        _isStreaming = false;
        _isOnDeviceGeneration = false;
        _hasRunningGeneration = false;
      });
      await _saveMetaFromMessages(hasRunningGeneration: false);
      await _syncFromServer(reconnectIfRunning: false);
      return;
    }

    if (event.isError) {
      _hideQueueModal();
      await _recoverAfterStreamError(
        fallbackMessage: event.detail.isNotEmpty ? event.detail : null,
      );
    }
  }

  Future<void> _recoverAfterStreamError({
    String? fallbackMessage,
    bool allowReconnect = true,
  }) async {
    if (!mounted) {
      return;
    }
    if (allowReconnect &&
        !_isOnDeviceGeneration &&
        _reconnectAttempts < 3 &&
        _threadId != null) {
      _reconnectAttempts += 1;
      try {
        final status = await LlmApi.getLlmStatus(_threadId!);
        final generation = LlmChatMessageManager.mapValue(status['generation']);
        final generationStatus = generation?['status']?.toString() ?? '';
        if (!mounted) {
          return;
        }
        if (generationStatus == 'queued' || generationStatus == 'running') {
          _listenToStream(LlmApi.reconnectLlmStream(_threadId!));
          return;
        }
        await _syncFromServer(reconnectIfRunning: false);
        return;
      } catch (_) {
        // 아래 사용자 안내 메시지로 이어집니다.
      }
    }

    setState(() {
      LlmChatMessageManager.replaceAssistantMessage(_messages,
          fallbackMessage ?? '답변을 찾는 과정에서 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.');
      _statusText = '';
      _thinkingText = '';
      _isSending = false;
      _isStreaming = false;
      _isOnDeviceGeneration = false;
      _hasRunningGeneration = false;
    });
    await _saveMetaFromMessages(hasRunningGeneration: false);
  }

  Future<void> _saveMetaFromMessages({required bool hasRunningGeneration}) {
    return Future.value();
  }

  void _prepareToLeave() {
    if (_didPrepareToLeave) {
      return;
    }
    _didPrepareToLeave = true;
    _hideQueueModal();
    final threadId = _threadId;
    if (threadId == null || threadId.isEmpty) {
      return;
    }

    final hasUserMessage = _messages.any(
      (message) => message.isUser && message.message.trim().isNotEmpty,
    );
    if (!hasUserMessage) {
      LlmBackgroundStreamWatcher.stop(threadId);
      unawaited(LlmApi.deleteLlmEnd(threadId).catchError((_) => false));
      _threadId = null;
      return;
    }

    if (!_isOnDeviceGeneration && (_isStreaming || _hasRunningGeneration)) {
      LlmBackgroundStreamWatcher.watch(
        announcementId: _announcementId,
        title: widget.thisTitle,
        threadId: threadId,
      );
    }
  }

  String _errorMessage(Object error) {
    if (error is StateError) {
      return error.message;
    }
    final text = error.toString().replaceFirst('Exception: ', '');
    return text.isEmpty ? '답변을 찾는 과정에서 오류가 발생했습니다.' : text;
  }

  void _scrollToBottom() {
    if (!mounted) {
      return;
    }
    _scrollManager.scrollToBottom(_scrollController);
  }

  void _handleQueueByStage(String stage) {
    if (LlmChatStageText.isQueueStage(stage)) {
      _showQueueModal(LlmChatStageText.statusMessage(stage));
    } else {
      _hideQueueModal();
    }
  }
}
