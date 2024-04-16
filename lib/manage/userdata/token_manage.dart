import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class UserTokenManage extends ChangeNotifier {
  bool _hasChanged = false;
  bool get hasChanged => _hasChanged;

  Future<void> resetChangeFlag() async {
    _hasChanged = false;
    notifyListeners();
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await secureStorage.write(key: 'refreshToken', value: refreshToken);
    _hasChanged = true;
    notifyListeners();
  }

  static Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: 'refreshToken');
  }

  Future<void> setAccessToken(String accessToken) async {
    await secureStorage.write(key: 'accessToken', value: accessToken);
    _hasChanged = true;
    notifyListeners();
  }

  static Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'accessToken');
  }
}
