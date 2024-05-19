class RoadMapSavedClassModel {
  final String title, liberal, session, instructor, content;
  final int credit, lectureId;
  final bool isBookmarked;

  RoadMapSavedClassModel.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        liberal = json['liberal'] ?? '',
        credit = json['credit'] as int,
        lectureId = json['lectureId'] as int,
        session = json['session'] ?? '',
        instructor = json['instructor'] ?? '',
        content = json['content'] ?? '',
        isBookmarked = json['isBookmarked'] as bool;
}
