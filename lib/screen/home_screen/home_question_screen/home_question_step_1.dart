import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeQuestionStage1 extends StatelessWidget {
  final String thisTitle, thisContent;

  const HomeQuestionStage1({
    super.key,
    required this.thisTitle,
    required this.thisContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      appBar: const BackAppBarWithBlueBG(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  color: AppColors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '문의처로 질문을 보내기 위해\n준비 중이에요',
                        style:
                            AppTextStyles.st1.copyWith(color: AppColors.white),
                      ),
                      Gaps.v48,
                      Container(
                        width: double.infinity,
                        color: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
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
                                    thisTitle,
                                    style: AppTextStyles.bd3
                                        .copyWith(color: AppColors.g6),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Gaps.v8,
                            Text(
                              thisContent,
                              style: AppTextStyles.bd6
                                  .copyWith(color: AppColors.g5),
                            ),
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
                    ],
                  ),
                ),
                Positioned(
                  bottom: -36,
                  right: 28,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: AppIcon.profile_image_3,
                  ),
                )
              ],
            ),
            Gaps.v36,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '진행 상황',
                    style: AppTextStyles.st2.copyWith(color: AppColors.black),
                  ),
                  Gaps.v32,
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionDetailStepper(questionStage: 1),
                      Gaps.h12,
                      QuestionDetailStepText(questionStage: 1),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
