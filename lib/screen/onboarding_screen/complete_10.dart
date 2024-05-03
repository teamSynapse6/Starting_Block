import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 레이아웃이 완성된 직후에 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const IntergrateScreen(),
          ),
        );
      });
    });

    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v108,
                Row(
                  children: [
                    Gaps.h16,
                    Text(
                      '도약할 준비 완료!\n앞으로의 창업 로드를 응원해요',
                      style: AppTextStyles.st1.copyWith(color: AppColors.g6),
                    ),
                  ],
                ),
                Gaps.v49,
                //여기에 애니메이션 들어가야 함.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
