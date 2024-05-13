class OncaSystemModel {
  final int systemId;
  final String title;
  final String target;
  final String content;
  final bool isBookmarked;

  OncaSystemModel.fromJson(Map<String, dynamic> json)
      : systemId = json['systemId'] ?? 0,
        title = (json['title'] ?? '').replaceAll('/n', ''),
        target = (json['target'] ?? '')..replaceAll('/n', ''),
        content = (json['content'] ?? '').replaceAll('/n', ''),
        isBookmarked = json['isBookmarked'] ?? false;
}
