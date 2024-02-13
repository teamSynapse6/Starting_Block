import 'package:http/http.dart' as http;
import 'dart:convert';

class SystemApiManage {
  static String baseUrl = 'http://10.0.2.2:5000';
  static String nickNameCheck = 'getUserNickName';

  static Future<bool> getNickNameCheck(String nickname) async {
    final url = Uri.parse('$baseUrl/$nickNameCheck');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'nickname': nickname}),
    );

    if (response.statusCode == 200) {
      // 서버로부터 정상적인 응답을 받았을 때
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      // 파일을 찾을 수 없는 경우, 사용자에게 적절한 메시지를 전달하거나 로직 처리
      print('Nicknames file not found');
      throw Exception('Nicknames file not found');
    } else {
      // 기타 에러 처리
      print('서버 에러: ${response.statusCode}.');
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }
}
