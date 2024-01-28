import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class NextStep extends StatefulWidget {
  final VoidCallback onResetToCurrentStage;

  const NextStep({
    super.key,
    required this.onResetToCurrentStage,
  });
  @override
  State<NextStep> createState() => _NextStepState();
}

class _NextStepState extends State<NextStep> {
  void _thisNextTap() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogComponent(
          title: '단계를 도약하시겠습니까?',
          description: '단계 도약 후에는 이전 단계로 되돌아갈 수 없습니다',
          rightActionText: '도약하기',
          rightActionTap: () {
            Provider.of<RoadMapModel>(context, listen: false).moveToNextStage();
            Navigator.of(context).pop(); // 다이얼로그 닫기
            widget.onResetToCurrentStage();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _thisNextTap,
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
              AppIcon.next_g1,
            ],
          ),
        ),
      ),
    );
  }
}
