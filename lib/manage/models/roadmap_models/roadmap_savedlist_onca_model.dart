class RoadMapSavedOncaModel {
  final int announcementId;
  final String keyword, title, insertDate, detailUrl;
  final bool isBookmarked;

  RoadMapSavedOncaModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] as int,
        keyword = json['keyword'] ?? '',
        title = json['title'] ?? '',
        insertDate = json['insertDate'] ?? '',
        detailUrl = json['detailUrl'] ?? '',
        isBookmarked = json['isBookmarked'] as bool;
}
