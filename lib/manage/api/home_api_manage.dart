// import the model file at the top of the API file
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class HomeApi {
  static Future<Map<String, String>> getHeaders() async {
    String? accessToken = await UserTokenManage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

  static String baseUrl = 'https://api.startingblock.co.kr';

  //질문 발송 상태 조회 메소드
  static Future<List<HomeQuestionStatusModel>> getHomeQuestionStatus(
      {int retryCount = 1}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/question/my/status');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<HomeQuestionStatusModel> statusList = jsonResponse
          .map((json) => HomeQuestionStatusModel.fromJson(json))
          .toList();
      return statusList;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getHomeQuestionStatus(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  //
  static Future<List<HomeAnnouncementRecModel>> getAnnouncementRecommend(
      {int retryCount = 1}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/announcements/custom');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<HomeAnnouncementRecModel> notifyList = jsonResponse
          .map((json) => HomeAnnouncementRecModel.fromJson(json))
          .toList();
      return notifyList;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getAnnouncementRecommend(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }
}
