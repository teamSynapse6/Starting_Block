import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class MyPageApi {
  static Future<Map<String, String>> getHeaders() async {
    String? accessToken = await UserTokenManage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

  static String baseUrl = 'https://api.startingblock.co.kr';

  // 내 궁금해요 불러오기
  static Future<List<MyProfileHearModel>> getMyHeart(
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/heart/my');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<MyProfileHearModel> hearts = jsonResponse
          .map((json) => MyProfileHearModel.fromJson(json))
          .toList();
      return hearts;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getMyHeart(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // 내 댓글,답글 불러오기
  static Future<List<MyAnswerReplyModel>> getMyAnswerReply(
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/answer/my');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<MyAnswerReplyModel> replies = jsonResponse
          .map((json) => MyAnswerReplyModel.fromJson(json))
          .toList();
      return replies;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getMyAnswerReply(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // 내 질문 불러오기
  static Future<List<MyProfileQuestion>> getMyQuestion(
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/question/my');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<MyProfileQuestion> questions =
          jsonResponse.map((json) => MyProfileQuestion.fromJson(json)).toList();
      return questions;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getMyQuestion(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }
}
