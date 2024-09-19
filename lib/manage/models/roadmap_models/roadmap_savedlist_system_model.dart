class RoadMapSavedSystemModel {
  final int announcementId;
  final String title, target, content;
  final bool isBookmarked;

  RoadMapSavedSystemModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] as int,
        title = json['title'] ?? '',
        target = json['target'] ?? '',
        content = json['content'] ?? '',
        isBookmarked = json['isBookmarked'] as bool;
}
