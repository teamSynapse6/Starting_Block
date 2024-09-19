class MyProfileQuestion {
  final int questionId, heartCount, answerCount;
  final String announcementType, announcementName, questionContent;
  final String createdAt, organizationManger, contactAnswerContent;

  MyProfileQuestion.fromJson(Map<String, dynamic> json)
      : questionId = json['questionId'] as int,
        heartCount = json['heartCount'] as int,
        answerCount = json['answerCount'] as int,
        announcementType = json['announcementType'] ?? '',
        announcementName = json['announcementName'] ?? '',
        questionContent = json['questionContent'] ?? '',
        createdAt = json['createdAt'] ?? '',
        organizationManger = json['organizationManger'] ?? '',
        contactAnswerContent = json['contactAnswerContent'] ?? '';
}
