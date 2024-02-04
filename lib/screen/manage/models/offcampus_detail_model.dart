class OffCampusDetailModel {
  final String id,
      startDate,
      endDate,
      title,
      organize,
      target,
      age,
      type,
      classification,
      link, // 추가된 필드
      saved, // 추가된 필드
      content, // 추가된 필드
      region, // 추가된 필드
      postTarget, // 추가된 필드
      supportType; // 추가된 필드

  OffCampusDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'] ?? '',
        organize = json['organize'] ?? '',
        startDate = json['startdate'].toString(),
        endDate = json['enddate'].toString(),
        target = json['target'] ?? '',
        age = json['age'].toString(), // int를 string으로 변환
        type = json['supporttype'] ?? '',
        classification = json['content'] ?? '', // content 필드로 수정
        link = json['link'] ?? '', // 추가된 필드
        saved = json['saved'].toString(), // 추가된 필드
        content = json['content'] ?? '', // 추가된 필드
        region = json['region'] ?? '', // 추가된 필드
        postTarget = json['posttarget'].toString(), // 추가된 필드
        supportType = json['supporttype'] ?? ''; // 추가된 필드
}
