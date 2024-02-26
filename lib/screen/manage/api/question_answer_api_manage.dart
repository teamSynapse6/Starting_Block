import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/screen/manage/model_manage.dart';

class QuestionAnswerApi {
  static String baseUrl = 'http://10.0.2.2:5000';

  //질문 가져오는 메소드
  static Future<List<QuestionModel>> getQuestionData(String questionId) async {
    String url = '$baseUrl/question/$questionId'; // URL에 questionId 포함
    final response = await http
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      // 서버로부터 받은 응답이 성공적이면, JSON 데이터를 파싱하여 QuestionModel 객체 리스트로 반환
      final List<dynamic> questionJson = jsonDecode(response.body);
      List<QuestionModel> questionList =
          questionJson.map((json) => QuestionModel.fromJson(json)).toList();
      return questionList;
    } else {
      // 에러 발생시, 에러 메시지 반환
      throw Exception('Failed to load question data');
    }
  }

  // 질문 생성 메소드
  static Future<String> writeQuestion({
    required String questionId,
    required String questionText,
    required bool forContact,
    required String userUuid,
    required String userName,
    required int profileNum,
  }) async {
    String url = '$baseUrl/question/$questionId/write'; // URL 조합
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'question': questionText,
        'forContact': forContact,
        'uuid': userUuid,
        'nickname': userName,
        'profileNum': profileNum,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 질문이 생성되면, 서버로부터 반환된 qid를 반환
      final responseData = jsonDecode(response.body);
      return responseData['qid'];
    } else {
      // 실패 시, 예외를 발생시켜 호출한 쪽에서 처리할 수 있도록 함
      throw Exception('Failed to write question data');
    }
  }

// 특정 QID에 해당하는 질문 데이터를 가져오는 메소드
  static Future<List<QuestionModel>> getQuestionDataByQid(String qid) async {
    String url = '$baseUrl/questionbyqid/$qid'; // URL에 qid 포함
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // 서버로부터 받은 응답이 성공적이면, JSON 데이터를 파싱하여 QuestionModel 객체 리스트로 반환
      final Map<String, dynamic> questionJson = jsonDecode(response.body);
      // QuestionModel 객체를 리스트에 담아 반환
      return [QuestionModel.fromJson(questionJson)];
    } else {
      // 에러 발생시, 에러 메시지 반환
      throw Exception('Failed to load question data by qid');
    }
  }
}
