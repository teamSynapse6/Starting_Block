// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/model_manage.dart';

class UserInfoManageApi {
  // 헤더를 가져오는 메소드
  static Future<Map<String, String>> getHeaders() async {
    String? accessToken = await UserTokenManage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

  static String baseUrl = 'https://api.startingblock.co.kr';

  // 액세스 토큰 업데이트 메소드
  static Future<void> updateAccessToken() async {
    String url = '$baseUrl/auth/refresh';
    String? refreshToken = await UserTokenManage.getRefreshToken();
    print('갱신 호출됨, 리프레시 토큰: $refreshToken');

    if (refreshToken == null) {
      throw Exception("Refresh token is not available.");
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, dynamic> body = {'refreshToken': refreshToken};
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // 성공적으로 응답 받음
      var responseData = json.decode(response.body);
      String newAccessToken = responseData['accessToken'];
      String newRefreshToken = responseData['refreshToken'];
      print('토큰: $newAccessToken, $newRefreshToken');
      // 새로운 액세스 토큰을 저장
      await UserTokenManage().setAccessToken(newAccessToken);
      await UserTokenManage().setRefreshToken(newRefreshToken);
      print('Access token updated successfully.');
    } else {
      // 실패 시 예외 처리
      throw Exception(
          'Failed to update access token: ${response.statusCode}, ${response.body}');
    }
  }

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
      return signInData; // 성공 시 UserSignInModel 객체 반환
    } else {
      // 실패 시 예외 던지기
      throw Exception('로그인 실패: ${response.statusCode}');
    }
  }

//유저 세부정보 입력
  static Future<bool> patchUserInfo(
      {required String nickname,
      required String birth,
      required bool isCompletedBusinessRegistration,
      required String residence,
      required String university,
      int retryCount = 3 // 재시도 횟수를 추가
      }) async {
    String url = '$baseUrl/api/v1/users';
    Map<String, String> headers = await getHeaders();
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
    print('헤더: $headers, 요청 내용: ${json.encode(body)}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('정보 업데이트 성공');
      return true; // 성공 시 true 반환
    } else if (response.statusCode == 401 && retryCount > 0) {
      await updateAccessToken();
      return await patchUserInfo(
          nickname: nickname,
          birth: birth,
          isCompletedBusinessRegistration: isCompletedBusinessRegistration,
          residence: residence,
          university: university,
          retryCount: retryCount - 1 // 재시도 횟수 감소
          ); // 재귀 호출
    } else {
      return false; // 실패 시 false 반환
    }
  }

  // 로그아웃 처리 메소드
  static Future<bool> postUserLogOut({int retryCount = 3}) async {
    String url = '$baseUrl/auth/sign-out';
    String? refreshToken =
        await UserTokenManage.getRefreshToken(); // refreshToken을 가져옵니다.
    Map<String, String> headers = await getHeaders();
    Map<String, dynamic> body = {'refreshToken': refreshToken};

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('로그아웃 성공');
      return true; // 성공적으로 로그아웃되면 true 반환
    } else if (response.statusCode == 401) {
      await updateAccessToken();
      return await postDeleteAccount(retryCount: retryCount - 1);
    } else {
      print('로그아웃 실패: ${response.statusCode}');
      return false; // 로그아웃 실패시 false 반환
    }
  }

  // 회원탈퇴 처리 메소드
  static Future<bool> postDeleteAccount({int retryCount = 3}) async {
    String url = '$baseUrl/api/v1/users/inactive';
    Map<String, String> headers = await getHeaders();

    http.Response response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('계정 비활성화 성공');
      return true; // 성공적으로 계정이 비활성화되면 true 반환
    } else if (response.statusCode == 401 && retryCount > 0) {
      await updateAccessToken();
      return await postDeleteAccount(retryCount: retryCount - 1);
    } else {
      // 계정 비활성화 실패 또는 재시도 횟수 초과 처리
      print(
          '계정 비활성화 실패 or Maximum retry attempts exceeded: ${response.statusCode}, Body: ${response.body}');
      return false; // 계정 비활성화 실패 시 false 반환
    }
  }
}
