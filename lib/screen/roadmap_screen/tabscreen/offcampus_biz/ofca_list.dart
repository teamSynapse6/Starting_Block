import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

String calculateDDayList(String endDate) {
  int year = int.parse(endDate.substring(0, 4));
  int month = int.parse(endDate.substring(4, 6));
  int day = int.parse(endDate.substring(6, 8));

  DateTime endDateTime = DateTime(year, month, day);
  DateTime now = DateTime.now();
  Duration difference = endDateTime.difference(now);

  if (difference.inDays < 0) {
    return 'D+${-difference.inDays}';
  } else if (difference.inDays == 0) {
    return 'D-Day';
  } else {
    return 'D-${difference.inDays}';
  }
}

class OfCaList extends StatelessWidget {
  final String thisOrganize, thisID, thisClassification, thisTitle, thisEnddate;

  const OfCaList({
    super.key,
    required this.thisOrganize,
    required this.thisID,
    required this.thisClassification,
    required this.thisTitle,
    required this.thisEnddate,
  });

  @override
  Widget build(BuildContext context) {
    String dDay = calculateDDayList(thisEnddate);

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
        width: 312,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
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
                    id: thisID,
                    classification: thisClassification,
                  ),
                ],
              ),
              Gaps.v10,
              Text(
                thisTitle,
                style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gaps.v4,
              Text(
                dDay,
                style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
