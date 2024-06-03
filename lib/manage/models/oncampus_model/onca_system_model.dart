class OncaSystemModel {
  final int systemId;
  final String title;
  final String target;
  final String content;
  final bool isBookmarked;

  OncaSystemModel.fromJson(Map<String, dynamic> json)
      : systemId = json['systemId'] ?? 0,
        title = (json['title'] ?? ''),
        target = (json['target'] ?? ''),
        content = (json['content'] ?? ''),
        isBookmarked = json['isBookmarked'] ?? false;
}
