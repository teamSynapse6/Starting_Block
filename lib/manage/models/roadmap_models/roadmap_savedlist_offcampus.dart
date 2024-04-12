class RoadMapSavedOffcampus {
  final int announcementId;
  final String department, title, dday;
  final bool isBookMarked;

  RoadMapSavedOffcampus.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] as int,
        department = json['department'] ?? '',
        title = json['title'] ?? '',
        isBookMarked = json['isBookmarked'] as bool,
        dday = json['dday'] ?? '';
}
