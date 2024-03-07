import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/screen/manage/model_manage.dart';

class OffCampusApi {
  static Map<String, String> headers = {
    'accept': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiaWF0IjoxNzA5Nzk3Njc5LCJleHAiOjIwNjk3OTc2Nzl9.jA8iQGPWxvK5VZnu4hQk_bJ02htop4Vvf4pbYNHBMsglHTlvENCA9hKA_Fi9aVH8GoOcnBOW-mdWWxxkSQgt6g'
  };

  static String baseUrl = 'https://api.startingblock.co.kr';
  static String offCampusListEndpoint = 'api/v1/announcements/list';

  // 공고리스트 불러오기, 페이지 번호를 인자로 받습니다.
  static Future<List<OffCampusListModel>> getOffCampusHomeList(
      {int page = 0, String sorting = '최신순'}) async {
    // 페이지 번호를 사용하여 요청 URL을 구성합니다.
    final offCampusUrl = Uri.parse(
      '$baseUrl/$offCampusListEndpoint?page=$page&sorting=$sorting',
    );
    final response = await http.get(offCampusUrl, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      final List<dynamic> content = jsonResponse['content'];
      List<OffCampusListModel> offCampusList =
          content.map((json) => OffCampusListModel.fromJson(json)).toList();
      return offCampusList;
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // ID를 이용해 공고정보 상세조회
  static Future<OffCampusDetailModel> getOffcampusDetailInfo(int id) async {
    final offCampusDetailUrl = Uri.parse('$baseUrl/api/v1/announcements/$id');
    final response = await http.get(offCampusDetailUrl, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      // 상세 정보는 단일 객체로 반환됩니다.
      OffCampusDetailModel offCampusDetail =
          OffCampusDetailModel.fromJson(jsonResponse);
      return offCampusDetail;
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }
}
