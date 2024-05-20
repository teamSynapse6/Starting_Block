class RoadMapOffCampusRecModel {
  final int announcementId;
  final String department;
  final String title;

  RoadMapOffCampusRecModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] as int,
        department = json['department'] ?? '',
        title = json['title'] ?? '';
}
