class MyProfileHearModel {
  final int questionId, answerCount;
  final String announcementType, announcementName, questionContent;

  MyProfileHearModel.fromJson(Map<String, dynamic> json)
      : questionId = json['questionId'] as int,
        answerCount = json['answerCount'] as int,
        announcementType = json['announcementType'] ?? '',
        announcementName = json['announcementName'] ?? '',
        questionContent = json['questionContent'] ?? '';
}
