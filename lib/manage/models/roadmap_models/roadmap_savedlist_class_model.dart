class RoadMapSavedClassModel {
  final String title, liberal, session, instructor, content;
  final int credit;
  final bool isBookmarked;

  RoadMapSavedClassModel.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        liberal = json['liberal'] ?? '',
        credit = json['credit'] as int,
        session = json['session'] ?? '',
        instructor = json['instructor'] ?? '',
        content = json['content'] ?? '',
        isBookmarked = json['isBookmarked'] as bool;
}
