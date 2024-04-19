// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/kakao_api_manage.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void _onNextTap() async {
    try {
      // signInWithKakao를 호출하고 로그인 결과를 기다림
      await signInWithKakao(context);

      // FlutterSecureStorage에서 userID와 userEmail 불러오기
      String? userId = await secureStorage.read(key: 'kakaoUserID');
      String? userEmail = await secureStorage.read(key: 'kakaoUserEmail');

      if (userId == null || userEmail == null) {
        throw Exception('저장된 사용자 정보를 찾을 수 없습니다.');
      }

      // UserInfoManageApi를 통해 로그인 상태 확인
      UserSignInModel signInData =
          await UserInfoManageApi.postSignIn(userId, userEmail);

      //유저 토큰 저장
      await UserTokenManage().setRefreshToken(signInData.refreshToken);
      await UserTokenManage().setAccessToken(signInData.accessToken);

      // 회원가입 완료 상태에 따른 화면 이동
      if (signInData.isSignUpComplete) {
        UserInfo().setLoginStatus(true);
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const IntergrateScreen(),
            ),
          );
        }
      } else {
        // 회원가입이 완료되지 않은 경우 NickNameScreen으로 이동
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NickNameScreen(),
            ),
          );
        }
      }
    } catch (error) {
      // 오류 처리
      print('로그인 또는 사용자 정보 확인 중 오류 발생: $error');
      // 오류가 발생한 경우 적절한 UI 피드백 제공
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
              child: GestureDetector(
                onTap: _onNextTap,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0XFFFEE500),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 13,
                            left: 16,
                            child: AppIcon.kako_icon,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "카카오로 로그인",
                              style: AppTextStyles.bd3.copyWith(
                                color: AppColors.g6,
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
