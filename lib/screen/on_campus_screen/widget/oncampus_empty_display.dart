import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusEmptyDisplay extends StatelessWidget {
  final String userNickName;

  const OnCampusEmptyDisplay({super.key, required this.userNickName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gaps.v104,
        Text(
          '$userNickName님의 교내 정보를 준비중이에요',
          style: AppTextStyles.bd1.copyWith(color: AppColors.g4),
          textAlign: TextAlign.center,
        ),
        Gaps.v6,
        Text(
          '빠른 시일 내에, 정보를 제공할 수 있도록\n열심히 달리는 중입니다',
          style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
          textAlign: TextAlign.center,
        ),
        Gaps.v12,
        AppIcon.starter_emptylist,
      ],
    );
  }
}
