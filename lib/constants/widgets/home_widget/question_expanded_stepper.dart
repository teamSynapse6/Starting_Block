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
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 8,
          color: AppColors.g1,
        ),
        if (questionStage == 1)
          Container(
            width: (MediaQuery.of(context).size.width - 80) * (105 / 280),
            height: 8,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xff5E8BFF),
                Color(0xffB1C5F6),
              ],
            )),
          ),
        if (questionStage == 2)
          Container(
            width: (MediaQuery.of(context).size.width - 80) * (205 / 280),
            height: 8,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xff5E8BFF),
                Color(0xffB1C5F6),
              ],
            )),
          ),
        if (questionStage == 3)
          Container(
            width: (MediaQuery.of(context).size.width - 80) * (244 / 280),
            height: 8,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xff5E8BFF),
                Color(0xffB1C5F6),
              ],
            )),
          ),
        Row(
          children: [
            Gaps.h36,
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
            Gaps.h36,
          ],
        )
      ],
    );
  }
}
