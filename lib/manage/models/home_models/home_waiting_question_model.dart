class HomeWaitingQuestionModel {
  final int announcementId;
  final String announcementType;
  final String announcementTitle;
  final int questionId;
  final String questionContent;
  final int heartCount;
  final String createdAt;

  HomeWaitingQuestionModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] ?? 0,
        announcementType = json['announcementType'] ?? '',
        announcementTitle = json['announcementTitle'] ?? '',
        questionId = json['questionId'] ?? 0,
        questionContent = json['questionContent'] ?? '',
        heartCount = json['heartCount'] ?? 0,
        createdAt = json['createdAt'] ?? '';
}
