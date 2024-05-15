import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeNotifyRecommendList extends StatelessWidget {
  final String thisOrganize, thisTitle, thisDday, thisAnnouncementType;
  final VoidCallback thisTap;

  const HomeNotifyRecommendList({
    super.key,
    required this.thisOrganize,
    required this.thisTitle,
    required this.thisDday,
    required this.thisAnnouncementType,
    required this.thisTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: thisTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OfcaOncaChip(
                isOfca: thisAnnouncementType == '교외' ? true : false,
              ),
              Gaps.h8,
              OrganizeChipForHome(text: thisOrganize),
            ],
          ),
          Gaps.v10,
          Text(
            thisTitle,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            maxLines: 2,
          ),
          if (thisAnnouncementType == '교외')
            Column(
              children: [
                Gaps.v8,
                Text(
                  'D-$thisDday',
                  style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
