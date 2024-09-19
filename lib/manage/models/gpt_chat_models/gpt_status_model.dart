class GptStatusModel {
  final String status;
  final String message;

  GptStatusModel({required this.status, required this.message});

  GptStatusModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'];
}
