class OnCaClubModel {
  final String content;
  final String title;
  final String type;

  OnCaClubModel.fromJson(Map<String, dynamic> json)
      : content = json['content'] ?? '',
        title = json['title'] ?? '',
        type = json['type'] ?? '';
}
