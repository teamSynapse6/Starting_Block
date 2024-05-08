import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeQuestionStepExpandedList extends StatelessWidget {
  final int questionStage;
  final VoidCallback thisQuestionTap;

  const HomeQuestionStepExpandedList({
    super.key,
    required this.questionStage,
    required this.thisQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: thisQuestionTap,
      child: Column(
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
          QuestionExpandedStepper(
            questionStage: questionStage, //질문단계
          ),
          Gaps.v6,
          Row(
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
                      style: questionStage >= 2
                          ? const TextStyle(
                              fontFamily: 'pretendard',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 14 / 10,
                              color: AppColors.bluelight,
                            )
                          : const TextStyle(
                              fontFamily: 'pretendard',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 14 / 10,
                              color: AppColors.blue,
                            ),
                    ),
                    Text(
                      '(04.06)',
                      style: questionStage >= 2
                          ? const TextStyle(
                              fontFamily: 'pretendard',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 14 / 10,
                              color: AppColors.bluelight,
                            )
                          : const TextStyle(
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
              const Spacer(),
              SizedBox(
                width: 48,
                height: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('질문 발송',
                        style: questionStage == 1
                            ? AppTextStyles.caption
                                .copyWith(color: AppColors.g3)
                            : questionStage == 2
                                ? const TextStyle(
                                    fontFamily: 'pretendard',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    height: 14 / 10,
                                    color: AppColors.blue,
                                  )
                                : const TextStyle(
                                    fontFamily: 'pretendard',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    height: 14 / 10,
                                    color: AppColors.bluelight,
                                  )),
                    if (questionStage >= 2)
                      Text('(04.06)',
                          style: questionStage == 2
                              ? const TextStyle(
                                  fontFamily: 'pretendard',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 14 / 10,
                                  color: AppColors.blue,
                                )
                              : const TextStyle(
                                  fontFamily: 'pretendard',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 14 / 10,
                                  color: AppColors.bluelight,
                                )),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 48,
                height: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '답변 도착',
                      style: questionStage == 3
                          ? const TextStyle(
                              fontFamily: 'pretendard',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 14 / 10,
                              color: AppColors.blue,
                            )
                          : AppTextStyles.caption.copyWith(color: AppColors.g3),
                    ),
                    if (questionStage >= 3)
                      Text(
                        '(04.06)',
                        style: questionStage == 3
                            ? const TextStyle(
                                fontFamily: 'pretendard',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                height: 14 / 10,
                                color: AppColors.blue,
                              )
                            : AppTextStyles.caption
                                .copyWith(color: AppColors.g3),
                      ),
                  ],
                ),
              ),
              Gaps.h16,
            ],
          )
        ],
      ),
    );
  }
}
