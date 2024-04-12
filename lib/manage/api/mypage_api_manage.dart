import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/model_manage.dart';

class MyPageApi {
  static Map<String, String> headers = {
    'accept': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiaWF0IjoxNzA4Nzg5MjE5LCJleHAiOjIwNjg3ODkyMTl9.QfNiocS_CBaiDrKqK93hfl03MAMJ_Pm9Fy-IibpT37CVlz2RN-SdaUQk9VkGMJcsVNsTIyBrROlQA4eXLk02Pg'
  };

  static String baseUrl = 'https://api.startingblock.co.kr';

  // 내 궁금해요 불러오기
  static Future<List<MyProfileHearModel>> getMyHeart() async {
    final url = Uri.parse('$baseUrl/api/v1/heart/my');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      // 여러 개의 하트 데이터를 리스트로 반환합니다.
      List<MyProfileHearModel> hearts = jsonResponse
          .map((json) =>
              MyProfileHearModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return hearts;
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }
}
