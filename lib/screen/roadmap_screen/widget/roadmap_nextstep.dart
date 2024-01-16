import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class NextStep extends StatefulWidget {
  const NextStep({super.key});

  @override
  State<NextStep> createState() => _NextStepState();
}

class _NextStepState extends State<NextStep> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // RoadMapModel에 접근하여 moveToNextStage 메소드를 호출
        Provider.of<RoadMapModel>(context, listen: false).moveToNextStage();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(4),
        ),
        height: 32,
        width: 129,
        child: Center(
          child: Row(
            children: [
              Gaps.h12,
              Text(
                '다음 단계 도약하기',
                style: AppTextStyles.btn2.copyWith(color: AppColors.white),
              ),
              Gaps.h2,
              Image(image: AppImages.next_g1)
            ],
          ),
        ),
      ),
    );
  }
}
