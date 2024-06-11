class HomeQuestionStatusModel {
  final int questionId;
  final String title, content;
  final String receptionTime, sendTime, arriveTime;

  int get questionStage => _computeQuestionStage();
  String get formattedReceptionTime => _formatToMMDD(receptionTime);
  String get formattedSendTime => _formatToMMDD(sendTime);
  String get formattedArriveTime => _formatToMMDD(arriveTime);

  HomeQuestionStatusModel.fromJson(Map<String, dynamic> json)
      : questionId = json['questionId'] as int,
        title = json['title'] ?? '',
        content = json['content'] ?? '',
        receptionTime = json['receptionTime'] ?? '',
        sendTime = json['sendTime'] ?? '',
        arriveTime = json['arriveTime'] ?? '';

  int _computeQuestionStage() {
    if (receptionTime.isNotEmpty && sendTime.isEmpty && arriveTime.isEmpty) {
      return 1; // receptionTime만 null이 아닌 경우
    } else if (receptionTime.isNotEmpty &&
        sendTime.isNotEmpty &&
        arriveTime.isEmpty) {
      return 2; // receptionTime과 sendTime 모두 null이 아닌 경우
    } else if (arriveTime.isNotEmpty) {
      return 3; // arriveTime이 null이 아닌 경우
    }
    return 1; // 기본값
  }

  String _formatToMMDD(String dateTime) {
    if (dateTime.isEmpty) return '';

    try {
      final DateTime parsedDate = DateTime.parse(dateTime);
      final String formattedDate =
          '${parsedDate.month.toString().padLeft(2, '0')}.${parsedDate.day.toString().padLeft(2, '0')}';
      return formattedDate;
    } catch (e) {
      return '';
    }
  }
}
