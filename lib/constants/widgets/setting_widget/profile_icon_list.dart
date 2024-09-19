import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class ProfileEditIconList extends StatelessWidget {
  final Widget thisIcon;
  final String thisTitle, thisSubTitle, thisContent;

  const ProfileEditIconList({
    super.key,
    required this.thisIcon,
    required this.thisTitle,
    required this.thisSubTitle,
    required this.thisContent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        height: 64,
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.g1,
                borderRadius: BorderRadius.circular(32),
              ),
              child: thisIcon,
            ),
            Gaps.h12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v10,
                Text(
                  "$thisTitle $thisSubTitle",
                  style: AppTextStyles.bd3.copyWith(color: AppColors.g5),
                ),
                Gaps.v6,
                Text(
                  thisContent,
                  style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
