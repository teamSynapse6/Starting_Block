// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/model_manage.dart';

Map<String, int> schoolNameToNumber = {
  '가톨릭대학교': 1,
  '강서대학교': 2,
  '건국대학교': 3,
  '경기대학교': 4,
  '경희대학교': 5,
  '고려대학교': 6,
  '광운대학교': 7,
  '국민대학교': 8,
  '덕성여자대학교': 9,
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

int getSchoolNumber(String schoolName) {
  return schoolNameToNumber[schoolName] ?? -1; // 학교명이 없을 경우 -1을 반환
}

class OnCampusGroupApi {
  static String baseUrl = 'https://simpleapi.startingblock.co.kr';
  static String groupMentoring = 'supportgroup/mentoring';
  static String groupClub = 'supportgroup/club';
  static String groupLecture = 'supportgroup/lecture';
  static String groupCompetition = 'supportgroup/competition';
  static String groupSpace = 'supportgroup/space';
  static String groupEtc = 'supportgroup/etc';

  static Future<List<OnCaMentoringModel>> getOnCaMentoring() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    int schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$groupMentoring');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCaMentoringModel> mentoringList =
          jsonData.map((item) => OnCaMentoringModel.fromJson(item)).toList();
      return mentoringList; // 모든 항목을 반환합니다.
    } else {
      print('멘토링 데이터 에러: ${response.statusCode}.');
      throw Exception('Failed to load mentoring list');
    }
  }

  static Future<List<OnCaClubModel>> getOnCaClub() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    int schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$groupClub');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCaClubModel> clubList =
          jsonData.map((item) => OnCaClubModel.fromJson(item)).toList();
      return clubList; // 모든 항목을 반환합니다.
    } else {
      print('동아리 데이터 에러: ${response.statusCode}.');
      throw Exception('Failed to load mentoring list');
    }
  }

  static Future<List<OnCaLectureModel>> getOnCaLecture() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    int schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$groupLecture');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCaLectureModel> lectureList =
          jsonData.map((item) => OnCaLectureModel.fromJson(item)).toList();
      return lectureList; // 모든 항목을 반환합니다.
    } else {
      print('특강 데이터 에러: ${response.statusCode}.');
      throw Exception('Failed to load mentoring list');
    }
  }

  static Future<List<OnCaCompetitionModel>> getOnCaCompetition() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    int schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$groupCompetition');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCaCompetitionModel> competitionList =
          jsonData.map((item) => OnCaCompetitionModel.fromJson(item)).toList();
      return competitionList; // 모든 항목을 반환합니다.
    } else {
      print('경진대회/캠프 데이터 에러: ${response.statusCode}.');
      throw Exception('Failed to load mentoring list');
    }
  }

  static Future<List<OnCaSpaceModel>> getOnCaSpace() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    int schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$groupSpace');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCaSpaceModel> spaceList =
          jsonData.map((item) => OnCaSpaceModel.fromJson(item)).toList();
      return spaceList; // 모든 항목을 반환합니다.
    } else {
      print('공간 데이터 에러: ${response.statusCode}.');
      throw Exception('Failed to load mentoring list');
    }
  }

  static Future<List<OnCaEtcModel>> getOnCaEtc() async {
    String schoolName =
        await UserInfo.getSchoolName(); // UserInfo에서 학교명을 가져옵니다.
    int schoolNumber = getSchoolNumber(schoolName);
    final url = Uri.parse('$baseUrl/$schoolNumber/$groupEtc');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<OnCaEtcModel> etcList =
          jsonData.map((item) => OnCaEtcModel.fromJson(item)).toList();
      return etcList; // 모든 항목을 반환합니다.
    } else {
      print('기타 데이터 에러: ${response.statusCode}.');
      throw Exception('Failed to load mentoring list');
    }
  }
}
