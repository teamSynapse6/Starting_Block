import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GptListManage {
  // 'chat_'로 시작하는 모든 키의 데이터를 불러오고 List<GptListModel>로 반환하는 static 메소드
  static Future<List<GptListModel>> loadChatData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final filteredKeys = keys.where((key) => key.startsWith('chat_'));

    List<GptListModel> tempList = [];
    for (String key in filteredKeys) {
      var value = prefs.getString(key);
      if (value != null) {
        dynamic jsonData = jsonDecode(value);
        List<dynamic> messages = jsonData['messages'];
        if (messages.isNotEmpty) {
          Map<String, dynamic> lastMessageData = messages.last;
          Map<String, dynamic> modelData = {
            'id': key.substring('chat_'.length),
            'title': jsonData['title'] ?? '',
            'lastMessage': lastMessageData['message'] ?? '',
            'lastDate': lastMessageData['time'] ?? 0
          };
          tempList.add(GptListModel.fromJson(modelData));
        }
      }
    }

    return tempList;
  }
}

class GptListModel {
  final int id;
  final String title;
  final String lastMessage;
  final int lastDate;

  // fromJson 생성자를 사용하여 인스턴스 초기화
  GptListModel.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        title = json['title'] ?? '',
        lastMessage = json['lastMessage'] ?? '',
        lastDate = json['lastDate'] ?? 0;
}
