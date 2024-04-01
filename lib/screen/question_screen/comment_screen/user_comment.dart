import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class QuestionUserComment extends StatefulWidget {
  final void Function(int answerId, String thisUserName) thisTap;
  final List<AnswerModel> answers; // Modify the type of answers to direct list

  const QuestionUserComment({
    super.key,
    required this.thisTap,
    required this.answers,
  });

  @override
  State<QuestionUserComment> createState() => _QuestionUserCommentState();
}

class _QuestionUserCommentState extends State<QuestionUserComment> {
  int? showAllRepliesForAnswerIndex;

  @override
  Widget build(BuildContext context) {
    // 직접 전달받은 answers 리스트를 사용하여 UI 구성
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: widget.answers.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v14,
                Text(
                  '타 창업자 도움 ${widget.answers.length.toString()}', // Use the length of answers
                  style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
                ),
                Gaps.v24,
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.answers.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final answer = widget.answers[index];
                    final shouldShowAllReplies =
                        index == showAllRepliesForAnswerIndex;
                    final repliesToShow = shouldShowAllReplies
                        ? answer.replyResponse
                        : answer.replyResponse.take(3).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommentList(
                          thisUserName: answer.userName,
                          thisAnswer: answer.content,
                          thisDate: answer.createdAt,
                          thisLike: answer.heartCount,
                          isMyHeart: answer.isMyHeart,
                          thisAnswerId: answer.answerId,
                          thisCommentTap: () {
                            widget.thisTap(answer.answerId, answer.userName);
                          },
                        ),
                        if (answer.replyResponse.isNotEmpty &&
                            answer.replyResponse.length > 3)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                66 - 24, 8 + 16, 0, 8),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showAllRepliesForAnswerIndex =
                                      shouldShowAllReplies ? null : index;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    shouldShowAllReplies
                                        ? '답글 숨기기'
                                        : '이전 답글 ${answer.replyResponse.length - 3}개 더보기',
                                    style: AppTextStyles.bd6
                                        .copyWith(color: AppColors.g5),
                                  ),
                                  Gaps.h4,
                                  shouldShowAllReplies
                                      ? AppIcon.arrow_up_16
                                      : AppIcon.arrow_down_16
                                ],
                              ),
                            ),
                          ),
                        QuestionUserReply(replies: repliesToShow),
                      ],
                    );
                  },
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v14,
                Text(
                  '타 창업자 도움 ${widget.answers.length.toString()}', // Use the length of answers
                  style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
                ),
                Gaps.v40,
                Center(
                  child: Text(
                    '아직 댓글이 없어요',
                    style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
                  ),
                ),
                Center(
                  child: Text(
                    '가장 먼저 도움을 전해보세요',
                    style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
                  ),
                ),
              ],
            ),
    );
  }
}
