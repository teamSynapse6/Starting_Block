import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class OffCampusApi {
  static Future<Map<String, String>> getHeaders() async {
    String? accessToken = await UserTokenManage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

  static String baseUrl = 'https://api.startingblock.co.kr';
  static String offCampusListEndpoint = 'api/v1/announcements/list';
  static String offCampusRecEndpoint = 'api/v1/announcements/random';

  // 공고리스트 불러오기, 페이지 번호를 인자로 받습니다.
  static Future<Map<String, dynamic>> getOffCampusHomeList(
      {int page = 0,
      String sorting = '최신순',
      String postTarget = '',
      String region = '',
      String supportType = '',
      String search = '',
      int size = 0,
      int retryCount = 3}) async {
    String queryParams = 'page=$page&sorting=$sorting';
    if (postTarget != '') queryParams += '&postTarget=$postTarget';
    if (region != '') queryParams += '&region=$region';
    if (supportType != '') queryParams += '&supportType=$supportType';
    if (search != '') queryParams += '&search=$search';
    if (size != 0) queryParams += '&size=$size';

    Map<String, String> headers = await getHeaders();
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
      return {'offCampusList': offCampusList, 'last': last};
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getOffCampusHomeList(
          page: page,
          sorting: sorting,
          postTarget: postTarget,
          region: region,
          supportType: supportType,
          search: search,
          size: size,
          retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // ID를 이용해 공고정보 상세조회
  static Future<OffCampusDetailModel> getOffcampusDetailInfo(int id,
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final offCampusDetailUrl = Uri.parse('$baseUrl/api/v1/announcements/$id');
    final response = await http.get(offCampusDetailUrl, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      OffCampusDetailModel offCampusDetail =
          OffCampusDetailModel.fromJson(jsonResponse);
      return offCampusDetail;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getOffcampusDetailInfo(id, retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // 공고 3개 랜덤 리턴 메서드
  static Future<List<OffCampusListModel>> getOffcampusRecommend(
      {int retryCount = 3}) async {
    Map<String, String> headers = await getHeaders();
    final offCampusDetailUrl = Uri.parse('$baseUrl/$offCampusRecEndpoint');
    final response = await http.get(offCampusDetailUrl, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<OffCampusListModel> recommendations = jsonResponse
          .map((json) => OffCampusListModel.fromJson(json))
          .toList();
      return recommendations;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getOffcampusRecommend(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }
}
