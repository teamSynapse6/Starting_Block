class HomeAnnouncementRecModel {
  final String announcementType;
  final String keyword;
  final String title;
  final String dday;

  HomeAnnouncementRecModel.fromJson(Map<String, dynamic> json)
      : announcementType = json['announcementType'] ?? '',
        keyword = json['keyword'] ?? '',
        title = json['title'] ?? '',
        dday = json['dday'] ?? '';
}
