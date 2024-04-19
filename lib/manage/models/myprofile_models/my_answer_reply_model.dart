class MyAnswerReplyModel {
  final String announcementType;
  final String announcementName;
  final int questionWriterProfile;
  final String questionWriterName;
  final String questionContent;
  final MyAnswer? myAnswer;
  final MyReply? myReply;

  MyAnswerReplyModel.fromJson(Map<String, dynamic> json)
      : announcementType = json['announcementType'] ?? '',
        announcementName = json['announcementName'] ?? '',
        questionWriterProfile = json['questionWrtierProfile'] ?? 0,
        questionWriterName = json['questionWriterName'] ?? '',
        questionContent = json['questionContent'] ?? '',
        myAnswer = json['myAnswer'] != null
            ? MyAnswer.fromJson(json['myAnswer'])
            : null,
        myReply =
            json['myReply'] != null ? MyReply.fromJson(json['myReply']) : null;
}

class MyAnswer {
  final String answerContent;
  final String createdAt;
  final int heartCount;
  final int replyCount;

  MyAnswer.fromJson(Map<String, dynamic> json)
      : answerContent = json['answerContent'] ?? '',
        createdAt = json['createdAt'] ?? '',
        heartCount = json['heartCount'] ?? 0,
        replyCount = json['replyCount'] ?? 0;
}

class MyReply {
  final int answerWriterProfile;
  final String answerWriterName;
  final String answerContent;
  final List<ReplyDetail> replyList;

  MyReply.fromJson(Map<String, dynamic> json)
      : answerWriterProfile = json['answerWriterProfile'] ?? 0,
        answerWriterName = json['answerWriterName'] ?? '',
        answerContent = json['answerContent'] ?? '',
        replyList = json['replyList'] != null
            ? (json['replyList'] as List)
                .map((e) => ReplyDetail.fromJson(e))
                .toList()
            : [];
}

class ReplyDetail {
  final int replyWriterProfile;
  final String replyWriterName;
  final String replyContent;
  final String createdAt;
  final int heartCount;
  final bool mine;

  ReplyDetail.fromJson(Map<String, dynamic> json)
      : replyWriterProfile = json['replyWriterProfile'] ?? 0,
        replyWriterName = json['replyWriterName'] ?? '',
        replyContent = json['replyContent'] ?? '',
        createdAt = json['createdAt'] ?? '',
        heartCount = json['heartCount'] ?? 0,
        mine = json['mine'] ?? false;
}
