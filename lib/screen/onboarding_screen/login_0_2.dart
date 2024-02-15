// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _onNextTap() async {
    signInWithKakao(); // signInWithKakao 함수의 완료를 기다림
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NickNameScreen(),
      ),
    );
  }

  void signInWithKakao() async {
    // 카카오 로그인 구현 예제

// 카카오톡 실행 가능 여부 확인
// 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
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
