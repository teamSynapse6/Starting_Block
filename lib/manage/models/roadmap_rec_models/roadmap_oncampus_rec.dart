class RoadMapOnCampusRecModel {
  final int announcementId;
  final String department;
  final String detailUrl;
  final String keyword;
  final String title;

  RoadMapOnCampusRecModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] as int,
        department = json['department'] ?? '',
        detailUrl = json['detailUrl'] ?? '',
        keyword = json['keyword'] ?? '',
        title = json['title'] ?? '';
}
