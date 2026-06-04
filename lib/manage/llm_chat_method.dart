part of '../screen/llm_chat/llm_chat_screen.dart';

mixin LlmChatMethods on State<LlmChatScreen> {
  ScrollController get _scrollController;
  TextEditingController get _controller;

  StreamSubscription<LlmStreamEvent>? get _streamSubscription;
  set _streamSubscription(StreamSubscription<LlmStreamEvent>? value);

  bool get _isTyped;
  set _isTyped(bool value);
  set _isInitializing(bool value);
  set _isSending(bool value);
  bool get _isStreaming;
  set _isStreaming(bool value);
  bool get _hasRunningGeneration;
  set _hasRunningGeneration(bool value);

  int get _reconnectAttempts;
  set _reconnectAttempts(int value);
  int get _announcementId;

  String? get _threadId;
  set _threadId(String? value);
  set _statusText(String value);
  String get _thinkingText;
  set _thinkingText(String value);
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
      final meta = await LlmListManage.loadChatMeta(_announcementId);
      var threadId = meta?.threadId ?? '';

      if (threadId.isEmpty) {
        threadId = await LlmApi.getLlmStart();
        await LlmListManage.upsertChatMeta(
          announcementId: _announcementId,
          title: widget.thisTitle,
          threadId: threadId,
          lastUpdatedAt: _formatCurrentTime(DateTime.now()),
          hasRunningGeneration: false,
        );
      }

      LlmBackgroundStreamWatcher.stop(threadId);

      if (!mounted) {
        return;
      }
      setState(() {
        _threadId = threadId;
      });

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
            time: _formatCurrentTime(DateTime.now()),
          ),
        ];
        _isInitializing = false;
      });
    }
  }

  Future<void> _syncFromServer({required bool reconnectIfRunning}) async {
    final threadId = _threadId;
    if (threadId == null || threadId.isEmpty) {
      return;
    }

    final status = await LlmApi.getLlmStatus(threadId);
    final history = await LlmApi.getLlmHistory(threadId);
    final messages = _messagesFromHistory(history);
    final generation = _mapValue(status['generation']);
    final session = _mapValue(status['session']);

    if (session == null && messages.isEmpty) {
      final newThreadId = await LlmApi.getLlmStart();
      await LlmListManage.upsertChatMeta(
        announcementId: _announcementId,
        title: widget.thisTitle,
        threadId: newThreadId,
        lastUpdatedAt: _formatCurrentTime(DateTime.now()),
        hasRunningGeneration: false,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _threadId = newThreadId;
        _messages = [];
        _isInitializing = false;
        _isSending = false;
        _isStreaming = false;
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
          time: _formatCurrentTime(DateTime.now()),
        ));
      }
    }
    if (isRunning) {
      _upsertAssistantMessageInList(
        nextMessages,
        partialResponse,
        _formatCurrentTime(DateTime.now()),
      );
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _messages = nextMessages;
      _thinkingText = thinkingResponse;
      _statusText = isRunning ? _statusMessage(generationStage) : '';
      _isInitializing = false;
      _isSending = false;
      _isStreaming = isRunning;
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

    FocusScope.of(context).unfocus();
    final now = _formatCurrentTime(DateTime.now());

    setState(() {
      _messages.add(Message(isUser: true, message: messageText, time: now));
      _messages.add(Message(isUser: false, message: '', time: now));
      _controller.clear();
      _isTyped = false;
      _isSending = true;
      _isStreaming = true;
      _hasRunningGeneration = true;
      _statusText = 'AI가 질문을 확인하고 있어요.';
      _thinkingText = '';
    });
    _scrollToBottom();

    await _saveMetaFromMessages(hasRunningGeneration: true);
    _listenToStream(
      LlmApi.postLlmChat(threadId, messageText, _announcementId),
    );
  }

  void _listenToStream(Stream<LlmStreamEvent> stream) {
    _streamSubscription?.cancel();
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

  Future<void> _handleStreamEvent(LlmStreamEvent event) async {
    if (!mounted) {
      return;
    }

    if (event.isStatus) {
      final stage = event.stage;
      setState(() {
        _statusText = _statusMessage(stage);
        _hasRunningGeneration = !_isFinishedStage(stage);
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
        _appendAssistantMessage(event.text);
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
          _replaceAssistantMessage(response);
        }
        _thinkingText = '';
        _statusText = '';
        _isSending = false;
        _isStreaming = false;
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

  Future<void> _recoverAfterStreamError({String? fallbackMessage}) async {
    if (!mounted) {
      return;
    }
    if (_reconnectAttempts < 3 && _threadId != null) {
      _reconnectAttempts += 1;
      try {
        final status = await LlmApi.getLlmStatus(_threadId!);
        final generation = _mapValue(status['generation']);
        final generationStatus = generation?['status']?.toString() ?? '';
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
      _replaceAssistantMessage(
          fallbackMessage ?? '답변을 찾는 과정에서 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.');
      _statusText = '';
      _thinkingText = '';
      _isSending = false;
      _isStreaming = false;
      _hasRunningGeneration = false;
    });
    await _saveMetaFromMessages(hasRunningGeneration: false);
  }

  Future<void> _saveMetaFromMessages({required bool hasRunningGeneration}) {
    final preview = _lastPreview();
    return LlmListManage.upsertChatMeta(
      announcementId: _announcementId,
      title: widget.thisTitle,
      threadId: _threadId ?? '',
      lastPreview: preview,
      lastUpdatedAt: _formatCurrentTime(DateTime.now()),
      hasRunningGeneration: hasRunningGeneration,
    );
  }

  List<Message> _messagesFromHistory(Map<String, dynamic> history) {
    final session = _mapValue(history['session']);
    if (session == null) {
      return [];
    }
    final time = _timeFromIso(session['last_activity']?.toString()) ??
        _formatCurrentTime(DateTime.now());
    final rawMessages = session['messages'];
    if (rawMessages is! List) {
      return [];
    }
    return rawMessages
        .whereType<Map<String, dynamic>>()
        .where((item) =>
            item['role']?.toString() == 'user' ||
            item['role']?.toString() == 'assistant')
        .map((item) => Message(
              isUser: item['role']?.toString() == 'user',
              message: item['content']?.toString() ?? '',
              time: time,
            ))
        .toList();
  }

  Map<String, dynamic>? _mapValue(dynamic value) {
    return value is Map<String, dynamic> ? value : null;
  }

  void _upsertAssistantMessageInList(
      List<Message> messages, String content, int time) {
    if (messages.isNotEmpty && !messages.last.isUser) {
      messages[messages.length - 1] = Message(
        isUser: false,
        message: content,
        time: messages.last.time,
      );
      return;
    }
    messages.add(Message(isUser: false, message: content, time: time));
  }

  void _appendAssistantMessage(String text) {
    if (_messages.isNotEmpty && !_messages.last.isUser) {
      _messages[_messages.length - 1] = Message(
        isUser: false,
        message: _messages.last.message + text,
        time: _messages.last.time,
      );
    } else {
      _messages.add(Message(
        isUser: false,
        message: text,
        time: _formatCurrentTime(DateTime.now()),
      ));
    }
  }

  void _replaceAssistantMessage(String text) {
    if (_messages.isNotEmpty && !_messages.last.isUser) {
      _messages[_messages.length - 1] = Message(
        isUser: false,
        message: text,
        time: _messages.last.time,
      );
    } else {
      _messages.add(Message(
        isUser: false,
        message: text,
        time: _formatCurrentTime(DateTime.now()),
      ));
    }
  }

  void _prepareToLeave() {
    _hideQueueModal();
    final threadId = _threadId;
    if (threadId != null &&
        threadId.isNotEmpty &&
        (_isStreaming || _hasRunningGeneration)) {
      LlmBackgroundStreamWatcher.watch(
        announcementId: _announcementId,
        title: widget.thisTitle,
        threadId: threadId,
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  int _formatCurrentTime(DateTime currentTime) {
    return int.parse(
        '${currentTime.year}${currentTime.month.toString().padLeft(2, '0')}${currentTime.day.toString().padLeft(2, '0')}${currentTime.hour.toString().padLeft(2, '0')}${currentTime.minute.toString().padLeft(2, '0')}');
  }

  int? _timeFromIso(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return null;
    }
    return _formatCurrentTime(parsed.toLocal());
  }

  String _lastPreview() {
    for (final message in _messages.reversed) {
      if (!message.isUser && message.message.trim().isNotEmpty) {
        return _clipPreview(message.message);
      }
    }
    return _messages.isNotEmpty ? _clipPreview(_messages.last.message) : '';
  }

  String _clipPreview(String value) {
    final normalized = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length <= 80) {
      return normalized;
    }
    return '${normalized.substring(0, 80)}...';
  }

  String _statusMessage(String stage) {
    switch (stage) {
      case 'dynamic_slot_acquired':
        return '스타터가 질문을 상세히 살펴보고 있어요';
      case 'dynamic_queue_waiting':
        return '스타터가 답변 순서를 기다리고 있어요';
      case 'queue_waiting':
        return '스타터가 답변 순서를 기다리고 있어요';
      case 'gpu_waiting':
        return '스타터가 도구를 준비하고 있어요';
      case 'request_received':
        return '스타터가 질문을 확인하고 있어요';
      case 'session_loaded':
      case 'history_optimized':
        return '이전 대화를 살펴보고 있어요';
      case 'rag_searched':
      case 'rag_context_prepared':
      case 'fallback_context_loaded':
        return '공고 내용을 찾아보고 있어요';
      case 'llm_model_ready':
      case 'llm_generating':
      case 'llm_thinking':
        return '답변을 생각하고 있어요';
      case 'llm_response_generated':
      case 'session_saved':
        return '답변을 정리하고 있어요';
      case 'stream_waiting':
        return '이어받을 답변을 기다리고 있어요';
      case 'cancelled':
        return '답변 생성이 중단됐어요';
      default:
        return stage.isEmpty ? '답변을 준비하고 있어요' : stage;
    }
  }

  bool _isQueueStage(String stage) {
    return stage == 'dynamic_queue_waiting' ||
        stage == 'queue_waiting' ||
        stage == 'gpu_waiting' ||
        stage == 'stream_waiting';
  }

  bool _isFinishedStage(String stage) {
    return stage == 'cancelled' || stage == 'session_saved';
  }

  void _handleQueueByStage(String stage) {
    if (_isQueueStage(stage)) {
      _showQueueModal(_statusMessage(stage));
    } else {
      _hideQueueModal();
    }
  }
}
