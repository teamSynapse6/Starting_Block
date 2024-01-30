class OnCampusClassModel {
  final String id;
  final String title;
  final String liberal;
  final String credit;
  final List<String> session;
  final String instructor;
  final String content;
  final String classification;

  OnCampusClassModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'] ?? '',
        liberal = json['liberal'] ?? '',
        credit = json['credit'].toString(),
        session = List<String>.from(json['session'] as List<dynamic>),
        instructor = json['instructor'] ?? '',
        content = json['content'] ?? '',
        classification = json['classification'] ?? '';
}
