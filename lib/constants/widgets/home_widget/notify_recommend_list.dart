import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeNotifyRecommendList extends StatelessWidget {
  final String thisOrganize, thisTitle, thisDday, thisAnnouncementType;

  const HomeNotifyRecommendList({
    super.key,
    required this.thisOrganize,
    required this.thisTitle,
    required this.thisDday,
    required this.thisAnnouncementType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            OfcaOncaChip(
              isOfca: thisAnnouncementType == '교외' ? true : false,
            ),
            Gaps.h8,
            OrganizeChip(text: thisOrganize),
          ],
        ),
        Gaps.v10,
        Text(
          thisTitle,
          style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
          maxLines: 2,
        ),
        Gaps.v8,
        Text(
          'D-$thisDday',
          style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
        )
      ],
    );
  }
}
