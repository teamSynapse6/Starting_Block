import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setNickName(String nickName) async {
    await _prefs.setString('userNickName', nickName);
  }

  static Future<String> getNickName() async {
    await initialize();
    return _prefs.getString('userNickName') ?? "";
  }

  static Future<void> setEntrepreneurCheck(bool isEntrepreneur) async {
    await _prefs.setBool('enterpreneurCheck', isEntrepreneur);
  }

  static bool getEntrepreneurCheck() {
    return _prefs.getBool('enterpreneurCheck') ?? false;
  }

  static Future<void> setResidence(String residence) async {
    await _prefs.setString('userResidence', residence);
  }

  static String getResidence() {
    return _prefs.getString('userResidence') ?? "";
  }

  static Future<void> setSchoolName(String schoolName) async {
    await _prefs.setString('userSchoolName', schoolName);
  }

  static Future<String> getSchoolName() async {
    await initialize();
    return _prefs.getString('userSchoolName') ?? "";
  }
}
