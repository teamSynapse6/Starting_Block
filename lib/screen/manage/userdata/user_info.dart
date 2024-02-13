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

  Future<void> setNickName(String nickName) async {
    await _prefs.setString('userNickName', nickName);
    _hasChanged = true;
    notifyListeners(); // 닉네임 변경 후 리스너에게 알림
  }

  static Future<String> getNickName() async {
    await initialize();
    return _prefs.getString('userNickName') ?? "";
  }

  Future<void> setEntrepreneurCheck(bool isEntrepreneur) async {
    await _prefs.setBool('enterpreneurCheck', isEntrepreneur);
    _hasChanged = true;
    notifyListeners();
  }

  static Future<bool> getEntrepreneurCheck() async {
    await initialize(); // 초기화가 필요한 경우 여기에 추가
    return _prefs.getBool('enterpreneurCheck') ?? false;
  }

  Future<void> setResidence(String residence) async {
    await _prefs.setString('userResidence', residence);
    _hasChanged = true;
    notifyListeners();
  }

  static Future<String> getResidence() async {
    await initialize(); // SharedPreferences 인스턴스를 초기화합니다.
    return _prefs.getString('userResidence') ?? "";
  }

  Future<void> setSchoolName(String schoolName) async {
    await _prefs.setString('userSchoolName', schoolName);
    _hasChanged = true;
    notifyListeners();
  }

  static Future<String> getSchoolName() async {
    await initialize();
    return _prefs.getString('userSchoolName') ?? "";
  }
}
