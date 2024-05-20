import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionWriteComplete extends StatefulWidget {
  const QuestionWriteComplete({super.key});

  @override
  State<QuestionWriteComplete> createState() => _QuestionWriteCompleteState();
}

class _QuestionWriteCompleteState extends State<QuestionWriteComplete> {
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

          // Navigator.pop을 호출하기 전에 안전성을 검사합니다.

          Navigator.of(context).pop();
        },
      );
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [topColor, bottomColor],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gaps.v114,
                Text(
                  '질문 작성 완료!',
                  style: AppTextStyles.h3.copyWith(color: AppColors.white),
                ),
                Gaps.v8,
                Text(
                  '빠른 궁금증 해결과\n성공적인 공고 준비를 도와줄게요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bd2.copyWith(color: AppColors.white),
                ),
                Gaps.v28,
                Center(child: AppAnimation.question_write_complete),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
