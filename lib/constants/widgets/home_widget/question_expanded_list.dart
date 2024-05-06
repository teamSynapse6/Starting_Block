import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeQuestionStepExpandedList extends StatelessWidget {
  const HomeQuestionStepExpandedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 14,
              width: 2,
              color: AppColors.g4,
            ),
            Gaps.h8,
            Expanded(
              child: Text(
                '질문 단계zzzzzzzzzzㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ',
                style: AppTextStyles.bd3.copyWith(color: AppColors.g6),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Gaps.v8,
        Text(
          '멘토링ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ',
          style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Gaps.v16,
        const QuestionExpandedStepper(questionStage: 1),
        Gaps.v6,
        const Row(
          children: [
            Gaps.h16,
            SizedBox(
              width: 48,
              height: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '질문 접수',
                    style: TextStyle(
                      fontFamily: 'pretendard',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 14 / 10,
                      color: AppColors.blue,
                    ),
                  ),
                  Text(
                    '(04.06)',
                    style: TextStyle(
                      fontFamily: 'pretendard',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 14 / 10,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: 48,
              height: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '질문 접수',
                    style: TextStyle(
                      fontFamily: 'pretendard',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 14 / 10,
                      color: AppColors.blue,
                    ),
                  ),
                  Text(
                    '(04.06)',
                    style: TextStyle(
                      fontFamily: 'pretendard',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 14 / 10,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: 48,
              height: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '질문 접수',
                    style: TextStyle(
                      fontFamily: 'pretendard',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 14 / 10,
                      color: AppColors.blue,
                    ),
                  ),
                  Text(
                    '(04.06)',
                    style: TextStyle(
                      fontFamily: 'pretendard',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 14 / 10,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.h16,
          ],
        )
      ],
    );
  }
}
