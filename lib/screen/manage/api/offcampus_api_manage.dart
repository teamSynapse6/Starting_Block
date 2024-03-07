// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/screen/manage/models/offcampus_detail_model.dart';
import 'package:starting_block/screen/manage/models/offcampus_model.dart';
import 'package:starting_block/screen/manage/models/offcampus_recommend_model.dart';

// OffCampusModel을 반환하는 새로운 메서드
class OffCampusApi {
  static String baseUrl = 'http://10.0.2.2:5000';
  static String apiBaseUrl = 'https://api.startingblock.co.kr';
  // static String baseUrl = 'https://leeyuchul.pythonanywhere.com';
  static String offCampus = 'offcampus';
  static String requestID = 'offcampus/ids';
  static String requestFilter = 'offcampus/filtered';
  static String popularKeyword = 'offcampus/popular';
  static String offcampusSearch = 'offcampus/search';
  static String roadMapRecommend = 'offcampus/roadmapRec';

  static Future<List<OffCampusModel>> getOffCampusData() async {
    final offCampusUrl = Uri.parse('$baseUrl/$offCampus');
    final response = await http.get(offCampusUrl);

    if (response.statusCode == 200) {
      final List<dynamic> offCampusJson = jsonDecode(response.body);
      List<OffCampusModel> offCampusList =
          offCampusJson.map((json) => OffCampusModel.fromJson(json)).toList();
      return offCampusList;
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // 인기 키워드를 반환하는 새로운 메서드
  static Future<List<String>> getOffCampusPopularKeyword() async {
    final offCampusUrl = Uri.parse('$baseUrl/$popularKeyword');
    final response = await http.get(offCampusUrl);

    if (response.statusCode == 200) {
      // 서버 응답에서 JSON 배열을 디코드하여 List<String>으로 변환
      final List<dynamic> keywordsJson = jsonDecode(response.body);
      // List<dynamic>을 List<String>으로 변환
      List<String> keywordsList =
          keywordsJson.map((keyword) => keyword.toString()).toList();
      return keywordsList;
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // OffCampusDetailModel을 반환하는 새로운 메서드
  static Future<List<OffCampusDetailModel>> getOffCampusDetailData() async {
    final offCampusUrl = Uri.parse('$baseUrl/$offCampus');
    final response = await http.get(offCampusUrl);

    if (response.statusCode == 200) {
      final List<dynamic> offCampusJson = jsonDecode(response.body);
      List<OffCampusDetailModel> offCampusDetailList = offCampusJson
          .map((json) => OffCampusDetailModel.fromJson(json))
          .toList();
      return offCampusDetailList;
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // OffCampusRecommednModel을 반환하는 새로운 메서드
  static Future<List<OffCampusRecommendModel>> getOffCampusRecData(
      String excludeId) async {
    final offCampusUrl = Uri.parse('$baseUrl/$offCampus');
    final response = await http.get(offCampusUrl);

    if (response.statusCode == 200) {
      final List<dynamic> offCampusJson = jsonDecode(response.body);
      List<OffCampusRecommendModel> offCampusList = offCampusJson
          .map((json) => OffCampusRecommendModel.fromJson(json))
          .where((item) => item.id != excludeId) // thisID를 제외
          .toList();

      offCampusList.shuffle(); // 리스트를 무작위로 섞기
      return offCampusList.take(3).toList(); // 상위 3개 항목 반환
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // ID 목록에 해당하는 OffCampusModel 데이터를 서버로부터 받아오는 메소드
  static Future<List<OffCampusModel>> getOffCampusDataByIds(
      List<int> ids) async {
    final url = Uri.parse('$baseUrl/$requestID'); // POST 요청을 보낼 URL
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // 요청 헤더에 Content-Type 지정
      body: jsonEncode({'ids': ids}), // ID 목록을 JSON 형식으로 인코딩하여 요청 본문에 포함
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<OffCampusModel> dataList =
          responseData.map((data) => OffCampusModel.fromJson(data)).toList();
      return dataList;
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // 필터링된 OffCampusModel 데이터를 서버로부터 받아오는 메소드
  static Future<List<OffCampusModel>> getOffCampusDataFiltered({
    String supporttype = '전체',
    String region = '전체',
    String posttarget = '전체',
    String sorting = 'latest',
  }) async {
    final url =
        Uri.parse('$baseUrl/$requestFilter'); // 필터링된 데이터를 받아오는 서버의 endpoint

    // POST 요청을 보내는 부분
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // 요청 헤더에 Content-Type 지정
      body: jsonEncode({
        'supporttype': supporttype,
        'region': region,
        'posttarget': posttarget, // 필터 조건을 JSON 형식으로 인코딩하여 요청 본문에 포함
        'sorting': sorting
      }),
    );

    // 서버 응답 처리 부분
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<OffCampusModel> dataList =
          responseData.map((data) => OffCampusModel.fromJson(data)).toList();
      return dataList; // 필터링된 데이터 리스트를 반환
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // 검색 조건에 맞는 OffCampusModel 데이터를 서버로부터 받아오는 메소드
  static Future<List<OffCampusModel>> getOffCampusSearch({
    String supporttype = '전체',
    String region = '전체',
    String posttarget = '전체',
    String sorting = 'latest',
    String keyword = '',
  }) async {
    final url = Uri.parse('$baseUrl/$offcampusSearch'); // 검색 요청을 보낼 URL

    // POST 요청을 보내는 부분
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // 요청 헤더에 Content-Type 지정
      body: jsonEncode({
        'supporttype': supporttype,
        'region': region,
        'posttarget': posttarget,
        'sorting': sorting,
        'keyword': keyword, // 검색 키워드 추가
      }),
    );

    // 서버 응답 처리 부분
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<OffCampusModel> dataList =
          responseData.map((data) => OffCampusModel.fromJson(data)).toList();
      return dataList; // 필터링 및 검색된 데이터 리스트를 반환
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  static Future<List<OffCampusModel>> getOffCampusRoadmapRec({
    bool? posttarget,
    String? region,
    int? age,
    List<String>? supporttypes,
  }) async {
    final url = Uri.parse('$baseUrl/$roadMapRecommend');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'posttarget': posttarget,
        'region': region,
        'age': age,
        'supporttype': supporttypes,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<OffCampusModel> roadmapRecList =
          responseData.map((data) => OffCampusModel.fromJson(data)).toList();
      return roadmapRecList;
    } else {
      throw Exception(
          'Failed to load roadmap recommendations. 서버 오류: ${response.statusCode}');
    }
  }
}
