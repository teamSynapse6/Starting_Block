import 'dart:async';

import 'package:starting_block/manage/api/llm_api_manage.dart';
import 'package:starting_block/manage/llm_notification_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class LlmBackgroundStreamWatcher {
  LlmBackgroundStreamWatcher._();

  static final Map<String, StreamSubscription<LlmStreamEvent>> _subscriptions =
      {};
  static final Map<String, StringBuffer> _responses = {};

  static void stop(String threadId) {
    _subscriptions.remove(threadId)?.cancel();
    _responses.remove(threadId);
  }

  static void watch({
    required int announcementId,
    required String title,
    required String threadId,
  }) {
    if (_subscriptions.containsKey(threadId)) {
      return;
    }

    final responseBuffer = StringBuffer();
    _responses[threadId] = responseBuffer;

    late StreamSubscription<LlmStreamEvent> subscription;
    subscription = LlmApi.reconnectLlmStream(threadId).listen(
      (event) async {
        if (event.isToken && event.text.isNotEmpty) {
          responseBuffer.write(event.text);
        } else if (event.isDone) {
          final preview = event.response.isNotEmpty
              ? event.response
              : responseBuffer.toString();
          await _finish(
            announcementId: announcementId,
            title: title,
            threadId: threadId,
            preview: preview,
            notify: true,
          );
        } else if (event.isError) {
          await _refreshFromHistory(
            announcementId: announcementId,
            title: title,
            threadId: threadId,
            notify: false,
          );
          stop(threadId);
        }
      },
      onError: (_) async {
        await _refreshFromHistory(
          announcementId: announcementId,
          title: title,
          threadId: threadId,
          notify: false,
        );
        stop(threadId);
      },
      onDone: () async {
        if (_subscriptions.containsKey(threadId)) {
          await _refreshFromHistory(
            announcementId: announcementId,
            title: title,
            threadId: threadId,
            notify: false,
          );
          stop(threadId);
        }
      },
      cancelOnError: true,
    );

    _subscriptions[threadId] = subscription;
  }

  static Future<void> _finish({
    required int announcementId,
    required String title,
    required String threadId,
    required String preview,
    required bool notify,
  }) async {
    final clippedPreview = _clipPreview(preview);
    if (notify) {
      await LlmNotificationManage.showLlmComplete(
        announcementId: announcementId,
        title: title,
        preview: clippedPreview,
      );
    }
    stop(threadId);
  }

  static Future<void> _refreshFromHistory({
    required int announcementId,
    required String title,
    required String threadId,
    required bool notify,
  }) async {
    try {
      final status = await LlmApi.getLlmStatus(threadId);
      final generation = status['generation'];
      final generationStatus = generation is Map<String, dynamic>
          ? generation['status']?.toString() ?? ''
          : '';
      final history = await LlmApi.getLlmHistory(threadId);
      final preview = _lastAssistantPreview(history);

      if (notify && generationStatus == 'completed') {
        await LlmNotificationManage.showLlmComplete(
          announcementId: announcementId,
          title: title,
          preview: preview,
        );
      }
    } catch (_) {}
  }

  static String _lastAssistantPreview(Map<String, dynamic> history) {
    final session = history['session'];
    if (session is! Map<String, dynamic>) {
      return '';
    }
    final messages = session['messages'];
    if (messages is! List) {
      return '';
    }
    for (final item in messages.reversed) {
      if (item is Map<String, dynamic> &&
          item['role']?.toString() == 'assistant') {
        return _clipPreview(item['content']?.toString() ?? '');
      }
    }
    return '';
  }

  static String _clipPreview(String value) {
    final normalized = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length <= 80) {
      return normalized;
    }
    return '${normalized.substring(0, 80)}...';
  }
}
