class OnCampusSystemModel {
  final String id, title, target, content, classification;

  OnCampusSystemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'] ?? '',
        content = json['content'] ?? '',
        target = json['target'] ?? '',
        classification = json['classification'] ?? '';
}
