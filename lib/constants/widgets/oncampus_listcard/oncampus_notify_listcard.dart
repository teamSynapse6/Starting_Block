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
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: thisUrl,
                id: thisId,
                classification: '교내사업',
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
                // BookMarkButton(id: thisId, classification: '교내사업')
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
            Gaps.v16,
            const CustomDivider(),
          ],
        ),
      ),
    );
  }
}
