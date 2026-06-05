import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/api/api_baseurl.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class FcmApiManage {
  FcmApiManage._();

  static String baseUrl = apiBaseUrl;
  static String notificationToken = 'notification/token';

  static Future<Map<String, String>?> getHeaders() async {
    final accessToken = await UserTokenManage.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  static Future<bool> registerToken(
    String token, {
    String? deviceId,
    int retryCount = 1,
  }) async {
    if (token.isEmpty) {
      return false;
    }

    final headers = await getHeaders();
    if (headers == null) {
      debugPrint('FCM token register skipped: access token is empty.');
      return false;
    }

    final body = {
      'token': token,
      'platform': _platformName(),
      if (deviceId != null && deviceId.isNotEmpty) 'deviceId': deviceId,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/$notificationToken'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return _isSuccessfulResponse(response);
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return registerToken(
        token,
        deviceId: deviceId,
        retryCount: retryCount - 1,
      );
    } else {
      debugPrint(
          'FCM token register failed: ${response.statusCode}, ${response.body}');
      return false;
    }
  }

  static Future<bool> deleteToken(String token, {int retryCount = 1}) async {
    if (token.isEmpty) {
      return false;
    }

    final headers = await getHeaders();
    if (headers == null) {
      debugPrint('FCM token delete skipped: access token is empty.');
      return false;
    }

    final request = http.Request(
      'DELETE',
      Uri.parse('$baseUrl/$notificationToken'),
    );
    request.headers.addAll(headers);
    request.body = jsonEncode({'token': token});

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return _isSuccessfulResponse(response);
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return deleteToken(token, retryCount: retryCount - 1);
    } else {
      debugPrint(
          'FCM token delete failed: ${response.statusCode}, ${response.body}');
      return false;
    }
  }

  static bool _isSuccessfulResponse(http.Response response) {
    if (response.bodyBytes.isEmpty) {
      return true;
    }
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) {
        return decoded['check'] == true;
      }
      if (decoded is bool) {
        return decoded;
      }
      return decoded?.toString().toLowerCase() != 'false';
    } catch (_) {
      return response.statusCode >= 200 && response.statusCode < 300;
    }
  }

  static String _platformName() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'ANDROID';
      case TargetPlatform.iOS:
        return 'IOS';
      case TargetPlatform.macOS:
        return 'MACOS';
      case TargetPlatform.windows:
        return 'WINDOWS';
      case TargetPlatform.linux:
        return 'LINUX';
      case TargetPlatform.fuchsia:
        return 'FUCHSIA';
    }
  }
}
