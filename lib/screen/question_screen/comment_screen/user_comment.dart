import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class QuestionUserComment extends StatefulWidget {
  final void Function(int answerId, String thisUserName) thisReplyTap;
  final void Function(int answerId) thisCommentHeartTap;
  final void Function(int heartId) thisCommenHeartDeleteTap;
  final void Function(int replyId) thisReplyHeartTap;
  final void Function(int replyHeartId) thisReplyHeartDeleteTap;
  final List<AnswerModel> answers;
  final VoidCallback thisAnswerDeleteTap, thisReplyDeleteTap;
  final String myNickName;

  const QuestionUserComment({
    super.key,
    required this.thisReplyTap,
    required this.answers,
    required this.thisCommentHeartTap,
    required this.thisCommenHeartDeleteTap,
    required this.thisReplyHeartTap,
    required this.thisReplyHeartDeleteTap,
    required this.thisAnswerDeleteTap,
    required this.thisReplyDeleteTap,
    required this.myNickName,
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
                          thisProfileNumber: answer.profileNumber,
                          thisAnswer: answer.content,
                          thisDate: answer.createdAt,
                          thisLike: answer.heartCount,
                          isMyHeart: answer.isMyHeart,
                          thisAnswerId: answer.answerId,
                          isMyAnswer: answer.isMyAnswer,
                          thisReplyTap: () {
                            widget.thisReplyTap(
                                answer.answerId, answer.userName);
                          },
                          thisCommentHeartTap: () {
                            widget.thisCommentHeartTap(answer.answerId);
                          },
                          thisCommenHeartDeleteTap: () {
                            widget.thisCommenHeartDeleteTap(answer.heartId!);
                          },
                          thisAnswerDeleteTap: widget.thisAnswerDeleteTap,
                          myNickName: widget.myNickName,
                        ),
                        if (answer.replyResponse.isNotEmpty &&
                            answer.replyResponse.length > 3)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showAllRepliesForAnswerIndex =
                                    shouldShowAllReplies ? null : index;
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(66 - 24, 9, 0, 9),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    height: 1,
                                    width: 24,
                                    color: AppColors.g2,
                                  ),
                                  Gaps.h8,
                                  Text(
                                    shouldShowAllReplies
                                        ? '답글 숨기기'
                                        : '이전 답글 ${answer.replyResponse.length - 3}개 더보기',
                                    style: AppTextStyles.bd6
                                        .copyWith(color: AppColors.g5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        QuestionUserReply(
                          replies: repliesToShow,
                          thisReplyHeartTap: (int replyId) {
                            widget.thisReplyHeartTap(replyId);
                          },
                          thisReplyHeartDeleteTap: (int replyHeartId) {
                            widget.thisReplyHeartDeleteTap(replyHeartId);
                          },
                          thisReplyDeleteTap: widget.thisReplyDeleteTap,
                          myNickName: widget.myNickName,
                        ),
                        if (index < widget.answers.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: CustomDividerH1G1(),
                          )
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
