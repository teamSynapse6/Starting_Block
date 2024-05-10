// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class CuriousVote26 extends StatelessWidget {
  final bool isMine;
  final int heartCount;

  const CuriousVote26({
    super.key,
    required this.isMine,
    required this.heartCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Ink(
        height: 26,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isMine ? AppIcon.vote_active_18 : AppIcon.vote_inactive_18,
            Gaps.h2,
            Text(
              '궁금해요',
              style: isMine
                  ? AppTextStyles.btn2.copyWith(color: AppColors.blue)
                  : AppTextStyles.btn2.copyWith(color: AppColors.g4),
            ),
            Gaps.h2,
            Text(
              heartCount.toString(),
              style: isMine
                  ? AppTextStyles.btn2.copyWith(color: AppColors.blue)
                  : AppTextStyles.btn2.copyWith(color: AppColors.g4),
            )
          ],
        ),
      ),
    );
  }
}

class CuriousVote36 extends StatelessWidget {
  final bool isMine;
  final int heartCount;
  final VoidCallback thisTap;

  const CuriousVote36({
    super.key,
    required this.isMine,
    required this.heartCount,
    required this.thisTap,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 36,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: thisTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isMine ? AppIcon.vote_active_24 : AppIcon.vote_inactive_24,
            Gaps.h2,
            Text(
              '궁금해요',
              style: isMine
                  ? AppTextStyles.btn2.copyWith(color: AppColors.blue)
                  : AppTextStyles.btn2.copyWith(color: AppColors.g4),
            ),
            Gaps.h2,
            Text(
              heartCount.toString(),
              style: isMine
                  ? AppTextStyles.btn2.copyWith(color: AppColors.blue)
                  : AppTextStyles.btn2.copyWith(color: AppColors.g4),
            )
          ],
        ),
      ),
    );
  }
}

class ReplyHelped49 extends StatelessWidget {
  final bool isMine;
  final int heartCount;
  final VoidCallback thisTap;

  const ReplyHelped49({
    super.key,
    required this.isMine,
    required this.heartCount,
    required this.thisTap,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 36,
      child: InkWell(
        onTap: thisTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isMine ? AppIcon.vote_active_18 : AppIcon.vote_inactive_18,
            Gaps.h2,
            Text(
              '궁금해요',
              style: isMine
                  ? AppTextStyles.btn2.copyWith(color: AppColors.blue)
                  : AppTextStyles.btn2.copyWith(color: AppColors.g4),
            ),
            Gaps.h2,
            Text(
              heartCount.toString(),
              style: isMine
                  ? AppTextStyles.btn2.copyWith(color: AppColors.blue)
                  : AppTextStyles.btn2.copyWith(color: AppColors.g4),
            )
          ],
        ),
      ),
    );
  }
}
