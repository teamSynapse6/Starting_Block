class QuestionModel {
  final String userUUID;
  final String userName;
  final String qid;
  final String question;
  final int like;
  final int answerCount;
  final bool contactAnswer;
  final int date;
  final bool forContact;

  QuestionModel.fromJson(Map<String, dynamic> json)
      : userUUID = json['userUUID'].toString(),
        userName = json['userName'] ?? '',
        qid = json['qid'] ?? '',
        question = json['question'] ?? '',
        like = json['like'],
        answerCount = json['answerCount'],
        contactAnswer = json['contactAnswer'],
        date = json['date'],
        forContact = json['forContact'];
}
