class OffCampusModel {
  final String id,
      startDate,
      endDate,
      title,
      organize,
      target,
      age,
      type,
      classification;

  OffCampusModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['공고제목'] ?? '',
        organize = json['기관'] ?? '',
        startDate = json['등록일'].toString(),
        endDate = json['마감일'].toString(),
        target = json['지원대상'] ?? '',
        age = json['나이'] ?? '',
        type = json['지원유형'] ?? '',
        classification = json['구분'] ?? '';

  // void toJson() {}
}
