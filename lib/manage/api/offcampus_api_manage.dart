import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/model_manage.dart';

class OffCampusApi {
  static Map<String, String> headers = {
    'accept': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiaWF0IjoxNzA4Nzg5MjE5LCJleHAiOjIwNjg3ODkyMTl9.QfNiocS_CBaiDrKqK93hfl03MAMJ_Pm9Fy-IibpT37CVlz2RN-SdaUQk9VkGMJcsVNsTIyBrROlQA4eXLk02Pg'
  };

  static String baseUrl = 'https://api.startingblock.co.kr';
  static String offCampusListEndpoint = 'api/v1/announcements/list';
  static String offCampusRecEndpoint = 'api/v1/announcements/random';

  // 공고리스트 불러오기, 페이지 번호를 인자로 받습니다.
  static Future<Map<String, dynamic>> getOffCampusHomeList({
    int page = 0,
    String sorting = '최신순',
    String postTarget = '',
    String region = '',
    String supportType = '',
    String search = '',
    int size = 0,
  }) async {
    // 쿼리 파라미터 문자열 직접 생성
    String queryParams = 'page=$page&sorting=$sorting';
    if (postTarget != '') queryParams += '&postTarget=$postTarget';
    if (region != '') queryParams += '&region=$region';
    if (supportType != '') queryParams += '&supportType=$supportType';
    if (search != '') queryParams += '&search=$search';
    if (size != 0) queryParams += '&size=$size';

    // URL에 쿼리 파라미터 문자열 추가
    final offCampusUrl =
        Uri.parse('$baseUrl/$offCampusListEndpoint?$queryParams');
    final response = await http.get(offCampusUrl, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      final List<dynamic> content = jsonResponse['content'];
      List<OffCampusListModel> offCampusList =
          content.map((json) => OffCampusListModel.fromJson(json)).toList();
      final bool last = jsonResponse['last'];
      return {
        'offCampusList': offCampusList,
        'last': last,
      };
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

// 공고 3개 랜덤 리턴 메서드
  static Future<List<OffCampusListModel>> getOffcampusRecommend() async {
    final offCampusDetailUrl = Uri.parse('$baseUrl/$offCampusRecEndpoint');
    final response = await http.get(offCampusDetailUrl, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      // 여러 개의 공고 데이터를 리스트로 반환합니다.
      List<OffCampusListModel> recommendations = jsonResponse
          .map((json) => OffCampusListModel.fromJson(json))
          .toList();
      return recommendations;
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }
}
