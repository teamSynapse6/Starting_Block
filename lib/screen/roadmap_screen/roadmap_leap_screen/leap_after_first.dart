import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starting_block/constants/constants.dart';

class LeapAfterFirstScreen extends StatelessWidget {
  const LeapAfterFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 페이지가 렌더링된 직후에 타이머를 설정합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.blue,
      ));
      Future.delayed(
        const Duration(seconds: 3),
        () {
          // 원래 상태로 돌리기 위한 스타일 설정
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent, // 원래 색상으로 설정
            systemNavigationBarIconBrightness:
                Brightness.dark, // 네비게이션 바 아이콘 색상 설정
          ));

          Navigator.of(context).pop();
        },
      );
    });

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColors.blue,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.v117,
              Text(
                '다음 단계의\n추천 지원 사업을 찾고 있어요',
                textAlign: TextAlign.center,
                style: AppTextStyles.st1.copyWith(color: AppColors.white),
              ),
              Gaps.v28,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AppAnimation.leap_after_first,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
