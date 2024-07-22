import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionExpandedStepper extends StatelessWidget {
  final int questionStage;

  const QuestionExpandedStepper({
    super.key,
    required this.questionStage,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double barWidth = screenWidth - 72; // 36 + 36 = 72 (좌우 Gaps.h36)
    final double step1Width = barWidth * (105 / 280);
    final double step2Width = barWidth * (205 / 280);
    final double step3Width = barWidth * (236 / 280);

    return Stack(
      children: [
        Container(
          width: screenWidth,
          height: 8,
          color: AppColors.g1,
        ),
        if (questionStage == 1)
          Container(
            width: step1Width,
            height: 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff5E8BFF),
                  Color(0xffB1C5F6),
                ],
              ),
            ),
          ),
        if (questionStage == 2)
          Container(
            width: step2Width,
            height: 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff5E8BFF),
                  Color(0xffB1C5F6),
                ],
              ),
            ),
          ),
        if (questionStage == 3)
          Container(
            width: step3Width,
            height: 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff5E8BFF),
                  Color(0xffB1C5F6),
                ],
              ),
            ),
          ),
        Positioned(
          top: 0,
          left: 36, // Gaps.h36
          right: 36, // Gaps.h36
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                color: AppColors.blue,
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                color: questionStage >= 2 ? AppColors.blue : AppColors.g2,
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                color: questionStage >= 3 ? AppColors.blue : AppColors.g2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
