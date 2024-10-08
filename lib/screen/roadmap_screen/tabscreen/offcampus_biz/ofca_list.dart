import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OfCaList extends StatelessWidget {
  final String thisOrganize, thisID, thisClassification, thisTitle, thisDDay;
  final bool isSaved;

  const OfCaList({
    super.key,
    required this.thisOrganize,
    required this.thisID,
    required this.thisClassification,
    required this.thisTitle,
    required this.thisDDay,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    //D-Day와 그냥 문자열 처리
    String displayDDay;
    // Check if thisDDay is a number
    if (int.tryParse(thisDDay) != null) {
      displayDDay = 'D-$thisDDay';
    } else {
      displayDDay = thisDDay;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OffCampusDetail(thisID: thisID),
            fullscreenDialog: false,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                OrganizeChip(
                  text: thisOrganize,
                ),
                const Spacer(),
                BookMarkButton(
                  isSaved: isSaved,
                  thisID: thisID,
                )
              ],
            ),
            Gaps.v10,
            Text(
              thisTitle,
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gaps.v10,
            Text(
              displayDDay,
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
          ],
        ),
      ),
    );
  }
}
