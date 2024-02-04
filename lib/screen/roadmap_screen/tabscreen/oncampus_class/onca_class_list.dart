import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCaListClass extends StatelessWidget {
  final String thisTitle, thisId, thisLiberal, thisCredit, thisContent;
  final List<String> thisSession;

  const OnCaListClass({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisLiberal,
    required this.thisCredit,
    required this.thisContent,
    required this.thisSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
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
                BookMarkButton(
                  id: thisId,
                  classification: '창업강의',
                ),
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
                Wrap(
                  // Row 대신 Wrap 위젯을 사용합니다.
                  spacing: 8, // 각 칩 사이의 간격
                  children: thisSession
                      .map((session) =>
                          ClassSessionChips(thisTextSession: session))
                      .toList(),
                ),
              ],
            ),
            Gaps.v12,
            Text(
              '강의 개요',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
            ),
            Gaps.v4,
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
      ),
    );
  }
}
