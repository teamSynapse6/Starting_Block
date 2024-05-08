import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeQuestionContactAnswerComplete extends StatelessWidget {
  const HomeQuestionContactAnswerComplete({super.key});

  @override
  Widget build(BuildContext context) {
    Color topColor = const Color(0xff5E8BFF);
    Color bottomColor = const Color(0xffB1C5F6);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            topColor,
            bottomColor,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const BackTitleAppBarForGptList(
          title: '',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v24,
              Text(
                '문의처 답변이\n도착했어요',
                style: AppTextStyles.st1.copyWith(color: AppColors.white),
              ),
              Gaps.v49,
              Container(
                color: AppColors.white,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            '청년 취창업 멘토링 시범운영 개시 및 멘티 모집',
                            style:
                                AppTextStyles.bd3.copyWith(color: AppColors.g6),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Gaps.v8,
                    Text(
                      'ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ\nㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ\nㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ\nㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ\n',
                      style: AppTextStyles.bd4.copyWith(color: AppColors.g5),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppIcon.tail_down_right_24,
                  Gaps.h30,
                ],
              ),
              Gaps.v24,
              Container(
                color: AppColors.white,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  '인당 질의응답 시간이 정해져 있지는 않음ㅇㅇ? ㄱㄴㄲ 조용히 하셈',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gaps.h30,
                  AppIcon.tail_down_left_24,
                ],
              ),
              Gaps.v4,
              Container(
                padding: const EdgeInsets.all(16),
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bluedark,
                ),
                child: AppIcon.contact_logo,
              )
            ],
          ),
        ),
      ),
    );
  }
}
