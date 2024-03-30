class Message {
  bool isUser;
  String message;
  int time;

  Message({required this.isUser, required this.message, required this.time});

  Map<String, dynamic> toJson() {
    return {
      'isUser': isUser,
      'message': message,
      'time': time,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isUser: json['isUser'],
      message: json['message'],
      time: json['time'],
    );
  }
}
