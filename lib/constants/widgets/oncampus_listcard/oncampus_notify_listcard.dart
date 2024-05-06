import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCampusNotifyListCard extends StatelessWidget {
  final String thisProgramText, thisId, thisTitle, thisStartDate, thisUrl;

  const OnCampusNotifyListCard({
    super.key,
    required this.thisProgramText,
    required this.thisId,
    required this.thisTitle,
    required this.thisStartDate,
    required this.thisUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OncampusWebViewScreen(
                url: thisUrl,
                id: thisId,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                OrganizeChip(text: thisProgramText),
                const Spacer(),
              ],
            ),
            Gaps.v12,
            Text(
              thisTitle,
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
            ),
            Gaps.v8,
            Text(
              '등록일 $thisStartDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
          ],
        ),
      ),
    );
  }
}
