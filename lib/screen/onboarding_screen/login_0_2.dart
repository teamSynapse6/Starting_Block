import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/apple_api_manage.dart';
import 'package:starting_block/manage/api/kakao_api_manage.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/firebase/firebase_fcm_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;
  bool _isAppleSignInAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadAppleSignInAvailability();
  }

  Future<void> _loadAppleSignInAvailability() async {
    final isAvailable = await isAppleSignInSupportedOnCurrentPlatform();

    if (mounted) {
      setState(() {
        _isAppleSignInAvailable = isAvailable;
      });
    }
  }

  Future<void> _onKakaoTap() async {
    if (_isSigningIn) return;

    try {
      setState(() {
        _isSigningIn = true;
      });
      // signInWithKakao를 호출하고 로그인 결과를 기다림
      final kakaoUser = await signInWithKakao(context);

      // UserInfoManageApi를 통해 로그인 상태 확인
      UserSignInModel signInData = await UserInfoManageApi.postSignIn(
        kakaoUser.providerId,
        kakaoUser.email,
      );

      await _completeSignIn(signInData);
    } catch (error) {
      // 오류 처리
      debugPrint('카카오 로그인 또는 사용자 정보 확인 중 오류 발생: $error');
      // 오류가 발생한 경우 적절한 UI 피드백 제공
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  Future<void> _onAppleTap() async {
    if (_isSigningIn) return;

    try {
      setState(() {
        _isSigningIn = true;
      });

      final appleUser = await signInWithApple();
      final signInData = await UserInfoManageApi.postAppleSignIn(appleUser);

      await _completeSignIn(signInData);
    } catch (error) {
      // 오류 처리
      debugPrint('애플 로그인 또는 사용자 정보 확인 중 오류 발생: $error');
      // 오류가 발생한 경우 적절한 UI 피드백 제공
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  Future<void> _completeSignIn(UserSignInModel signInData) async {
    //유저 토큰 저장
    await UserTokenManage().setRefreshToken(signInData.refreshToken);
    await UserTokenManage().setAccessToken(signInData.accessToken);
    await FcmNotificationManage.registerCurrentToken();
    debugPrint(
        '로그인 완료: ${signInData.accessToken}\n 리프레시 토큰: ${signInData.refreshToken}');

    // 회원가입 완료 상태에 따른 화면 이동
    if (signInData.isSignUpComplete) {
      await SaveUserData.fetchAndSaveUserData();
      UserInfo().setLoginStatus(true);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          trackedRoute(
            builder: (context) => const IntergrateScreen(),
          ),
          (route) => false,
        );
      }
    } else {
      // 회원가입이 완료되지 않은 경우 NickNameScreen으로 이동
      if (mounted) {
        Navigator.of(context).push(
          trackedRoute(
            builder: (context) => const NickNameScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.v234,
            Text(
              "단계별 지원으로 한 단계 도약하기",
              style: AppTextStyles.bd2.copyWith(
                color: AppColors.g6,
              ),
            ),
            const Text(
              "대학생 창업 헬퍼 서비스는",
              style: TextStyle(
                color: AppColors.g6,
                fontFamily: "pretendard",
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v40,
            const Text(
              "스타팅블록",
              style: TextStyle(
                color: AppColors.blue,
                fontFamily: "score",
                fontSize: 50,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                bottom: Sizes.size140,
              ),
              child: Column(
                children: [
                  LoginButton(
                    onTap: _isSigningIn ? null : _onKakaoTap,
                    backgroundColor: const Color(0XFFFEE500),
                    text: "카카오로 로그인",
                    textColor: AppColors.g6,
                    icon: AppIcon.kako_icon,
                    thisStyle: AppTextStyles.bd3,
                  ),
                  if (_isAppleSignInAvailable) ...[
                    Gaps.v12,
                    LoginButton(
                      onTap: _isSigningIn ? null : _onAppleTap,
                      backgroundColor: AppColors.black,
                      text: "Sign in With Apple",
                      textColor: AppColors.white,
                      icon: AppIcon.apple_icon,
                      thisStyle: AppTextStyles.bd4,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
