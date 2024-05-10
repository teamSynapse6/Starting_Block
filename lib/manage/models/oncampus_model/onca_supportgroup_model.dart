class OncaSupportGroupModel {
  final int announcementId;
  final String title;
  final String content;
  final bool isBookmarked;

  // JSON 데이터로부터 객체를 생성하는 생성자
  OncaSupportGroupModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] ?? 0,
        title = json['title'] ?? '',
        content = json['content'] ?? '',
        isBookmarked = json['isBookmarked'] ?? false;
}
