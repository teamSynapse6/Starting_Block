import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class KakaoLoginUser {
  final String providerId;
  final String email;

  const KakaoLoginUser({
    required this.providerId,
    required this.email,
  });
}

Future<KakaoLoginUser> signInWithKakao(BuildContext context) async {
  try {
    // 카카오 해시값 출력
    final origin = await KakaoSdk.origin;
    debugPrint('카카오해시값: $origin');

    // 카카오톡 설치 여부 확인
    bool kakaoTalkInstalled = await isKakaoTalkInstalled();

    if (kakaoTalkInstalled) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        return await _loadAndPersistKakaoUser();
      } catch (error) {
        if (error is PlatformException && error.code == 'CANCELED') {
          throw Exception('카카오 로그인이 취소되었습니다.');
        }
        if (context.mounted) {
          return await tryKakaoAccountLogin(context);
        }
        throw Exception('카카오톡 로그인 중 화면이 종료되었습니다.');
      }
    } else {
      if (context.mounted) {
        return await tryKakaoAccountLogin(context);
      }
      throw Exception('카카오 로그인 중 화면이 종료되었습니다.');
    }
  } catch (error) {
    debugPrint('카카오 로그인 실패: $error');
    rethrow;
  }
}

Future<KakaoLoginUser> tryKakaoAccountLogin(BuildContext context) async {
  try {
    await UserApi.instance.loginWithKakaoAccount();
    return await _loadAndPersistKakaoUser();
  } catch (error) {
    debugPrint('카카오계정 로그인 실패: $error');
    rethrow;
  }
}

Future<KakaoLoginUser> _loadAndPersistKakaoUser() async {
  final user = await UserApi.instance.me();
  final providerId = user.id.toString();
  final userEmail = user.kakaoAccount?.email;

  if (userEmail == null || userEmail.isEmpty) {
    throw Exception('카카오 계정 이메일을 불러오지 못했습니다.');
  }

  await secureStorage.write(key: 'kakaoUserID', value: providerId);
  await secureStorage.write(key: 'kakaoUserEmail', value: userEmail);

  return KakaoLoginUser(
    providerId: providerId,
    email: userEmail,
  );
}
