// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

Future<void> signInWithKakao(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 카카오톡 실행 가능 여부 확인
  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();

      // 사용자 정보 요청
      User user = await UserApi.instance.me();
      print('사용자 ID: ${user.id}');

      // user.id를 SharedPreferences에 저장
      await prefs.setInt('kakaoUserID', user.id);

      // 로그인 성공 시 NickNameScreen으로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NickNameScreen(),
        ),
      );
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      if (error is PlatformException && error.code == 'CANCELED') {
        // 사용자가 로그인을 취소한 경우
        return;
      }

      // 카카오계정으로 시도
      await tryKakaoAccountLogin(prefs, context);
    }
  } else {
    // 카카오계정으로 로그인 시도
    await tryKakaoAccountLogin(prefs, context);
  }
}

Future<void> tryKakaoAccountLogin(
    SharedPreferences prefs, BuildContext context) async {
  try {
    await UserApi.instance.loginWithKakaoAccount();

    // 사용자 정보 요청
    User user = await UserApi.instance.me();
    print('사용자 ID: ${user.id}');

    // user.id를 SharedPreferences에 저장
    await prefs.setInt('kakaoUserID', user.id);

    // 로그인 성공 시 NickNameScreen으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NickNameScreen(),
      ),
    );
  } catch (error) {
    print('카카오계정으로 로그인 실패 $error');
  }
}
