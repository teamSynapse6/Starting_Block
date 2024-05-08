import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionDetailStepText extends StatelessWidget {
  final int questionStage;
  const QuestionDetailStepText({
    super.key,
    required this.questionStage,
  });

  @override
  Widget build(BuildContext context) {
    return questionStage == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v2,
              Text(
                '질문 접수',
                style: AppTextStyles.st2.copyWith(color: AppColors.black),
              ),
              Gaps.v6,
              Text(
                '답변이 있는 유사 질문이 있는지 확인중\n',
                style: AppTextStyles.bd6.copyWith(color: AppColors.blue),
              ),
              Gaps.v32,
              Text(
                '질문 발송',
                style: AppTextStyles.st2.copyWith(color: AppColors.g4),
              ),
              Gaps.v6,
              Text(
                '내일 오전 9시 발송 예정\n',
                style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
              ),
              Gaps.v36,
              Text(
                '답변 도착',
                style: AppTextStyles.st2.copyWith(color: AppColors.g4),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v2,
              Text(
                '질문 접수',
                style: AppTextStyles.st2.copyWith(color: AppColors.black),
              ),
              Gaps.v6,
              Text(
                '답변이 있는 유사 질문이 없어요\n문의처로 질문을 발송합니다',
                style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
              ),
              Gaps.v32,
              Text(
                '질문 발송',
                style: AppTextStyles.st2.copyWith(color: AppColors.black),
              ),
              Gaps.v6,
              Text(
                '19일 오전 9시 발송 완료\n',
                style: AppTextStyles.bd6.copyWith(color: AppColors.blue),
              ),
              Gaps.v36,
              Text(
                '답변 도착',
                style: AppTextStyles.st2.copyWith(color: AppColors.g4),
              ),
            ],
          );
  }
}
