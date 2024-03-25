// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:http/http.dart' as http;

class RoadMapApi {
  static Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiaWF0IjoxNzA4Nzg5MjE5LCJleHAiOjIwNjg3ODkyMTl9.QfNiocS_CBaiDrKqK93hfl03MAMJ_Pm9Fy-IibpT37CVlz2RN-SdaUQk9VkGMJcsVNsTIyBrROlQA4eXLk02Pg'
  };

  static String baseUrl = 'https://api.startingblock.co.kr';
  static String getRDList = 'api/v1/roadmaps';
  static String addRDList = 'api/v1/roadmaps/add';

  //로드맵 리스트 불러오는 메소드
  static Future<List<RoadMapModel>> getRoadMapList() async {
    final url = Uri.parse('$baseUrl/$getRDList');
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

  // 로드맵 리스트 추가 메소드
  static Future<void> addRoadMap(Map<String, String> roadMapData) async {
    final url = Uri.parse('$baseUrl/$addRDList');
    final response =
        await http.post(url, headers: headers, body: jsonEncode(roadMapData));

    if (response.statusCode == 200) {
      print('로드맵이 성공적으로 추가되었습니다.');
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  // 로드맵 삭제 메소드
  static Future<void> deleteRoadMap(String roadmapId) async {
    final url = Uri.parse('$baseUrl/api/v1/roadmaps/$roadmapId');
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
      String roadmapId, int announcementId) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/roadmaps/$roadmapId/announcement?announcementId=$announcementId');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('공고가 로드맵에 성공적으로 추가되었습니다.');
    } else {
      throw Exception('공고를 로드맵에 추가하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 로드맵에서 공고 삭제 메소드
  static Future<void> deleteAnnouncementFromRoadMap(
      String roadmapId, int announcementId) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/roadmaps/$roadmapId/announcement?announcementId=$announcementId');
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('공고가 로드맵에서 성공적으로 삭제되었습니다.');
    } else {
      throw Exception('공고를 로드맵에서 삭제하는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }
}
