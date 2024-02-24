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
}
