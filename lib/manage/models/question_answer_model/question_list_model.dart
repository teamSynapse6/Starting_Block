class QuestionListModel {
  final int questionId;
  final String content;
  final int heartCount;
  final int answerCount;
  final bool isMyHeart;

  QuestionListModel.fromJson(Map<String, dynamic> json)
      : questionId = json['questionId'] as int,
        content = json['content'] ?? '',
        heartCount = json['heartCount'] as int,
        answerCount = json['answerCount'] as int,
        isMyHeart = json['isMyHeart'] as bool;
}
