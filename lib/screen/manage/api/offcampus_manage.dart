import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/screen/manage/models/offcampus_detail_model.dart';
import 'package:starting_block/screen/manage/models/offcampus_model.dart';
import 'package:starting_block/screen/manage/models/offcampus_recommend_model.dart';

// OffCampusModel을 반환하는 새로운 메서드
class OffCampusApiService {
  static String baseUrl = 'http://10.0.2.2:5000';
  static String offCampus = 'offcampus';

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
}
