// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

class SystemApiManage {
  static String baseUrl = 'http://10.0.2.2:5000';
  static String nickNameCheck = 'getUserNickName';
  static String createUserInfo = 'createuserinfo';

  //닉네임 중복확인 메소드
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

  // 사용자 정보 생성 메소드
  static Future<String> getCreateUserInfo(String nickname) async {
    final url = Uri.parse('$baseUrl/$createUserInfo');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'nickname': nickname}),
    );

    if (response.statusCode == 200) {
      // 서버로부터 정상적인 응답을 받았을 때, 생성된 사용자의 uuid 반환
      final data = jsonDecode(response.body);
      return data['uuid'];
    } else {
      // 에러 처리
      print('서버 에러: ${response.statusCode}.');
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }
}
