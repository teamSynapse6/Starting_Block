import 'dart:convert';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:http/http.dart' as http;

class OnCampusApi {
  static Future<Map<String, String>> getHeaders() async {
    String? accessToken = await UserTokenManage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

  static String baseUrl = 'https://api.startingblock.co.kr';

  //창업지원단 페이지 탭 항목 데이터를 가져오는 메소드
  static Future<List<String>> getSupportGroupTab({int retryCount = 1}) async {
    Map<String, String> headers = await getHeaders();
    final url =
        Uri.parse('$baseUrl/api/v1/announcements/list/support-group/keyword');

    final response = await http.get(url, headers: headers);

    if (response.statusCode > 200 || response.statusCode < 300) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<String> supportGroupTabs = jsonResponse.cast<String>();
      List<String> translatedTabs =
          supportGroupTabs.map(SupportGroupTabModel.translate).toList();

      // 지정된 순서대로 정렬
      final sortOrder = ['멘토링', '동아리', '특강', '경진대회', '캠프', '공간', '기타'];
      translatedTabs
          .sort((a, b) => sortOrder.indexOf(a) - sortOrder.indexOf(b));

      return translatedTabs;
    } else if (response.statusCode == 401 && retryCount > 0) {
      // 토큰 갱신 후 다시 시도
      await UserInfoManageApi.updateAccessToken();
      return getSupportGroupTab(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // 창업지원단 데이터를 가져오는 메소드
  static Future<List<OncaSupportGroupModel>> getOncaSupportGroup(
      {String? keyword, int retryCount = 1}) async {
    Map<String, String> headers = await getHeaders();

    // URL 생성 - keyword 파라미터가 존재하는지 확인
    String queryString = keyword != null ? '?keyword=$keyword' : '';
    final url = Uri.parse(
        '$baseUrl/api/v1/announcements/list/support-group$queryString');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<OncaSupportGroupModel> supportGroupList = jsonResponse
          .map((json) => OncaSupportGroupModel.fromJson(json))
          .toList();
      return supportGroupList;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getOncaSupportGroup(keyword: keyword, retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // 교내 제도 메소드
  static Future<List<OncaSystemModel>> getOncaSystem(
      {int retryCount = 1}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/announcements/list/system');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<OncaSystemModel> classList =
          jsonResponse.map((json) => OncaSystemModel.fromJson(json)).toList();
      return classList;
    } else if (response.statusCode == 401 && retryCount > 0) {
      // 토큰 재갱신 후 다시 시도
      await UserInfoManageApi.updateAccessToken();
      return getOncaSystem(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  // 교내 강의 메소드 추가
  static Future<List<OncaClassModel>> getOncaClass({int retryCount = 1}) async {
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/api/v1/announcements/list/lecture');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<OncaClassModel> classList =
          jsonResponse.map((json) => OncaClassModel.fromJson(json)).toList();
      return classList;
    } else if (response.statusCode == 401 && retryCount > 0) {
      // 토큰 재갱신 후 다시 시도
      await UserInfoManageApi.updateAccessToken();
      return getOncaClass(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  //교내 지원공고 메소드
  static Future<List<OncaAnnouncementModel>> getOncaAnnouncement(
      {String? keyword, int retryCount = 1}) async {
    Map<String, String> headers = await getHeaders();

    // URL에 keyword 파라미터를 추가할지 결정
    String queryString = keyword != 'null' ? '?keyword=$keyword' : '';
    final url =
        Uri.parse('$baseUrl/api/v1/announcements/list/on-campus$queryString');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      List<OncaAnnouncementModel> announcementList = jsonResponse
          .map((json) => OncaAnnouncementModel.fromJson(json))
          .toList();
      return announcementList;
    } else if (response.statusCode == 401 && retryCount > 0) {
      // 토큰 갱신 후 다시 시도
      await UserInfoManageApi.updateAccessToken();
      return getOncaAnnouncement(keyword: keyword, retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}, 본문: ${response.body}');
    }
  }
}
