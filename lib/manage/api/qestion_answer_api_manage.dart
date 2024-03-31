// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/model_manage.dart';

class QuestionAnswerApi {
  static Map<String, String> headers = {
    'accept': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiaWF0IjoxNzA4Nzg5MjE5LCJleHAiOjIwNjg3ODkyMTl9.QfNiocS_CBaiDrKqK93hfl03MAMJ_Pm9Fy-IibpT37CVlz2RN-SdaUQk9VkGMJcsVNsTIyBrROlQA4eXLk02Pg'
  };

  static String baseUrl = 'https://api.startingblock.co.kr';

  static Future<void> postQuestionWrite(
      int announcementId, String content, bool isContact) async {
    final url = Uri.parse('$baseUrl/api/v1/question/ask');
    final body = jsonEncode({
      "announcementId": announcementId,
      "content": content,
      "isContact": isContact
    });

    try {
      final response = await http.post(url,
          headers: {
            ...headers,
            'Content-Type': 'application/json',
          },
          body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // 200번대 상태 코드에 대한 성공 처리
        print(
            'Question posted successfully. Status code: ${response.statusCode}');
      } else {
        // 서버에서 비정상 응답이 왔을 때의 처리
        print('Failed to post question. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 에러가 발생했을 때의 처리
      print('Error posting question: $e');
    }
  }

  // getQuestionList 메소드 추가
  static Future<List<QuestionListModel>> getQuestionList(
      int announcementId) async {
    final url = Uri.parse('$baseUrl/api/v1/question/$announcementId');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // 응답의 바디를 UTF-8로 디코드
      String body = utf8.decode(response.bodyBytes);
      // 디코드된 문자열을 JSON으로 파싱
      List<dynamic> jsonList = json.decode(body);
      // 파싱된 JSON을 QuestionListModel 객체 리스트로 변환
      List<QuestionListModel> questions = jsonList
          .map((jsonItem) => QuestionListModel.fromJson(jsonItem))
          .toList();
      return questions;
    } else {
      // 에러 처리 또는 빈 리스트 반환
      print('Failed to load questions. Status code: ${response.statusCode}');
      return [];
    }
  }
}
