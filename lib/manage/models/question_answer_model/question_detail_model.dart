class QuestionDetailModel {
  final String userName;
  final int profileNumber;
  final String content;
  final String createdAt;
  final int heartCount;
  final bool isMyHeart;
  final int heartId;
  final ContactAnswer? contactAnswer;
  final int answerCount;
  final List<AnswerModel> answerList;

  QuestionDetailModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'] ?? '',
        profileNumber = json['profileNumber'] ?? 0,
        content = json['content'] ?? '',
        createdAt = json['createdAt'] ?? '',
        heartCount = json['heartCount'] ?? 0,
        isMyHeart = json['isMyHeart'] ?? false,
        heartId = json['heartId'] ?? 0,
        contactAnswer = json['contactAnswer'] != null
            ? ContactAnswer.fromJson(json['contactAnswer'])
            : null,
        answerCount = json['answerCount'] ?? 0,
        answerList = json['answerList'] != null
            ? (json['answerList'] as List)
                .map((e) => AnswerModel.fromJson(e))
                .toList()
            : [];
}

class ContactAnswer {
  final int? answerId;
  final String organizationManager;
  final String content;
  final String createdAt;

  ContactAnswer.fromJson(Map<String, dynamic> json)
      : answerId = json['answerId'],
        organizationManager = json['organizationManager'] ?? '',
        content = json['content'] ?? '',
        createdAt = json['createdAt'] ?? '';
}

class AnswerModel {
  final int answerId;
  final String userName;
  final int profileNumber;
  final String content;
  final String createdAt;
  final int heartCount;
  final bool isMyHeart;
  final int? heartId;
  final bool isMyAnswer;
  final List<ReplyModel> replyResponse;

  AnswerModel.fromJson(Map<String, dynamic> json)
      : answerId = json['answerId'] ?? 0,
        userName = json['userName'] ?? '',
        profileNumber = json['profileNumber'] ?? 0,
        content = json['content'] ?? '',
        createdAt = json['createdAt'] ?? '',
        heartCount = json['heartCount'] ?? 0,
        isMyHeart = json['isMyHeart'] ?? false,
        heartId = json['heartId'],
        isMyAnswer = json['isMyAnswer'] ?? false,
        replyResponse = json['replyResponse'] != null
            ? (json['replyResponse'] as List)
                .map((e) => ReplyModel.fromJson(e))
                .toList()
            : [];
}

class ReplyModel {
  final int replyId;
  final String userName;
  final int profileNumber;
  final String content;
  final String createdAt;
  final int heartCount;
  final bool isMyHeart;
  final int? heartId;
  final bool isMyReply;

  ReplyModel.fromJson(Map<String, dynamic> json)
      : replyId = json['replyId'] ?? 0,
        userName = json['userName'] ?? '',
        profileNumber = json['profileNumber'] ?? 0,
        content = json['content'] ?? '',
        createdAt = json['createdAt'] ?? '',
        heartCount = json['heartCount'] ?? 0,
        isMyHeart = json['isMyHeart'] ?? false,
        heartId = json['heartId'],
        isMyReply = json['isMyReply'] ?? false;
}
