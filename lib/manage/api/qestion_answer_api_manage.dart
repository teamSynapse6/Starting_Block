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

  //질문 작성 메소드
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

  // 질문 리스트 가져오기 메소드
  static Future<List<QuestionListModel>> getQuestionList(
      int announcementId) async {
    final url = Uri.parse('$baseUrl/api/v1/question/$announcementId');
    final response = await http.get(url, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
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

  // 질문 상세 정보 가져오기 메소드
  static Future<QuestionDetailModel> getQuestionDetail(int questionId) async {
    final url = Uri.parse('$baseUrl/api/v1/question/detail/$questionId');
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // 응답의 바디를 UTF-8로 디코드
        final Map<String, dynamic> json =
            jsonDecode(utf8.decode(response.bodyBytes));
        // 디코드된 JSON을 QuestionDetailModel 객체로 변환
        return QuestionDetailModel.fromJson(json);
      } else {
        // 에러 처리 또는 null 반환
        print(
            'Failed to load question details. Status code: ${response.statusCode}');
        throw Exception('Failed to load question details.');
      }
    } catch (e) {
      // 요청 중 에러가 발생했을 때의 처리
      print('Error loading question details: $e');
      throw Exception('Failed to load question details.');
    }
  }

  // 답변 작성 메소드
  static Future<void> postAnswerWrite(
      int questionId, String content, bool isContact) async {
    final url = Uri.parse('$baseUrl/api/v1/answer/send');
    final body = jsonEncode({
      "questionId": questionId,
      "content": content,
      "isContact": isContact,
    });

    try {
      final response = await http.post(url,
          headers: {
            ...headers,
            'Content-Type': 'application/json', // 요청 본문이 JSON임을 명시
          },
          body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // 성공적으로 답변이 작성됐을 때의 처리
        print(
            'Answer posted successfully. Status code: ${response.statusCode}');
      } else {
        // 서버에서 비정상 응답이 왔을 때의 처리
        print('Failed to post answer. Status code: ${response.statusCode}');
        // 추가적인 에러 처리를 여기에 구현할 수 있습니다.
      }
    } catch (e) {
      // 요청 중 에러가 발생했을 때의 처리
      print('Error posting answer: $e');
      // 필요에 따라 추가적인 예외 처리를 여기에 구현할 수 있습니다.
    }
  }

  // 답글(대댓글) 작성 메소드
  static Future<void> postReplyWrite(int answerId, String content) async {
    final url = Uri.parse('$baseUrl/api/v1/reply/send');
    final body = jsonEncode({
      "answerId": answerId,
      "content": content,
    });

    try {
      final response = await http.post(url,
          headers: {
            ...headers,
            'Content-Type': 'application/json', // 요청 본문이 JSON임을 명시
          },
          body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // 성공적으로 답글이 작성됐을 때의 처리
        print('Reply posted successfully. Status code: ${response.statusCode}');
      } else {
        // 서버에서 비정상 응답이 왔을 때의 처리
        print('Failed to post reply. Status code: ${response.statusCode}');
        // 추가적인 에러 처리를 여기에 구현할 수 있습니다.
      }
    } catch (e) {
      // 요청 중 에러가 발생했을 때의 처리
      print('Error posting reply: $e');
      // 필요에 따라 추가적인 예외 처리를 여기에 구현할 수 있습니다.
    }
  }
}
