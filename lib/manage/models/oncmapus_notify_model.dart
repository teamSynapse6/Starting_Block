class OnCampusNotifyModel {
  final String id;
  final String type;
  final String title;
  final String startdate;
  final String classification;
  final String detailurl;
  final int saved;

  OnCampusNotifyModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        type = json['type'] ?? '',
        title = json['title'] ?? '',
        startdate = json['startdate'].toString(),
        classification = json['classification'] ?? '',
        detailurl = json['detailurl'] ?? '',
        saved = json['saved'] as int;
}
