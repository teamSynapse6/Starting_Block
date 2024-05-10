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
  static Future<List<RoadMapModel>> getRoadMapList({int retryCount = 1}) async {
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
      {int retryCount = 1}) async {
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
      {int retryCount = 1}) async {
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
      {int retryCount = 1}) async {
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
      {int retryCount = 1}) async {
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
      {int retryCount = 1}) async {
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
  static Future<bool> roadMapLeap({int retryCount = 1}) async {
    final url = Uri.parse('$baseUrl/api/v1/roadmaps/leap');
    Map<String, String> headers = await getHeaders();
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      return true; // 성공적으로 처리됨
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return roadMapLeap(retryCount: retryCount - 1); // 재귀 호출
    } else {
      throw Exception('로드맵 도약에 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵 순서 변경 메소드
  static Future<void> roadMapReorder(List<int> roadmapIds,
      {int retryCount = 1}) async {
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

  // 로드맵에 저장된 교외/교내 공고 리스트를 불러오는 메소드
  static Future<List<RoadMapSavedOffcampus>> getSavedListOffcampus(
      {required int roadmapId,
      required String type,
      int retryCount = 1}) async {
    // roadmapId와 쿼리 파라미터 'type'을 포함한 URL 생성
    final url = Uri.parse(
        '$baseUrl/api/v1/roadmaps/$roadmapId/list?type=${Uri.encodeComponent(type)}');

    // 인증 토큰이 포함된 헤더 가져오기
    Map<String, String> headers = await getHeaders();

    // 새로운 URL로 GET 요청 보내기
    final response = await http.get(url, headers: headers);

    // 성공적인 응답인지 확인
    if (response.statusCode == 200) {
      // 응답 본문을 UTF-8로 디코딩
      String utf8Body = utf8.decode(response.bodyBytes);
      // JSON을 동적 객체 목록으로 파싱
      List<dynamic> body = jsonDecode(utf8Body);
      // 동적 객체를 RoadMapSavedOffcampus 객체 목록으로 변환
      List<RoadMapSavedOffcampus> savedOffcampusList = body
          .map((dynamic item) => RoadMapSavedOffcampus.fromJson(item))
          .toList();
      // 파싱된 목록 반환
      return savedOffcampusList;
    } else if (response.statusCode == 401 && retryCount > 0) {
      // 권한이 없는 경우(401 코드), 액세스 토큰을 갱신하고 재시도
      await UserInfoManageApi.updateAccessToken();
      return getSavedListOffcampus(
        retryCount: retryCount - 1,
        roadmapId: roadmapId,
        type: type,
      ); // 재귀 호출
    } else {
      // 요청이 실패하면 예외를 발생시킴
      throw Exception('교외 공고 목록을 불러오는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 초기 로드맵 설정을 서버에 보내는 메소드
  static Future<void> postInitialRoadMap(List<Map<String, dynamic>> roadMaps,
      {int retryCount = 1}) async {
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
