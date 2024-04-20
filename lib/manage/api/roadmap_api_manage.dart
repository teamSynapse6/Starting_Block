// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:http/http.dart' as http;

class RoadMapApi {
  static Future<Map<String, String>> getHeaders() async {
    String? accessToken = await UserTokenManage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

  static String baseUrl = 'https://api.startingblock.co.kr';
  static String getRDList = 'api/v1/roadmaps';
  static String addRDList = 'api/v1/roadmaps/add';

  //로드맵 리스트 불러오는 메소드
  static Future<List<RoadMapModel>> getRoadMapList({int retryCount = 3}) async {
    final url = Uri.parse('$baseUrl/$getRDList');
    Map<String, String> headers = await getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      String utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> body = jsonDecode(utf8Body);
      List<RoadMapModel> roadmaps =
          body.map((dynamic item) => RoadMapModel.fromJson(item)).toList();
      return roadmaps;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getRoadMapList(retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('로드맵을 불러오는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵 단계 추가 메소드
  static Future<void> addRoadMap(String roadmapTitle,
      {int retryCount = 3}) async {
    String encodedTitle = Uri.encodeComponent(roadmapTitle);
    Map<String, String> headers = await getHeaders();
    final url = Uri.parse('$baseUrl/$addRDList?roadmapTitle=$encodedTitle');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      // 성공적으로 처리됨
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return addRoadMap(roadmapTitle, retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('로드맵 추가에 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵 단계 삭제 메소드
  static Future<void> deleteRoadMap(String roadmapId,
      {int retryCount = 3}) async {
    final url = Uri.parse('$baseUrl/api/v1/roadmaps/$roadmapId');
    Map<String, String> headers = await getHeaders();
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      // 성공적으로 처리됨
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return deleteRoadMap(roadmapId, retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('로드맵을 삭제하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵에 공고 저장 메소드
  static Future<void> addAnnouncementToRoadMap(
      int roadmapId, String announcementId,
      {int retryCount = 3}) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/roadmaps/$roadmapId/announcement?announcementId=$announcementId');
    Map<String, String> headers = await getHeaders();
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 204) {
      // 성공적으로 처리됨
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return addAnnouncementToRoadMap(roadmapId, announcementId,
          retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('공고를 로드맵에 추가하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵에서 공고 삭제 메소드
  static Future<void> deleteAnnouncementFromRoadMap(
      int roadmapId, String announcementId,
      {int retryCount = 3}) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/roadmaps/$roadmapId/announcement?announcementId=$announcementId');
    Map<String, String> headers = await getHeaders();
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 204) {
      // 성공적으로 처리됨
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return deleteAnnouncementFromRoadMap(roadmapId, announcementId,
          retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('공고를 로드맵에서 삭제하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵의 해당 ID가 저장되어 있는지 확인하는 메소드
  static Future<List<RoadMapAnnounceModel>> getRoadMapAnnounceList(
      String announcementId,
      {int retryCount = 3}) async {
    final url =
        Uri.parse('$baseUrl/api/v1/roadmaps/announcement/$announcementId');
    Map<String, String> headers = await getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      String utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> body = jsonDecode(utf8Body);
      List<RoadMapAnnounceModel> announces = body
          .map((dynamic item) => RoadMapAnnounceModel.fromJson(item))
          .toList();
      return announces;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getRoadMapAnnounceList(announcementId,
          retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('로드맵 공고를 불러오는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵 도약하기 메소드
  static Future<void> roadMapLeap({int retryCount = 3}) async {
    final url = Uri.parse('$baseUrl/api/v1/roadmaps/leap');
    Map<String, String> headers = await getHeaders();
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      // 성공적으로 처리됨
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return roadMapLeap(retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('로드맵 도약에 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵 순서 변경 메소드
  static Future<void> roadMapReorder(List<int> roadmapIds,
      {int retryCount = 3}) async {
    final url = Uri.parse('$baseUrl/api/v1/roadmaps/swap');
    Map<String, String> headers = await getHeaders();
    final String requestBody = jsonEncode({"roadmapIds": roadmapIds});
    final response = await http.post(url, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      // 성공적으로 처리됨
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return roadMapReorder(roadmapIds, retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('로드맵 순서 변경에 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵에 저장된 교외 공고 리스트를 불러오는 메소드
  static Future<List<RoadMapSavedOffcampus>> getSavedListOffcampus(
      int roadmapId,
      {int retryCount = 3}) async {
    final url = Uri.parse('$baseUrl/api/v1/roadmaps/$roadmapId/off-campus');
    Map<String, String> headers = await getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      String utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> body = jsonDecode(utf8Body);
      List<RoadMapSavedOffcampus> savedOffcampusList = body
          .map((dynamic item) => RoadMapSavedOffcampus.fromJson(item))
          .toList();
      return savedOffcampusList;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getSavedListOffcampus(roadmapId,
          retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('교외 공고 목록을 불러오는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 초기 로드맵 설정을 서버에 보내는 메소드
  static Future<void> postInitialRoadMap(List<Map<String, dynamic>> roadMaps,
      {int retryCount = 3}) async {
    final url = Uri.parse('$baseUrl/$getRDList');
    Map<String, String> headers = await getHeaders(); // 헤더 가져오기
    String requestBody = jsonEncode({"roadmaps": roadMaps});
    final response = await http.post(url, headers: headers, body: requestBody);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // 성공적으로 처리됨
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return postInitialRoadMap(roadMaps, retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception(
          '초기 로드맵 설정을 서버에 등록하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }
}
