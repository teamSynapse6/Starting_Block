class LlmChatRequest {
  final String threadId;
  final String message;
  final int announcementId;

  const LlmChatRequest({
    required this.threadId,
    required this.message,
    required this.announcementId,
  });

  Map<String, dynamic> toJson() {
    return {
      'thread_id': threadId,
      'message': message,
      'announcement_id': announcementId,
    };
  }
}
