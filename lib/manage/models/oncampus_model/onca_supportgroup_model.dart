class OncaSupportGroupModel {
  final int announcementId;
  final String title;
  final String content;
  final bool isBookmarked;

  // JSON 데이터로부터 객체를 생성하는 생성자
  OncaSupportGroupModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] ?? 0,
        // '\n'을 모두 제거
        title = (json['title'] ?? '').replaceAll('/n', ''),
        content = (json['content'] ?? '').replaceAll('/n', ''),
        isBookmarked = json['isBookmarked'] ?? false;
}
