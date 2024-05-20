import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusSysListCard extends StatelessWidget {
  final String thisTitle, thisId, thisContent, thisTarget;
  final bool isBookmarked;

  const OnCampusSysListCard({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisContent,
    required this.thisTarget,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    thisTitle,
                    style: AppTextStyles.bd1.copyWith(color: AppColors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gaps.h15,
                BookMarkButton(
                  thisID: thisId,
                  isSaved: isBookmarked,
                ),
              ],
            ),
            if (thisContent.isNotEmpty ||
                thisContent != '.' ||
                thisTarget.isNotEmpty ||
                thisTarget != '.')
              Gaps.v8,
            if (thisContent.isNotEmpty || thisContent != '.')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내용',
                    style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
                  ),
                  Gaps.v4,
                  Text(
                    thisContent,
                    style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                  ),
                  Gaps.v12,
                ],
              ),
            if (thisTarget.isNotEmpty || thisTarget != '.')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '지원 대상',
                    style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
                  ),
                  Gaps.v4,
                  Text(
                    thisTarget,
                    style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
