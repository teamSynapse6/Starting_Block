class RoadMapClassRecModel {
  final int lectureId;
  final bool isBookmarked;
  final String title;
  final String liberal;
  final int credit;
  final String session;
  final String instructor;
  final String content;

  RoadMapClassRecModel.fromJson(Map<String, dynamic> json)
      : lectureId = json['lectureId'] as int,
        isBookmarked = json['isBookmarked'] as bool,
        title = json['title'] ?? '',
        liberal = json['liberal'] ?? '',
        credit = json['credit'] as int,
        session = json['session'] ?? '',
        instructor = json['instructor'] ?? '',
        content = json['content'] ?? '';
}
