// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class ItemList extends StatelessWidget {
  final String thisID, thisOrganize, thisTitle, thisStartDate, thisEndDate;
  final bool isSaved;
  final bookMarkTap;

  const ItemList({
    super.key,
    required this.thisID,
    required this.thisOrganize,
    required this.thisTitle,
    required this.thisStartDate,
    required this.thisEndDate,
    required this.isSaved, //여기부터 저장 기능
    required this.bookMarkTap,
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
        decoration: const BoxDecoration(
          color: Colors.white,
          border: BorderDirectional(
            bottom: BorderSide(width: 2, color: AppColors.g1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v16,
            Row(
              children: [
                OrganizeChip(text: thisOrganize),
                const Spacer(),
                GestureDetector(
                  onTap: bookMarkTap,
                  child: Image(
                      image: isSaved
                          ? AppImages.bookmark_actived
                          : AppImages.bookmark_inactived),
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
              '등록일 $thisStartDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
            Gaps.v4,
            Text(
              '마감일 $thisEndDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
            Gaps.v16
          ],
        ),
      ),
    );
  }
}
