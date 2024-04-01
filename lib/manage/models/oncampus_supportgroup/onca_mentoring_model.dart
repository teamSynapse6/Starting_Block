class OnCaMentoringModel {
  final String content;
  final String title;
  final String type;

  OnCaMentoringModel.fromJson(Map<String, dynamic> json)
      : content = json['content'] ?? '',
        title = json['title'] ?? '',
        type = json['type'] ?? '';
}
