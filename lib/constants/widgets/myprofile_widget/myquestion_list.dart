import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class MyProfileHeartList extends StatelessWidget {
  final String thisOrganization, thisTitle, thisQuestion;
  final int thisCommentCount;
  final VoidCallback thisTap;

  const MyProfileHeartList({
    super.key,
    required this.thisOrganization,
    required this.thisTitle,
    required this.thisQuestion,
    required this.thisCommentCount,
    required this.thisTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: thisTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          width: MediaQuery.of(context).size.width,
          color: AppColors.white,
          child: Column(
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
              Gaps.v12,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppIcon.question,
                  Gaps.h8,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thisQuestion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bd3.copyWith(color: AppColors.g6),
                      ),
                      Gaps.v4,
                      SizedBox(
                        height: 18,
                        child: Row(
                          children: [
                            AppIcon.comments,
                            Gaps.h3,
                            Text(
                              thisCommentCount.toString(),
                              style: AppTextStyles.btn2
                                  .copyWith(color: AppColors.g4),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
