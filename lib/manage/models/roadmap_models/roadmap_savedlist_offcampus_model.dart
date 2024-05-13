class RoadMapSavedOffcampusModel {
  final int announcementId;
  final String department, title, dday;
  final bool isBookMarked;

  RoadMapSavedOffcampusModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] as int,
        department = json['department'] ?? '',
        title = json['title'] ?? '',
        isBookMarked = json['isBookmarked'] as bool,
        dday = json['dday'] ?? '';
}
