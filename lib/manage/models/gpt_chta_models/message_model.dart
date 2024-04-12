import 'package:html/parser.dart' show parse;

class Message {
  bool isUser;
  String message;
  int time;

  Message({required this.isUser, required this.message, required this.time});

  static String decodeHtmlEntities(String htmlString) {
    var document = parse(htmlString);
    return document.body!.text;
  }

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
      message: decodeHtmlEntities(json['message']),
      time: json['time'],
    );
  }
}
