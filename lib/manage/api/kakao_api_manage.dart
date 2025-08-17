import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<void> signInWithKakao(BuildContext context) async {
  try {
    // 카카오 해시값 출력
    final origin = await KakaoSdk.origin;
    debugPrint('카카오해시값: $origin');

    // 카카오톡 설치 여부 확인
    bool kakaoTalkInstalled = await isKakaoTalkInstalled();

    if (kakaoTalkInstalled) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        User user = await UserApi.instance.me();

        await secureStorage.write(
            key: 'kakaoUserID', value: user.id.toString());
        String? userEmail = user.kakaoAccount?.email;
        await secureStorage.write(
            key: 'kakaoUserEmail', value: userEmail ?? '');
      } catch (error) {
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        if (context.mounted) {
          await tryKakaoAccountLogin(context);
        }
      }
    } else {
      if (context.mounted) {
        await tryKakaoAccountLogin(context);
      }
    }
  } catch (error) {
    // signInWithKakao 전반 에러 처리 (필요한 경우 추가 구현)
  }
}

Future<void> tryKakaoAccountLogin(BuildContext context) async {
  try {
    await UserApi.instance.loginWithKakaoAccount();
    User user = await UserApi.instance.me();

    await secureStorage.write(key: 'kakaoUserID', value: user.id.toString());
    String? userEmail = user.kakaoAccount?.email;
    await secureStorage.write(key: 'kakaoUserEmail', value: userEmail ?? '');
  } catch (error) {
    // 카카오계정 로그인 에러 처리 (필요한 경우 추가 구현)
  }
}
