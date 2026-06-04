class LlmConversationSummary {
  final String threadId;
  final int announcementId;
  final String lastMessage;
  final DateTime? lastMessageCreatedAt;
  final String title;

  const LlmConversationSummary({
    required this.threadId,
    required this.announcementId,
    required this.lastMessage,
    required this.lastMessageCreatedAt,
    required this.title,
  });

  factory LlmConversationSummary.fromJson(Map<String, dynamic> json) {
    return LlmConversationSummary(
      threadId: json['thread_id']?.toString() ?? '',
      announcementId: _toInt(json['announcement_id']),
      lastMessage: json['last_message']?.toString() ?? '',
      lastMessageCreatedAt:
          DateTime.tryParse(json['last_message_created_at']?.toString() ?? ''),
      title: json['title']?.toString() ?? '',
    );
  }

  int get lastDate {
    final date = lastMessageCreatedAt;
    if (date == null) {
      return 0;
    }
    return int.parse(
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}');
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
