class OffCampusModel {
  final String id,
      startDate,
      endDate,
      title,
      organize,
      target,
      ageStart, // 변경된 필드 이름
      ageEnd, // 변경된 필드 이름
      type, // 변경된 필드 이름
      classification,
      link,
      saved,
      content,
      region,
      supportType;
  final List<String> postTarget;

  OffCampusModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'] ?? '',
        organize = json['organize'] ?? '',
        startDate = json['startdate'].toString(),
        endDate = json['enddate'].toString(),
        target = json['target'] ?? '',
        ageStart = json['agestart'].toString(), // 변경된 필드 이름
        ageEnd = json['ageend'].toString(), // 변경된 필드 이름
        type = json['supporttype'] ?? '', // 변경된 필드 이름
        classification = json['classification'] ?? '',
        link = json['link'] ?? '',
        saved = json['saved'].toString(),
        content = json['content'] ?? '',
        region = json['region'] ?? '',
        supportType = json['supporttype'] ?? '',
        postTarget = List<String>.from(json['posttarget'] ?? []); // 변경된 필드 이름
}
