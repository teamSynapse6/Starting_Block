import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionStepper extends StatelessWidget {
  final int stage;

  const QuestionStepper({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              stage == 1
                  ? AppIcon.stepper_actived
                  : (stage == 2 || stage == 3)
                      ? AppIcon.stepper_actived
                      : AppIcon.stepper_inactived,
              Gaps.v4,
              Text(
                '질문 접수',
                style: AppTextStyles.btn2.copyWith(
                  color: AppColors.blue,
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              child: stage == 1 ? const DaskStroke() : const LineStroke(),
            ),
          ),
          Column(
            children: [
              stage == 2
                  ? AppIcon.stepper_actived
                  : stage == 3
                      ? AppIcon.stepper_actived
                      : AppIcon.stepper_inactived,
              Gaps.v4,
              Text(
                '질문 발송',
                style: AppTextStyles.btn2.copyWith(
                  color: stage == 2
                      ? AppColors.blue
                      : stage == 3
                          ? AppColors.blue
                          : AppColors.g3,
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(top: 12),
                child: stage == 2
                    ? const DaskStroke()
                    : stage == 3
                        ? const LineStroke()
                        : const LineStroke(
                            color: AppColors.g1,
                          )),
          ),
          Column(
            children: [
              stage == 3 ? AppIcon.stepper_actived : AppIcon.stepper_inactived,
              Gaps.v4,
              Text(
                '질문 발송',
                style: AppTextStyles.btn2.copyWith(
                  color: stage == 3 ? AppColors.blue : AppColors.g3,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
