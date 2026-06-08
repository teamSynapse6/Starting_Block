import 'package:starting_block/manage/llm/llm_chat_time_formatter.dart';
import 'package:starting_block/manage/model_manage.dart';

class LlmChatMessageManager {
  const LlmChatMessageManager._();

  static List<Message> messagesFromHistory(Map<String, dynamic> history) {
    final session = mapValue(history['session']);
    if (session == null) {
      return [];
    }
    final time = LlmChatTimeFormatter.timeFromIso(
            session['last_activity']?.toString()) ??
        LlmChatTimeFormatter.formatCurrentTime(DateTime.now());
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

  static Map<String, dynamic>? mapValue(dynamic value) {
    return value is Map<String, dynamic> ? value : null;
  }

  static void upsertAssistantMessageInList(
    List<Message> messages,
    String content,
    int time,
  ) {
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

  static void appendAssistantMessage(List<Message> messages, String text) {
    if (messages.isNotEmpty && !messages.last.isUser) {
      messages[messages.length - 1] = Message(
        isUser: false,
        message: messages.last.message + text,
        time: messages.last.time,
      );
    } else {
      messages.add(Message(
        isUser: false,
        message: text,
        time: LlmChatTimeFormatter.formatCurrentTime(DateTime.now()),
      ));
    }
  }

  static void replaceAssistantMessage(List<Message> messages, String text) {
    if (messages.isNotEmpty && !messages.last.isUser) {
      messages[messages.length - 1] = Message(
        isUser: false,
        message: text,
        time: messages.last.time,
      );
    } else {
      messages.add(Message(
        isUser: false,
        message: text,
        time: LlmChatTimeFormatter.formatCurrentTime(DateTime.now()),
      ));
    }
  }
}
