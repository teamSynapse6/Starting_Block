import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class OfCaCard extends StatelessWidget {
  final String thisOrganize,
      thisID,
      thisClassification,
      thisTitle,
      thisStartdate,
      thisEnddate;

  const OfCaCard({
    super.key,
    required this.thisOrganize,
    required this.thisID,
    required this.thisClassification,
    required this.thisTitle,
    required this.thisStartdate,
    required this.thisEnddate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OffCampusDetail(thisID: thisID),
            fullscreenDialog: false,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: 312,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
          border: const BorderDirectional(
            bottom: BorderSide(width: 2, color: AppColors.g1),
          ),
        ),
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
                  id: thisID,
                  classification: thisClassification,
                ),
              ],
            ),
            Gaps.v12,
            Text(
              thisTitle,
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
            ),
            Gaps.v10,
            Text(
              '등록일 $thisStartdate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
            Gaps.v4,
            Text(
              '마감일 $thisEnddate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
          ],
        ),
      ),
    );
  }
}
