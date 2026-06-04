class LlmStatusModel {
  final String status;
  final String message;

  LlmStatusModel({required this.status, required this.message});

  LlmStatusModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'];
}
