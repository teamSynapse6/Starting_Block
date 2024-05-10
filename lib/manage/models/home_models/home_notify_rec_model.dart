class HomeAnnouncementRecModel {
  final String announcementType;
  final String keyword;
  final String title;
  final String dday;
  final String detailUrl;
  final int announcementId;

  HomeAnnouncementRecModel.fromJson(Map<String, dynamic> json)
      : announcementType = json['announcementType'] ?? '',
        keyword = json['keyword'] ?? '',
        title = json['title'] ?? '',
        dday = json['dday'] ?? '',
        detailUrl = json['detailUrl'] ?? '',
        announcementId = json['announcementId'] ?? 0;
}
