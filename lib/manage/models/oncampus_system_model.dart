class OnCampusSystemModel {
  final String id, title, type, target, content, classification;

  OnCampusSystemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'] ?? '',
        type = json['type'] ?? '',
        content = json['content'] ?? '',
        target = json['target'] ?? '',
        classification = json['classification'] ?? '';
}
