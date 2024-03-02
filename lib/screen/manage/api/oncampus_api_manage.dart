// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/screen/manage/model_manage.dart';

Map<String, int> schoolNameToNumber = {
  '가톨릭대학교': 01,
  '강서대학교': 02,
  '건국대학교': 03,
  '경기대학교': 04,
  '경희대학교': 05,
  '고려대학교': 06,
  '광운대학교': 07,
  '국민대학교': 08,
  '덕성여자대학교': 09,
  '동국대학교': 10,
  '동덕여자대학교': 11,
  '명지대학교': 12,
  '삼육대학교': 13,
  '상명대학교': 14,
  '서강대학교': 15,
  '서경대학교': 16,
  '서울과학기술대학교': 17,
  '서울교육대학교': 18,
  '서울대학교': 19,
  '서울시립대학교': 20,
  '서울여자대학교': 21,
  '서울한영대학교': 22,
  '성공회대학교': 23,
  '성균관대학교': 24,
  '성신여자대학교': 25,
  '세종대학교': 26,
  '숙명여자대학교': 27,
  '숭실대학교': 28,
  '연세대학교': 29,
  '이화여자대학교': 30,
  '중앙대학교': 31,
  '총신대학교': 32,
  '추계예술대학교': 33,
  '한국외국어대학교': 34,
  '한국체육대학교': 35,
  '한성대학교': 36,
  '한양대학교': 37,
  '홍익대학교': 38
};

String getSchoolNumber(String schoolName) {
  // 학교명에 해당하는 번호를 찾습니다.
  int? number = schoolNameToNumber[schoolName];
  // 번호가 있으면 2자리 문자열로 변환하고, 없으면 "00"을 반환합니다.
  return number != null ? number.toString().padLeft(2, '0') : "00";
}

class OnCampusAPI {
  static String baseUrl = 'http://10.0.2.2:5000';
  // static String baseUrl = 'https://leeyuchul.pythonanywhere.com';
  static String schoolUrl = 'url';
  static String schoolLogo = 'logo';
  static String schoolSystem = 'system';
  static String schoolSystemByID = 'system/ids';
  static String schoolSystemRoadmapRec = 'system/roadmapRec';
  static String schoolClass = 'class';
  static String schoolClassByID = 'class/ids';
  static String schoolClassRoadmapRec = 'class/roadmapRec';
  static String schoolNotify = 'notify';
  static String schoolNotifyByID = 'notify/ids';
  static String schoolNotifyRoadmapRec = 'notify/roadmapRec';
  static String schoolNotifyFiltered = 'supportgroup/notify/filtered';
  static String schoolTabList = 'supportgroup/tablist';

  static Future<String> onCampusLogo() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolLogo');
    print('로고: $url');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      // SVG 이미지 데이터를 문자열로 반환
      String svgData = response.body;
      return svgData;
    } else {
      print('에러: ${response.statusCode}.');
      throw Error();
    }
  }

  static Future<List<OnCampusSystemModel>> getOnCampusSystem() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolSystem');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCampusSystemModel> systemList =
          jsonData.map((item) => OnCampusSystemModel.fromJson(item)).toList();
      return systemList;
    } else {
      print('에러: ${response.statusCode}.');
      throw Error();
    }
  }

  // ID를 반환해서 데이터를 받아오는 메소드
  static Future<List<OnCampusSystemModel>> getOnCampusSystemByIds(
      List<int> ids) async {
    String schoolName = await UserInfo.getSchoolName();
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolSystemByID');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ids': ids}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCampusSystemModel> systemList =
          jsonData.map((item) => OnCampusSystemModel.fromJson(item)).toList();
      return systemList;
    } else {
      print('에러: ${response.statusCode}.');
      throw Error();
    }
  }

  // 시스템 로드맵 추천 데이터를 서버로부터 받아오는 메소드
  static Future<OnCampusSystemModel> getOnCampusSystemRec(
      List<String> types) async {
    String schoolName = await UserInfo.getSchoolName();
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolSystemRoadmapRec');

    // POST 요청을 보냅니다.
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'type': types}),
    );

    // 서버 응답 처리
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 객체로 디코딩
      final Map<String, dynamic> data = jsonDecode(response.body);
      // JSON 객체를 OnCampusSystemModel로 변환
      return OnCampusSystemModel.fromJson(data);
    } else {
      // 서버가 에러로 응답하면, 에러 상태 코드를 출력하고 예외 발생
      print('서버 에러: ${response.statusCode}');
      throw Exception('Failed to load system roadmap recommendation data');
    }
  }

  static Future<List<OnCampusClassModel>> getOnCampusClass() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolClass');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCampusClassModel> classList =
          jsonData.map((item) => OnCampusClassModel.fromJson(item)).toList();
      return classList;
    } else {
      print('에러: ${response.statusCode}.');
      throw Error();
    }
  }

  //ID를 반환해서 데이터를 받아오는 메소드
  static Future<List<OnCampusClassModel>> getOnCampusClassByIds(
      List<int> ids) async {
    String schoolName = await UserInfo.getSchoolName();
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolClassByID');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ids': ids}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCampusClassModel> classList =
          jsonData.map((item) => OnCampusClassModel.fromJson(item)).toList();
      return classList;
    } else {
      print('에러: ${response.statusCode}.');
      throw Error();
    }
  }

  //로드맵_추천메소드
  static Future<OnCampusClassModel> getOnCampusClassRec() async {
    String schoolName = await UserInfo.getSchoolName();
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolClassRoadmapRec');
    final response = await http.get(url);

    // 응답 상태 코드 확인
    if (response.statusCode == 200) {
      // 서버가 200 OK로 응답하면, JSON 응답을 디코드
      final Map<String, dynamic> data = jsonDecode(response.body);
      return OnCampusClassModel.fromJson(data);
    } else {
      // 서버가 에러로 응답하면, 에러 상태 코드를 출력하고 예외 발생
      print('서버 에러: ${response.statusCode}');
      throw Exception('클래스별 추천 데이터 로드 실패');
    }
  }

  static Future<List<OnCampusNotifyModel>> getOnCampusNotify() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolNotify');
    print('교내지원사업: $url');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCampusNotifyModel> notifyList =
          jsonData.map((item) => OnCampusNotifyModel.fromJson(item)).toList();
      return notifyList;
    } else {
      print('에러: ${response.statusCode}.');
      throw Error();
    }
  }

  static Future<List<OnCampusNotifyModel>> getOnCampusHomeNotify() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolNotify');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCampusNotifyModel> notifyList =
          jsonData.map((item) => OnCampusNotifyModel.fromJson(item)).toList();

      // 결과 리스트에서 처음 10개의 항목만 반환
      return notifyList.take(5).toList();
    } else {
      print('에러: ${response.statusCode}.');
      throw Error();
    }
  }

  //ID를 반환해서 데이터를 받아오는 메소드
  static Future<List<OnCampusNotifyModel>> getOnCampusNotifyByIds(
      List<int> ids) async {
    String schoolName = await UserInfo.getSchoolName();
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolNotifyByID');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ids': ids}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCampusNotifyModel> notifyList =
          jsonData.map((item) => OnCampusNotifyModel.fromJson(item)).toList();
      return notifyList;
    } else {
      print('에러: ${response.statusCode}.');
      throw Error();
    }
  }

  // 필터링된 공지사항 데이터를 서버로부터 받아오는 메소드
  static Future<List<OnCampusNotifyModel>> getOnCampusNotifyFiltered({
    required String program, // 필터링할 프로그램
    required String sorting, // 정렬 조건
  }) async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    String schoolNumber = getSchoolNumber(schoolName); // 학교 번호를 가져옵니다.
    final url =
        Uri.parse('$baseUrl/$schoolNumber/notify/filtered'); // URL 구성 수정

    // POST 요청을 보냅니다.
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': program, // 요청 본문에 'type' 필드를 포함
        'sorting': sorting, // 'sorting' 필드도 포함
      }),
    );

    // 서버 응답 처리
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 배열로 디코딩
      final List<dynamic> jsonData = jsonDecode(response.body);
      // JSON 배열을 OnCampusNotifyModel 리스트로 변환
      List<OnCampusNotifyModel> notifyList =
          jsonData.map((item) => OnCampusNotifyModel.fromJson(item)).toList();
      return notifyList;
    } else {
      print('서버 에러: ${response.statusCode}');
      throw Exception('Failed to load filtered notify data');
    }
  }

  // 필터링 및 검색된 공지사항 데이터를 서버로부터 받아오는 메소드
  static Future<List<OnCampusNotifyModel>> getOnCampusNotifySearch({
    required String program, // 필터링할 프로그램
    required String sorting, // 정렬 조건
    required String keyword, // 검색 키워드
  }) async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    String schoolNumber = getSchoolNumber(schoolName); // 학교 번호를 가져옵니다.
    final url = Uri.parse('$baseUrl/$schoolNumber/notify/search'); // URL 구성

    // POST 요청을 보냅니다.
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': program, // 요청 본문에 'type' 필드를 포함
        'sorting': sorting, // 'sorting' 필드도 포함
        'keyword': keyword, // 'keyword' 필드도 포함
      }),
    );

    // 서버 응답 처리
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 배열로 디코딩
      final List<dynamic> jsonData = jsonDecode(response.body);
      // JSON 배열을 OnCampusNotifyModel 리스트로 변환
      List<OnCampusNotifyModel> notifyList =
          jsonData.map((item) => OnCampusNotifyModel.fromJson(item)).toList();
      return notifyList;
    } else {
      print('서버 에러: ${response.statusCode}');
      throw Exception('Failed to load search notify data');
    }
  }

  static Future<List<String>> getSupportTabList() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolTabList');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      // 서버 응답의 body 내용을 바로 List<String>으로 파싱하여 반환
      return List<String>.from(jsonDecode(response.body));
    } else {
      print('에러: ${response.statusCode}.');
      throw Exception('Failed to load tab list');
    }
  }

  // //교내지원사업(notify)_추천 메소드
  // static Future<List<OnCampusNotifyModel>> getOnCampusRoadmapRec({
  //   required List<String> types, // 필터링할 타입 목록
  // }) async {
  //   String schoolName =
  //       await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
  //   String schoolNumber = getSchoolNumber(schoolName);
  //   final url = Uri.parse('$baseUrl/$schoolNumber/$schoolNotifyRoadmapRec');

  //   // POST 요청을 보냅니다.
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'types': types}),
  //   );

  //   // 서버 응답 처리
  //   if (response.statusCode == 200) {
  //     // 응답 데이터를 JSON 배열로 디코딩
  //     final List<dynamic> jsonData = jsonDecode(response.body);
  //     // JSON 배열을 OnCampusNotifyModel 리스트로 변환
  //     List<OnCampusNotifyModel> notifyList =
  //         jsonData.map((item) => OnCampusNotifyModel.fromJson(item)).toList();
  //     return notifyList;
  //   } else {
  //     print('서버 에러: ${response.statusCode}');
  //     throw Exception('Failed to load roadmap recommendation data');
  //   }
  // }
//교내지원사업(notify)_추천 메소드
  static Future<List<OnCampusNotifyModel>> getOnCampusRoadmapRec({
    required List<String> types, // 필터링할 타입 목록
  }) async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    String schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$schoolNotifyRoadmapRec');

    // 요청 본문
    String requestBody = jsonEncode({'types': types});

    // 요청 정보 출력
    print('POST 요청을 보냅니다. URL: $url');
    print('요청 본문: $requestBody');

    // POST 요청을 보냅니다.
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    // 서버 응답 처리
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 배열로 디코딩
      final List<dynamic> jsonData = jsonDecode(response.body);
      // JSON 배열을 OnCampusNotifyModel 리스트로 변환
      List<OnCampusNotifyModel> notifyList =
          jsonData.map((item) => OnCampusNotifyModel.fromJson(item)).toList();
      return notifyList;
    } else {
      print('서버 에러: ${response.statusCode}');
      throw Exception('Failed to load roadmap recommendation data');
    }
  }
}
