import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends ChangeNotifier {
  static late SharedPreferences _prefs;
  bool _hasChanged = false; // 데이터 변경 플래그
  bool get hasChanged => _hasChanged;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void resetChangeFlag() {
    Future.microtask(() {
      _hasChanged = false;
      notifyListeners();
    });
  }

  //닉네임 메소드
  Future<void> setNickName(String nickName) async {
    await _prefs.setString('userNickName', nickName);
    _hasChanged = true;
    notifyListeners(); // 닉네임 변경 후 리스너에게 알림
  }

  static Future<String> getNickName() async {
    await initialize();
    return _prefs.getString('userNickName') ?? "";
  }

  // 생일 메소드
  Future<void> setUserBirthday(String birthday) async {
    await _prefs.setString('userBirthday', birthday);
    _hasChanged = true;
    notifyListeners(); // 생일 정보 변경 후 리스너에게 알림
  }

  static Future<String> getUserBirthday() async {
    await initialize();
    return _prefs.getString('userBirthday') ?? "";
  }

  //사업자 등록 메소드
  Future<void> setEntrepreneurCheck(bool isEntrepreneur) async {
    await _prefs.setBool('enterpreneurCheck', isEntrepreneur);
    _hasChanged = true;
    notifyListeners();
  }

  static Future<bool> getEntrepreneurCheck() async {
    await initialize(); // 초기화가 필요한 경우 여기에 추가
    return _prefs.getBool('enterpreneurCheck') ?? false;
  }

  //거주지 메소드
  Future<void> setResidence(String residence) async {
    await _prefs.setString('userResidence', residence);
    _hasChanged = true;
    notifyListeners();
  }

  static Future<String> getResidence() async {
    await initialize(); // SharedPreferences 인스턴스를 초기화합니다.
    return _prefs.getString('userResidence') ?? "";
  }

  //학교명 메소드
  Future<void> setSchoolName(String schoolName) async {
    await _prefs.setString('userSchoolName', schoolName);
    _hasChanged = true;
    notifyListeners();
  }

  static Future<String> getSchoolName() async {
    await initialize();
    return _prefs.getString('userSchoolName') ?? "";
  }

  // UUID 메소드
  static Future<String> getUserUUID() async {
    await initialize();
    return _prefs.getString('userUuid') ?? "";
  }

  // 아이콘 메소드
  Future<void> setSelectedIconIndex(int index) async {
    await _prefs.setInt('selectedIconIndex', index);
    _hasChanged = true;
    notifyListeners(); // 아이콘 인덱스 변경 후 리스너에게 알림
  }

  static Future<int> getSelectedIconIndex() async {
    await initialize();
    return _prefs.getInt('selectedIconIndex') ?? 1;
  }

  // kakaoUserID 가져오기
  static Future<int> getKakaoUserID() async {
    await initialize(); // SharedPreferences 인스턴스를 초기화합니다.
    return _prefs.getInt('kakaoUserID') ?? 0; // 기본값으로 0을 반환하도록 설정
  }
}
