import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusClassListCard extends StatelessWidget {
  final String thisTitle,
      thisId,
      thisLiberal,
      thisCredit,
      thisInstructor,
      thisContent,
      thisSession;
  final bool isBookmarked;

  const OnCampusClassListCard({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisLiberal,
    required this.thisCredit,
    required this.thisInstructor,
    required this.thisContent,
    required this.thisSession,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  thisTitle,
                  style: AppTextStyles.bd1.copyWith(color: AppColors.black),
                ),
                const Spacer(),
                BookMarkButton(
                  isSaved: isBookmarked,
                  thisID: thisId,
                )
              ],
            ),
            Gaps.v12,
            const CustomDivider(),
            Gaps.v16,
            Row(
              children: [
                ClassLiberalChips(
                  thisText: thisLiberal,
                ),
                Gaps.h8,
                ClassCreditsChips(thisTextNum: thisCredit),
                Gaps.h8,
                ClassSessionChips(thisTextSession: thisSession),
              ],
            ),
            Gaps.v12,
            Text(
              '교강사',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
            ),
            Gaps.v2,
            Text(
              thisInstructor,
              style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            ),
            Gaps.v12,
            Text(
              '강의 개요',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
            ),
            Gaps.v2,
            Text(
              thisContent,
              style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            ),
          ],
        ),
      ),
    );
  }
}
