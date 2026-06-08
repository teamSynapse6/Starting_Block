import 'dart:async';

class OnDeviceLlmGenerationSnapshot {
  final String threadId;
  final String messageText;
  final String modelName;
  final String stage;
  final String reply;
  final bool isRunning;
  final bool didSaveReply;
  final String errorMessage;

  const OnDeviceLlmGenerationSnapshot({
    required this.threadId,
    required this.messageText,
    required this.modelName,
    required this.stage,
    required this.reply,
    required this.isRunning,
    required this.didSaveReply,
    required this.errorMessage,
  });

  bool get hasError => errorMessage.isNotEmpty;

  OnDeviceLlmGenerationSnapshot copyWith({
    String? stage,
    String? reply,
    bool? isRunning,
    bool? didSaveReply,
    String? errorMessage,
  }) {
    return OnDeviceLlmGenerationSnapshot(
      threadId: threadId,
      messageText: messageText,
      modelName: modelName,
      stage: stage ?? this.stage,
      reply: reply ?? this.reply,
      isRunning: isRunning ?? this.isRunning,
      didSaveReply: didSaveReply ?? this.didSaveReply,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OnDeviceLlmGenerationTracker {
  OnDeviceLlmGenerationTracker._();

  static final Map<String, OnDeviceLlmGenerationSnapshot> _snapshots = {};
  static final Map<String, StreamController<OnDeviceLlmGenerationSnapshot>>
      _controllers = {};

  static OnDeviceLlmGenerationSnapshot? snapshot(String threadId) {
    return _snapshots[threadId];
  }

  static bool isRunning(String threadId) {
    return _snapshots[threadId]?.isRunning ?? false;
  }

  static Stream<OnDeviceLlmGenerationSnapshot> watch(String threadId) {
    final controller = _controllerFor(threadId);
    final snapshot = _snapshots[threadId];
    if (snapshot == null) {
      return controller.stream;
    }
    return Stream.multi((multiController) {
      multiController.add(snapshot);
      final subscription = controller.stream.listen(
        multiController.add,
        onError: multiController.addError,
        onDone: multiController.close,
      );
      multiController.onCancel = subscription.cancel;
    });
  }

  static void start({
    required String threadId,
    required String messageText,
    required String modelName,
  }) {
    _emit(OnDeviceLlmGenerationSnapshot(
      threadId: threadId,
      messageText: messageText,
      modelName: modelName,
      stage: 'request_received',
      reply: '',
      isRunning: true,
      didSaveReply: false,
      errorMessage: '',
    ));
  }

  static void updateStage(String threadId, String stage) {
    final current = _snapshots[threadId];
    if (current == null) {
      return;
    }
    _emit(current.copyWith(stage: stage, isRunning: true, errorMessage: ''));
  }

  static void appendReply(String threadId, String token) {
    final current = _snapshots[threadId];
    if (current == null) {
      return;
    }
    _emit(current.copyWith(
      stage: 'llm_generating',
      reply: current.reply + token,
      isRunning: true,
      errorMessage: '',
    ));
  }

  static void finishSaving(String threadId) {
    updateStage(threadId, 'session_saved');
  }

  static void finish(String threadId, {required bool didSaveReply}) {
    final current = _snapshots[threadId];
    if (current == null) {
      return;
    }
    _emit(current.copyWith(
      stage: 'session_saved',
      isRunning: false,
      didSaveReply: didSaveReply,
      errorMessage: '',
    ));
  }

  static void fail(String threadId, String errorMessage) {
    final current = _snapshots[threadId];
    if (current == null) {
      return;
    }
    _emit(current.copyWith(
      stage: 'cancelled',
      isRunning: false,
      errorMessage: errorMessage,
    ));
  }

  static void clear(String threadId) {
    _snapshots.remove(threadId);
  }

  static StreamController<OnDeviceLlmGenerationSnapshot> _controllerFor(
      String threadId) {
    return _controllers.putIfAbsent(
      threadId,
      () => StreamController<OnDeviceLlmGenerationSnapshot>.broadcast(),
    );
  }

  static void _emit(OnDeviceLlmGenerationSnapshot snapshot) {
    _snapshots[snapshot.threadId] = snapshot;
    _controllerFor(snapshot.threadId).add(snapshot);
  }
}
