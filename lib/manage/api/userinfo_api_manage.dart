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
      // 새로운 액세스 토큰을 저장
      await UserTokenManage().setAccessToken(newAccessToken);
      await UserTokenManage().setRefreshToken(newRefreshToken);
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

    // 200번대 응답 처리
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // 성공 응답 데이터를 UserSignInModel 객체로 변환
      UserSignInModel signInData =
          UserSignInModel.fromJson(json.decode(response.body));
      return signInData; // 성공 시 UserSignInModel 객체 반환
    } else {
      // 실패 시 예외 던지기
      throw Exception('로그인 실패: ${response.statusCode}');
    }
  }

  // 로그인 시 유저 정보를 불러오는 메소드 추가
  static Future<UserDataModel> getUserInfoData({int retryCount = 1}) async {
    String url = '$baseUrl/api/v1/users/me';
    Map<String, String> headers = await getHeaders();

    // 서버로부터 데이터를 GET 요청을 통해 받아옴
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // UTF-8로 인코딩하여 JSON 데이터 파싱
      Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      return UserDataModel.fromJson(responseData); // 모델 객체로 변환
    } else if (response.statusCode == 401 && retryCount > 0) {
      await updateAccessToken();
      return await getUserInfoData(retryCount: retryCount - 1);
    } else {
      // 다른 오류가 발생한 경우 예외 던지기
      throw Exception(
          '정보 불러오기 실패: ${response.statusCode}, Body: ${response.body}');
    }
  }

  //유저 세부정보 입력
  static Future<bool> patchUserInfo(
      {required String birth,
      required bool isCompletedBusinessRegistration,
      required String residence,
      required String university,
      required int profileNumber,
      int retryCount = 1 // 재시도 횟수를 추가
      }) async {
    String url = '$baseUrl/api/v1/users';
    Map<String, String> headers = await getHeaders();
    Map<String, dynamic> body = {
      'birth': birth,
      'isCompletedBusinessRegistration': isCompletedBusinessRegistration,
      'residence': residence,
      'university': university,
      'profileNumber': profileNumber
    };

    http.Response response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true; // 성공 시 true 반환
    } else if (response.statusCode == 401 && retryCount > 0) {
      await updateAccessToken();
      return await patchUserInfo(
        birth: birth,
        isCompletedBusinessRegistration: isCompletedBusinessRegistration,
        residence: residence,
        university: university,
        profileNumber: profileNumber,
        retryCount: retryCount - 1, // 재시도 횟수 감소
      ); // 재귀 호출
    } else {
      return false; // 실패 시 false 반환
    }
  }

  // 로그아웃 처리 메소드
  static Future<bool> postUserLogOut({int retryCount = 1}) async {
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
      return true; // 성공적으로 로그아웃되면 true 반환
    } else if (response.statusCode == 401) {
      await updateAccessToken();
      return await postDeleteAccount(retryCount: retryCount - 1);
    } else {
      return false; // 로그아웃 실패시 false 반환
    }
  }

  // 회원탈퇴 처리 메소드
  static Future<bool> postDeleteAccount({int retryCount = 1}) async {
    String url = '$baseUrl/api/v1/users/inactive';
    Map<String, String> headers = await getHeaders();

    http.Response response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true; // 성공적으로 계정이 비활성화되면 true 반환
    } else if (response.statusCode == 401 && retryCount > 0) {
      await updateAccessToken();
      return await postDeleteAccount(retryCount: retryCount - 1);
    } else {
      // 계정 비활성화 실패 또는 재시도 횟수 초과 처리
      return false; // 계정 비활성화 실패 시 false 반환
    }
  }

// 닉네임 중복 확인 메소드 및 이름 변경 메소드
  static Future<bool> patchUserNickName(String nickname,
      {int retryCount = 1}) async {
    String url = '$baseUrl/api/v1/users/nickname?nickname=$nickname';
    Map<String, String> headers = await getHeaders();

    http.Response response = await http.patch(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true; // 성공 시 true 반환
    } else if (response.statusCode == 400) {
      return false; // 중복 시 false 반환
    } else if (response.statusCode == 401 && retryCount > 0) {
      await updateAccessToken();
      return await patchUserNickName(nickname,
          retryCount: retryCount - 1); // 재귀 호출
    } else {
      return false; // 실패 시 false 반환
    }
  }
}
