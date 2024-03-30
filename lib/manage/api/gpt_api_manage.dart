import 'dart:convert';
import 'package:http/http.dart' as http;

class GptApi {
  static String baseUrl = 'https://pdfgpt.startingblock.co.kr/';
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
  static Future<String> postGptChat(
      String threadId, String announcementId, String message) async {
    final gptChatUrl = Uri.parse('$baseUrl/$gptChat');
    final response = await http.post(
      gptChatUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'thread_id': threadId,
        'announcement_id': announcementId,
        'message': message,
      }),
    );
    print('보낸 메시지: $threadId, $announcementId, $message');
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final chatResponse = responseData['response'];
      print('받은 메시지: $chatResponse');
      return chatResponse;
    } else {
      // 에러 처리
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
}
