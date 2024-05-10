import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:starting_block/constants/constants.dart';

class HomeQuestionRecommendList extends StatelessWidget {
  final String thisAnnouncementType,
      thisTitle,
      thisContent,
      thisHeartCount,
      thisDate;
  final VoidCallback thisTap;

  const HomeQuestionRecommendList({
    super.key,
    required this.thisAnnouncementType,
    required this.thisTitle,
    required this.thisContent,
    required this.thisHeartCount,
    required this.thisDate,
    required this.thisTap,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(DateTime.parse(thisDate));

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: thisTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 26,
            color: AppColors.g1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  thisAnnouncementType == '교외'
                      ? Text(
                          '교외',
                          style: AppTextStyles.bd6
                              .copyWith(color: AppColors.salmon),
                        )
                      : Text(
                          '교내',
                          style:
                              AppTextStyles.bd6.copyWith(color: AppColors.blue),
                        ),
                  Gaps.h12,
                  Expanded(
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      thisTitle,
                      style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gaps.v12,
          Text(
            thisContent,
            style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            maxLines: 2,
          ),
          Gaps.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '저도 궁금해요 $thisHeartCount',
                style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
              ),
              Text(
                formattedDate,
                style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
              ),
            ],
          )
        ],
      ),
    );
  }
}
