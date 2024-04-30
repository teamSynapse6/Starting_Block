import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starting_block/constants/constants.dart';

class LeapFirstScreen extends StatelessWidget {
  const LeapFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color topColor = const Color(0xFF5E8BFF);
    Color bottomColor = const Color(0xFF87A8FA);

    // 페이지가 렌더링된 직후에 타이머를 설정합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: bottomColor,
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                topColor,
                bottomColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gaps.v112,
                const Text(
                  '첫 도약 완료!',
                  style: TextStyle(
                    fontFamily: 'score',
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    color: AppColors.white,
                    height: 1.25,
                  ),
                ),
                Gaps.v4,
                Text(
                  '앞으로의 성장을 기대할게요',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.white),
                )
              ],
            ),
          )),
    );
  }
}
