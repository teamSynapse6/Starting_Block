class RoadMapSystemRecModel {
  final int announcementId;
  final String title;
  final String target;
  final String content;
  final bool isBookmarked;

  RoadMapSystemRecModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] as int,
        title = json['title'] ?? '',
        target = json['target'] ?? '',
        content = json['content'] ?? '',
        isBookmarked = json['isBookmarked'] as bool;
}
