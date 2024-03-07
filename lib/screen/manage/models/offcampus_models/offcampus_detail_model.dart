class OffCampusDetailModel {
  final int id, saved;
  final String organization,
      title,
      content,
      startDate,
      endDate,
      target,
      targetAge,
      supportType,
      link,
      region,
      postTarget,
      classification,
      contact;

  OffCampusDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        organization = json['organization'] ?? '',
        title = json['title'] ?? '',
        content = json['content'] ?? '',
        startDate = json['startDate'] ?? '',
        endDate = json['endDate'] ?? '',
        target = json['target'] ?? '',
        targetAge = json['targetAge'] ?? '',
        supportType = json['supportType'] ?? '',
        link = json['link'] ?? '',
        region = json['region'] ?? '',
        postTarget = json['postTarget'] ?? '',
        saved = json['saved'] as int,
        classification = json['classification'] ?? '',
        contact = json['contact'] ?? '';
}
