// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/model_manage.dart';

class UserInfoManageApi {
  static Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiaWF0IjoxNzA4Nzg5MjE5LCJleHAiOjIwNjg3ODkyMTl9.QfNiocS_CBaiDrKqK93hfl03MAMJ_Pm9Fy-IibpT37CVlz2RN-SdaUQk9VkGMJcsVNsTIyBrROlQA4eXLk02Pg'
  };

  static String baseUrl = 'https://api.startingblock.co.kr';

  //로그인 처리 메소드
  static Future<UserSignInModel> postSignIn(
      String providerId, String email) async {
    String url = '$baseUrl/auth/sign-in';
    Map<String, String> headers = {
      'Content-Type': 'application/json' // JSON 콘텐츠 타입 명시
    };
    Map<String, dynamic> body = {'providerId': providerId, 'email': email};

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
    print('요청 내용: ${json.encode(body)}');

    // 200번대 응답 처리
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('로그인 성공');
      // 성공 응답 데이터를 UserSignInModel 객체로 변환
      UserSignInModel signInData =
          UserSignInModel.fromJson(json.decode(response.body));
      print('로그인 토큰: ${signInData.accessToken}');
      return signInData; // 성공 시 UserSignInModel 객체 반환
    } else {
      // 실패 시 예외 던지기
      throw Exception('로그인 실패: ${response.statusCode}');
    }
  }

  //유저 세부정보 입력
  static Future<void> patchUserInfo({
    required String nickname,
    required String birth,
    required bool isCompletedBusinessRegistration,
    required String residence,
    required String university,
  }) async {
    String url = '$baseUrl/api/v1/users';
    Map<String, dynamic> body = {
      'nickname': nickname,
      'birth': birth,
      'isCompletedBusinessRegistration': isCompletedBusinessRegistration,
      'residence': residence,
      'university': university
    };

    http.Response response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('정보 업데이트 성공');
    } else {
      print('정보 업데이트 실패: ${response.statusCode}');
    }
  }
}
