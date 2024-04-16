// ignore_for_file: avoid_print

import 'dart:convert';
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
  static Future<List<RoadMapModel>> getRoadMapList() async {
    final url = Uri.parse('$baseUrl/$getRDList');
    Map<String, String> headers = await getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // UTF-8로 명시적으로 디코딩
      String utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> body = jsonDecode(utf8Body);
      List<RoadMapModel> roadmaps =
          body.map((dynamic item) => RoadMapModel.fromJson(item)).toList();
      return roadmaps;
    } else {
      throw Exception('로드맵을 불러오는 데 실패했습니다.');
    }
  }

  // 로드맵 단계 추가 메소드
  static Future<void> addRoadMap(String roadmapTitle) async {
    // roadmapTitle을 URL 인코딩합니다.
    String encodedTitle = Uri.encodeComponent(roadmapTitle);
    Map<String, String> headers = await getHeaders();
    // 인코딩된 roadmapTitle을 URL 쿼리 파라미터로 추가합니다.
    final url = Uri.parse('$baseUrl/$addRDList?roadmapTitle=$encodedTitle');

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('로드맵이 성공적으로 추가되었습니다.');
    } else {
      throw Exception('로드맵 추가에 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵 단계 삭제 메소드
  static Future<void> deleteRoadMap(String roadmapId) async {
    final url = Uri.parse('$baseUrl/api/v1/roadmaps/$roadmapId');
    Map<String, String> headers = await getHeaders();
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      print('로드맵이 성공적으로 삭제되었습니다.');
    } else {
      // 오류 처리: 상태 코드에 따른 적절한 예외 처리를 여기에 추가할 수 있습니다.
      throw Exception('로드맵을 삭제하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

// 로드맵에 공고 저장 메소드
  static Future<void> addAnnouncementToRoadMap(
      int roadmapId, String announcementId) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/roadmaps/$roadmapId/announcement?announcementId=$announcementId');
    Map<String, String> headers = await getHeaders();
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('공고가 로드맵에 성공적으로 추가되었습니다.');
    } else {
      throw Exception('공고를 로드맵에 추가하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵에서 공고 삭제 메소드
  static Future<void> deleteAnnouncementFromRoadMap(
      int roadmapId, String announcementId) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/roadmaps/$roadmapId/announcement?announcementId=$announcementId');
    Map<String, String> headers = await getHeaders();
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('공고가 로드맵에서 성공적으로 삭제되었습니다.');
    } else {
      throw Exception('공고를 로드맵에서 삭제하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  //로드맵의 해당 ID가 저장되어 있는지 확인하는 메소드
  static Future<List<RoadMapAnnounceModel>> getRoadMapAnnounceList(
      String announcementId) async {
    final url =
        Uri.parse('$baseUrl/api/v1/roadmaps/announcement/$announcementId');
    Map<String, String> headers = await getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // UTF-8로 명시적으로 디코딩
      String utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> body = jsonDecode(utf8Body);
      List<RoadMapAnnounceModel> announces = body
          .map((dynamic item) => RoadMapAnnounceModel.fromJson(item))
          .toList();
      return announces;
    } else {
      throw Exception('로드맵 공고를 불러오는 데 실패했습니다.');
    }
  }

  // 로드맵 도약하기 메소드
  static Future<void> roadMapLeap() async {
    final url = Uri.parse('$baseUrl/api/v1/roadmaps/leap');
    Map<String, String> headers = await getHeaders();
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      print('로드맵 도약이 성공적으로 수행되었습니다.');
    } else {
      throw Exception('로드맵 도약에 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵 순서 변경 메소드
  static Future<void> roadMapReorder(List<int> roadmapIds) async {
    final url = Uri.parse('$baseUrl/api/v1/roadmaps/swap');
    Map<String, String> headers = await getHeaders();
    final String requestBody = jsonEncode({
      "roadmapIds": roadmapIds,
    });
    final response = await http.post(url, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      print('로드맵의 순서가 성공적으로 변경되었습니다.');
    } else {
      throw Exception('로드맵 순서 변경에 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵에 저장된 교외 공고 리스트를 불러오는 메소드
  static Future<List<RoadMapSavedOffcampus>> getSavedListOffcampus(
      int roadmapId) async {
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
    } else {
      throw Exception('교외 공고 목록을 불러오는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 초기 로드맵 설정을 서버에 보내는 메소드
  static Future<void> postInitialRoadMap(List<RoadMapModel> roadMaps) async {
    final url =
        Uri.parse('$baseUrl/$getRDList'); // getRDList 끝에 해당 엔드포인트를 사용합니다.
    Map<String, String> headers = await getHeaders(); // 헤더 가져오기

    // RoadMapModel 리스트를 JSON 객체로 변환
    List<Map<String, dynamic>> roadMapsJson = roadMaps
        .map(
            (roadMap) => {"title": roadMap.title, "sequence": roadMap.sequence})
        .toList();

    // JSON 바디 생성
    String requestBody = jsonEncode({"roadmaps": roadMapsJson});

    final response = await http.post(url, headers: headers, body: requestBody);

    // 응답 코드가 200번대인지 확인
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('초기 로드맵 설정이 성공적으로 서버에 등록되었습니다.');
    } else {
      // 실패 시 예외 처리
      throw Exception(
          '초기 로드맵 설정을 서버에 등록하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }
}
