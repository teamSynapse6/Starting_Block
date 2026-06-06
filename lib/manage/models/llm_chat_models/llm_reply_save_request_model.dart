class LlmReplySaveRequest {
  final String threadId;
  final int announcementId;
  final String modelName;
  final String reply;

  const LlmReplySaveRequest({
    required this.threadId,
    required this.announcementId,
    required this.modelName,
    required this.reply,
  });

  Map<String, dynamic> toJson() {
    return {
      'thread_id': threadId,
      'announcement_id': announcementId,
      'model_name': modelName,
      'reply': reply,
    };
  }
}
