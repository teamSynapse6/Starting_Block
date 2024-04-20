import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/models/myprofile_models/my_answer_reply_model.dart';

class MyAnswerList extends StatelessWidget {
  final String thisOrganization, thisTitle, questionWriterName, questionContent;
  final MyAnswer? myAnswer;
  final MyReply? myReply;

  const MyAnswerList({
    super.key,
    required this.thisOrganization,
    required this.thisTitle,
    required this.questionWriterName,
    required this.questionContent,
    required this.myAnswer,
    required this.myReply,
  });

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    String myAnswerDate =
        myAnswer != null ? formatDate(myAnswer!.createdAt) : '';
    // int answerWriterProfile =
    //     widget.myReply != null ? widget.myReply!.answerWriterProfile : 0;
    String answerWriterName = myReply != null ? myReply!.answerWriterName : '';
    String answerContent = myReply != null ? myReply!.answerContent : '';
    List<ReplyDetail> replyList = myReply != null ? myReply!.replyList : [];

    return myAnswer != null
        ? Container(
            padding: const EdgeInsets.all(24),
            color: AppColors.white,
            width: MediaQuery.of(context).size.width,
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
                            ? AppTextStyles.bd6
                                .copyWith(color: AppColors.salmon)
                            : AppTextStyles.bd6.copyWith(color: AppColors.blue),
                      ),
                      Gaps.h12,
                      Expanded(
                        child: Text(
                          thisTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppTextStyles.bd6.copyWith(color: AppColors.g5),
                        ),
                      )
                    ],
                  ),
                ),
                Gaps.v16,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.g1,
                    ),
                    Gaps.h8,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questionWriterName,
                          style:
                              AppTextStyles.bd5.copyWith(color: AppColors.g6),
                        ),
                        Gaps.v4,
                        Text(
                          questionContent,
                          style:
                              AppTextStyles.bd4.copyWith(color: AppColors.g6),
                        ),
                      ],
                    )
                  ],
                ),
                Gaps.v16,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        color: AppColors.g1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myAnswer?.answerContent ?? '',
                              style: AppTextStyles.bd3
                                  .copyWith(color: AppColors.g6),
                            ),
                            Gaps.v8,
                            Row(
                              children: [
                                Text(
                                  myAnswerDate,
                                  style: AppTextStyles.bd6
                                      .copyWith(color: AppColors.g4),
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
                                      Text(myAnswer!.heartCount.toString(),
                                          style: AppTextStyles.btn2
                                              .copyWith(color: AppColors.g4)),
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
                                      Text(myAnswer!.replyCount.toString(),
                                          style: AppTextStyles.btn2
                                              .copyWith(color: AppColors.g4)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    AppIcon.my_answer_tail,
                  ],
                )
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.all(24),
            color: AppColors.white,
            width: MediaQuery.of(context).size.width,
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
                            ? AppTextStyles.bd6
                                .copyWith(color: AppColors.salmon)
                            : AppTextStyles.bd6.copyWith(color: AppColors.blue),
                      ),
                      Gaps.h12,
                      Expanded(
                        child: Text(
                          thisTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppTextStyles.bd6.copyWith(color: AppColors.g5),
                        ),
                      )
                    ],
                  ),
                ),
                Gaps.v16,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.g1,
                    ),
                    Gaps.h8,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questionWriterName,
                          style:
                              AppTextStyles.bd6.copyWith(color: AppColors.g6),
                        ),
                        Gaps.v4,
                        Text(
                          questionContent,
                          style:
                              AppTextStyles.bd4.copyWith(color: AppColors.g6),
                        ),
                      ],
                    )
                  ],
                ),
                Gaps.v12,
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.g1,
                      ),
                      Gaps.h4,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  answerWriterName,
                                  style: AppTextStyles.bd6
                                      .copyWith(color: AppColors.g6),
                                ),
                                Gaps.v4,
                                Text(
                                  answerContent,
                                  style: AppTextStyles.bd4
                                      .copyWith(color: AppColors.g6),
                                ),
                              ],
                            ),
                          ),
                          Gaps.v16,
                        ],
                      )
                    ],
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.only(left: 32),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: replyList.length,
                  itemBuilder: (context, index) {
                    final reply = replyList[index];
                    return Column(
                      children: [
                        reply.mine
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 10, 8, 10),
                                      color: AppColors.g1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(reply.replyContent,
                                              style: AppTextStyles.bd3.copyWith(
                                                  color: AppColors.g6)),
                                          Gaps.v8,
                                          Row(
                                            children: [
                                              Text(formatDate(reply.createdAt),
                                                  style: AppTextStyles.bd6
                                                      .copyWith(
                                                          color: AppColors.g4)),
                                              Gaps.h6,
                                              AppIcon.row_divider,
                                              Gaps.h6,
                                              SizedBox(
                                                height: 18,
                                                child: Row(
                                                  children: [
                                                    AppIcon.vote_inactive_18,
                                                    Gaps.h2,
                                                    Text(
                                                        reply.heartCount
                                                            .toString(),
                                                        style: AppTextStyles
                                                            .btn2
                                                            .copyWith(
                                                                color: AppColors
                                                                    .g4)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  AppIcon.my_answer_tail,
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.g1,
                                  ),
                                  Gaps.h8,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reply.replyWriterName,
                                        style: AppTextStyles.bd6
                                            .copyWith(color: AppColors.g6),
                                      ),
                                      Gaps.v4,
                                      Text(
                                        reply.replyContent,
                                        style: AppTextStyles.bd4
                                            .copyWith(color: AppColors.g6),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                        if (index != replyList.length - 1) Gaps.v16,
                      ],
                    );
                  },
                ),
              ],
            ),
          );
  }
}
