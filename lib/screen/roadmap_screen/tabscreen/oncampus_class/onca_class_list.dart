import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCaListClass extends StatelessWidget {
  final String thisTitle,
      // thisId,
      thisLiberal,
      thisCredit,
      thisContent,
      thisTeacher,
      thisSession;

  const OnCaListClass({
    super.key,
    required this.thisTitle,
    // required this.thisId,
    required this.thisLiberal,
    required this.thisCredit,
    required this.thisContent,
    required this.thisSession,
    required this.thisTeacher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                thisTitle,
                style: AppTextStyles.bd1.copyWith(color: AppColors.black),
              ),
              const Spacer(),
              // BookMarkButton(
              //   id: thisId,
              //   classification: '창업강의',
              // ),
            ],
          ),
          Gaps.v20,
          const CustomDivider(),
          Gaps.v12,
          Row(
            children: [
              ClassLiberalChips(thisText: thisLiberal),
              Gaps.h8,
              ClassCreditsChips(thisTextNum: thisCredit),
              Gaps.h8,
              ClassSessionChips(thisTextSession: thisSession),
            ],
          ),
          Gaps.v12,
          Text(
            '교강사',
            style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
          ),
          Gaps.v2,
          Text(
            thisTeacher,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
          ),
          Gaps.v12,
          Text(
            '강의 개요',
            style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
          ),
          Gaps.v2,
          Text(
            thisContent,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
          ),
          Gaps.v10,
          Row(
            children: [
              const Spacer(),
              Text(
                '상세 내용 확인하기',
                style: AppTextStyles.btn2.copyWith(color: AppColors.g4),
              ),
              Gaps.h4,
              AppIcon.next_rightsorted_g4
            ],
          ),
        ],
      ),
    );
  }
}
