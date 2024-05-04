import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';

class MyQuestionList extends StatelessWidget {
  final String thisOrganization, thisTitle, questionContent, createdAt;
  final String organizationManger, contactAnswerContent;
  final int heartCount, answerCount;
  final VoidCallback thisTap;

  const MyQuestionList({
    super.key,
    required this.thisOrganization,
    required this.thisTitle,
    required this.questionContent,
    required this.createdAt,
    required this.heartCount,
    required this.answerCount,
    required this.organizationManger,
    required this.contactAnswerContent,
    required this.thisTap,
  });

  @override
  Widget build(BuildContext context) {
    String formatDate(String date) {
      DateTime dateTime = DateTime.parse(date);
      String formattedDate =
          "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
      return formattedDate;
    }

    return GestureDetector(
      onTap: thisTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        width: MediaQuery.of(context).size.width,
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColors.g1,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Row(
                children: [
                  Text(
                    thisOrganization,
                    style: thisOrganization == '교외'
                        ? AppTextStyles.bd6.copyWith(color: AppColors.salmon)
                        : AppTextStyles.bd6.copyWith(color: AppColors.blue),
                  ),
                  Gaps.h12,
                  Expanded(
                    child: Text(
                      thisTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
                    ),
                  )
                ],
              ),
            ),
            Gaps.v16,
            Text(
              questionContent,
              style: AppTextStyles.bd3.copyWith(color: AppColors.g6),
            ),
            Gaps.v8,
            Row(
              children: [
                Text(
                  formatDate(createdAt),
                  style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                ),
                Gaps.h6,
                AppIcon.row_divider,
                Gaps.h6,
                SizedBox(
                  height: 18,
                  child: Row(
                    children: [
                      AppIcon.vote_inactive_18,
                      Gaps.h2,
                      Text(heartCount.toString(),
                          style:
                              AppTextStyles.btn2.copyWith(color: AppColors.g4)),
                    ],
                  ),
                ),
                Gaps.h6,
                AppIcon.row_divider,
                Gaps.h6,
                SizedBox(
                  height: 18,
                  child: Row(
                    children: [
                      AppIcon.comments,
                      Gaps.h2,
                      Text(answerCount.toString(),
                          style:
                              AppTextStyles.btn2.copyWith(color: AppColors.g4)),
                    ],
                  ),
                ),
              ],
            ),
            organizationManger != '' //문의처답변
                ? Column(
                    children: [
                      Gaps.v16,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppIcon.contact_logo_28,
                          Gaps.h4,
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppIcon.my_contact_tail,
                                Expanded(
                                  child: Container(
                                    color: AppColors.bluebg,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          organizationManger,
                                          style: AppTextStyles.bd6
                                              .copyWith(color: AppColors.g5),
                                        ),
                                        Gaps.v6,
                                        Text(
                                          contactAnswerContent,
                                          style: AppTextStyles.bd4
                                              .copyWith(color: AppColors.g6),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
