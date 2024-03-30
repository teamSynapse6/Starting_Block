class QuestionDetailModel {
  final String userName;
  final String content;
  final String createdAt;
  final int heartCount;
  final bool isMyHeart;
  final int? heartId;
  final ContactAnswer contactAnswer;
  final int answerCount;
  final List<AnswerModel> answerList;

  QuestionDetailModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'] ?? '',
        content = json['content'] ?? '',
        createdAt = json['createdAt'] ?? '',
        heartCount = json['heartCount'] as int,
        isMyHeart = json['isMyHeart'] as bool,
        heartId = json['heartId'],
        contactAnswer = ContactAnswer.fromJson(
            json['contactAnswer'] as Map<String, dynamic>),
        answerCount = json['answerCount'] as int,
        answerList = (json['answerList'] as List)
            .map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
            .toList();
}

class ContactAnswer {
  final int answerId;
  final String organizationManager;
  final String content;
  final String createdAt;

  ContactAnswer.fromJson(Map<String, dynamic> json)
      : answerId = json['answerId'] as int,
        organizationManager = json['organizationManger'] ?? '',
        content = json['content'] ?? '',
        createdAt = json['createdAt'] ?? '';
}

class AnswerModel {
  final int answerId;
  final String userName;
  final String content;
  final String createdAt;
  final int heartCount;
  final bool isMyHeart;
  final int? heartId;
  final List<ReplyModel> replyResponse;

  AnswerModel.fromJson(Map<String, dynamic> json)
      : answerId = json['answerId'] as int,
        userName = json['userName'] ?? '',
        content = json['content'] ?? '',
        createdAt = json['createdAt'] ?? '',
        heartCount = json['heartCount'] as int,
        isMyHeart = json['isMyHeart'] as bool,
        heartId = json['heartId'],
        replyResponse = (json['replyResponse'] as List)
            .map((e) => ReplyModel.fromJson(e as Map<String, dynamic>))
            .toList();
}

class ReplyModel {
  final int replyId;
  final String userName;
  final String content;
  final String createdAt;
  final int heartCount;
  final bool isMyHeart;
  final int? heartId;

  ReplyModel.fromJson(Map<String, dynamic> json)
      : replyId = json['replyId'] as int,
        userName = json['userName'] ?? '',
        content = json['content'] ?? '',
        createdAt = json['createdAt'] ?? '',
        heartCount = json['heartCount'] as int,
        isMyHeart = json['isMyHeart'] as bool,
        heartId = json['heartId'];
}
