import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusGroupList extends StatelessWidget {
  final String thisTitle, thisContent;

  const OnCampusGroupList({
    super.key,
    required this.thisTitle,
    required this.thisContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              thisTitle,
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
            ),
            Gaps.v4,
            Text(
              thisContent,
              style: AppTextStyles.bd2.copyWith(color: AppColors.g5),
            )
          ],
        ),
      ),
    );
  }
}
