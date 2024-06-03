import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/model_manage.dart';

class GptApi {
  static String baseUrl = 'https://pdfgpt.startingblock.co.kr';
  // static String baseUrl = 'http://10.0.2.2:5001'; //내부 서버 테스트용
  static String gptStart = 'gpt/start';
  static String gptChat = 'gpt/chat';
  static String gptEnd = 'gpt/end';

  //대화를 위한 쓰레드 생성 메소드
  static Future<String> getGptStart() async {
    final gptStartUrl = Uri.parse('$baseUrl/$gptStart');
    final response = await http.get(gptStartUrl);
    final threadId = jsonDecode(response.body)['thread_id'];
    return threadId;
  }

  //채팅 메소드
  static Future<String> postGptChat(String threadId, String message) async {
    final gptChatUrl = Uri.parse('$baseUrl/$gptChat');
    final response = await http.post(
      gptChatUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'thread_id': threadId,
        'message': message,
      }),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final chatResponse = responseData['response'];
      return chatResponse;
    } else {
      throw Exception('Failed to load chat data');
    }
  }

  //대화 종료를 위한 쓰레드 삭제 메소드
  static Future<bool> deleteGptEnd(String threadId) async {
    // URI에 thread_id 쿼리 파라미터를 추가하여 완성된 URL을 생성합니다.
    final gptEndUrl = Uri.parse('$baseUrl/$gptEnd?thread_id=$threadId');

    // HTTP DELETE 요청을 보내고 응답을 받습니다.
    final response = await http.delete(gptEndUrl);

    // 응답 데이터를 JSON 형태로 디코딩합니다.
    final responseData = jsonDecode(response.body);

    // 'deleted' 키의 값을 확인하여 삭제 성공 여부를 반환합니다.
    // 성공적으로 삭제되었다면 true를, 그렇지 않다면 false를 반환합니다.
    return responseData['deleted'] ?? false;
  }

  // OpenAi GPT API 서버 Status 호출 메소드
  static Future<GptStatusModel> getGptApiStatus() async {
    final statusUrl =
        Uri.parse('https://status.openai.com/api/v2/incidents/unresolved.json');
    final response = await http.get(statusUrl);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return GptStatusModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load status data');
    }
  }
}
