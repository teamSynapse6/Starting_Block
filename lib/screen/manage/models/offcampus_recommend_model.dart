class OffCampusRecommendModel {
  final String id,
      title,
      organize,
      startDate,
      endDate,
      target,
      age,
      type,
      classification;

  OffCampusRecommendModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['공고제목'] ?? '',
        organize = json['기관'] ?? '',
        startDate = json['등록일'] ?? '',
        endDate = json['마감일'] ?? '',
        target = json['지원대상'] ?? '',
        age = json['나이'] ?? '',
        type = json['지원유형'] ?? '',
        classification = json['구분'] ?? '';
}
