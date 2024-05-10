class OncaClassModel {
  final int lectureId;
  final String title;
  final String liberal;
  final int credit;
  final String session;
  final String instructor;
  final String content;
  final bool isBookmarked;

  // JSON 데이터로부터 객체를 생성하는 생성자
  OncaClassModel.fromJson(Map<String, dynamic> json)
      : lectureId = json['lectureId'] ?? 0,
        title = json['title'] ?? '',
        liberal = json['liberal'] ?? '',
        credit = json['credit'] ?? 0,
        session = json['session'] ?? '',
        instructor = json['instructor'] ?? '',
        content = json['content'] ?? '',
        isBookmarked = json['isBookmarked'] ?? false;
}
