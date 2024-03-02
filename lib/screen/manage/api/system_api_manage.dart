// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

class SystemApiManage {
  static String baseUrl = 'http://10.0.2.2:5000';
  // static String baseUrl = 'https://leeyuchul.pythonanywhere.com';
  static String nickNameCheck = 'getUserNickName';
  static String createUserInfo = 'createuserinfo';
  static String changeNickName = 'changeNickName';

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

// 사용자 정보 생성 메소드 수정
  static Future<String> getCreateUserInfo(
      String nickname, String kakaoUserID) async {
    final url = Uri.parse('$baseUrl/$createUserInfo'); // URL 확인 및 조정
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      // nickname과 kakaoUserID 둘 다 포함하여 요청 본문(body) 구성
      body: jsonEncode({'nickname': nickname, 'kakaoUserID': kakaoUserID}),
    );

    if (response.statusCode == 200) {
      // 서버로부터 정상적인 응답을 받았을 때, 생성된 사용자의 uuid 반환
      final Map<String, dynamic> data = jsonDecode(response.body);
      // JSON 객체에서 'uuid' 키를 사용하여 uuid 값을 추출
      String uuid = data['uuid'];
      return uuid;
    } else {
      // 에러 처리
      print('서버 에러: ${response.statusCode}. ${response.body}');
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }

  // 닉네임 변경 메소드
  static Future<bool> getChangeNickName(String uuid, String newNickname) async {
    final url = Uri.parse('$baseUrl/$changeNickName');

    print('요청형태: $url with uuid: $uuid and nickname: $newNickname');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'uuid': uuid, 'nickname': newNickname}),
    );

    if (response.statusCode == 200) {
      // 닉네임 변경이 성공적으로 이루어졌을 때
      return true;
    } else {
      // 변경 실패 또는 기타 에러 처리
      print(
          '서버 에러 또는 닉네임 변경 실패: ${response.statusCode}. ${jsonDecode(response.body)}');
      return false;
    }
  }
}
