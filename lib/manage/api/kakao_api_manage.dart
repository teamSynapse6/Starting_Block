// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<void> signInWithKakao(BuildContext context) async {
  print(await KakaoSdk.origin);

  // 카카오톡 실행 가능 여부 확인
  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();

      // 사용자 정보 요청
      User user = await UserApi.instance.me();
      print('사용자 ID: ${user.id}');
      print('사용자 이메일: ${user.kakaoAccount!.email}');

      // user.id와 userEmail을 안전하게 저장
      await secureStorage.write(key: 'kakaoUserID', value: user.id.toString());
      String? userEmail = user.kakaoAccount?.email;
      await secureStorage.write(key: 'kakaoUserEmail', value: userEmail ?? '');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      if (error is PlatformException && error.code == 'CANCELED') {
        // 사용자가 로그인을 취소한 경우
        return;
      }
      // 카카오계정으로 시도
      await tryKakaoAccountLogin(context);
    }
  } else {
    // 카카오계정으로 로그인 시도
    await tryKakaoAccountLogin(context);
  }
}

Future<void> tryKakaoAccountLogin(BuildContext context) async {
  try {
    await UserApi.instance.loginWithKakaoAccount();

    // 사용자 정보 요청
    User user = await UserApi.instance.me();
    print('사용자 ID: ${user.id}');
    print('사용자 이메일: ${user.kakaoAccount!.email}');

    // user.id와 userEmail을 안전하게 저장
    await secureStorage.write(key: 'kakaoUserID', value: user.id.toString());
    String? userEmail = user.kakaoAccount?.email;
    await secureStorage.write(key: 'kakaoUserEmail', value: userEmail ?? '');
  } catch (error) {
    print('카카오계정으로 로그인 실패: $error');
    if (error is Exception) {
      // 예외에 따른 추가적인 에러 처리를 여기에 구현할 수 있습니다.
    }
  }
}
