class OncaAnnouncementModel {
  final int announcementId;
  final String keyword;
  final String title;
  final String insertDate;
  final String detailUrl;
  final bool isBookmarked;

  // JSON 데이터로부터 객체를 생성하는 생성자
  OncaAnnouncementModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] ?? 0,
        keyword = json['keyword'] ?? '',
        title = json['title'] ?? '',
        insertDate = json['insertDate'] ?? '',
        detailUrl = json['detailUrl'] ?? '',
        isBookmarked = json['isBookmarked'] ?? false;
}
