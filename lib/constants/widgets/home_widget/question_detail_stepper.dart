import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionDetailStepper extends StatelessWidget {
  final int questionStage;

  const QuestionDetailStepper({
    super.key,
    required this.questionStage,
  });

  @override
  Widget build(BuildContext context) {
    return questionStage == 1
        ? SizedBox(
            width: 32,
            child: Column(
              children: [
                AppIcon.stepper_actived,
                Gaps.v10,
                Column(
                  children: [
                    Container(width: 2, height: 4, color: AppColors.blue),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.blue),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.blue),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.g3),
                  ],
                ),
                Gaps.v18,
                AppIcon.stepper_octagon,
                Gaps.v19,
                Column(
                  children: [
                    Container(width: 2, height: 4, color: AppColors.g3),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.g3),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.g3),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.g3),
                  ],
                ),
                Gaps.v18,
                AppIcon.stepper_octagon,
              ],
            ),
          )
        : SizedBox(
            width: 32,
            child: Column(
              children: [
                AppIcon.stepper_actived,
                Gaps.v5,
                Column(
                  children: [
                    Container(width: 2, height: 4, color: AppColors.blue),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.blue),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.blue),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.blue),
                  ],
                ),
                Gaps.v18,
                AppIcon.stepper_actived,
                Gaps.v5,
                Column(
                  children: [
                    Container(width: 2, height: 4, color: AppColors.blue),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.blue),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.blue),
                    Gaps.v10,
                    Container(width: 2, height: 4, color: AppColors.g3),
                  ],
                ),
                Gaps.v23,
                AppIcon.stepper_octagon,
              ],
            ),
          );
  }
}
