// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class QuestionAnswerApi {
  static Future<Map<String, String>> getHeaders() async {
    String? accessToken = await UserTokenManage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

  static String baseUrl = 'https://api.startingblock.co.kr';

  // 질문 작성 메소드
  static Future<void> postQuestionWrite(
      int announcementId, String content, bool isContact,
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/question/ask');
    final body = jsonEncode({
      "announcementId": announcementId,
      "content": content,
      "isContact": isContact
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print(
          'Question posted successfully. Status code: ${response.statusCode}');
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return postQuestionWrite(announcementId, content, isContact,
          retryCount: retryCount - 1);
    } else {
      print('Failed to post question. Status code: ${response.statusCode}');
    }
  }

  // 질문 리스트 가져오기 메소드
  static Future<List<QuestionListModel>> getQuestionList(int announcementId,
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/question/$announcementId');
    final response = await http.get(url, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = json.decode(body);
      return jsonList
          .map((jsonItem) => QuestionListModel.fromJson(jsonItem))
          .toList();
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getQuestionList(announcementId, retryCount: retryCount - 1);
    } else {
      print('Failed to load questions. Status code: ${response.statusCode}');
      return [];
    }
  }

  // 질문 상세 정보 가져오기 메소드
  static Future<QuestionDetailModel> getQuestionDetail(int questionId,
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/question/detail/$questionId');
    final response = await http.get(url, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> json =
          jsonDecode(utf8.decode(response.bodyBytes));
      return QuestionDetailModel.fromJson(json);
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getQuestionDetail(questionId, retryCount: retryCount - 1);
    } else {
      print(
          'Failed to load question details. Status code: ${response.statusCode}');
      throw Exception('Failed to load question details.');
    }
  }

  // 답변 작성 메소드
  static Future<void> postAnswerWrite(
      int questionId, String content, bool isContact,
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/answer/send');
    final body = jsonEncode({
      "questionId": questionId,
      "content": content,
      "isContact": isContact,
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Answer posted successfully. Status code: ${response.statusCode}');
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return postAnswerWrite(questionId, content, isContact,
          retryCount: retryCount - 1);
    } else {
      print('Failed to post answer. Status code: ${response.statusCode}');
    }
  }

  // 답글(대댓글) 작성 메소드
  static Future<void> postReplyWrite(int answerId, String content,
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/reply/send');
    final body = jsonEncode({
      "answerId": answerId,
      "content": content,
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Reply posted successfully. Status code: ${response.statusCode}');
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return postReplyWrite(answerId, content, retryCount: retryCount - 1);
    } else {
      print('Failed to post reply. Status code: ${response.statusCode}');
    }
  }

  // 하트(좋아요) 보내기 메소드
  static Future<bool> postHeart(int id, String heartType,
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/heart/send');
    final body = jsonEncode({
      "id": id,
      "heartType": heartType,
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return postHeart(id, heartType, retryCount: retryCount - 1);
    } else {
      print('Failed to send heart. Status code: ${response.statusCode}');
      return false;
    }
  }

  // 하트(좋아요) 취소(삭제) 메소드
  static Future<bool> deleteHeart(int heartId, {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/heart/cancel/$heartId');

    final response = await http.delete(url, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Heart deleted successfully. Status code: ${response.statusCode}');
      return true;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return deleteHeart(heartId, retryCount: retryCount - 1);
    } else {
      print('Failed to delete heart. Status code: ${response.statusCode}');
      return false;
    }
  }

  // 답변 삭제 메소드
  static Future<bool> deleteAnswer(int answerId, {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/answer/cancel/$answerId');
    final response = await http.delete(url, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return deleteAnswer(answerId, retryCount: retryCount - 1);
    } else {
      print('Failed to delete answer. Status code: ${response.statusCode}');
      return false;
    }
  }

  // 답글 삭제 메소드
  static Future<bool> deleteReply(int replyId, {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/reply/cancel/$replyId');
    final response = await http.delete(url, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return deleteReply(replyId, retryCount: retryCount - 1);
    } else {
      print('Failed to delete reply. Status code: ${response.statusCode}');
      return false;
    }
  }
}
