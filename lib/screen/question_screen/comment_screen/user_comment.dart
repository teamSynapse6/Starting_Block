import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/qestion_answer_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class QuestionUserComment extends StatefulWidget {
  final int questionID;
  final void Function(int answerId, String thisUserName)
      thisTap; // Updated type of thisTap

  const QuestionUserComment({
    super.key, // Added key parameter
    required this.questionID,
    required this.thisTap,
  }); // Added super constructor

  @override
  State<QuestionUserComment> createState() => _QuestionUserCommentState();
}

class _QuestionUserCommentState extends State<QuestionUserComment> {
  Future<QuestionDetailModel?>? _questionDetailFuture;
  int? showAllRepliesForAnswerIndex;

  @override
  void initState() {
    super.initState();
    _loadQuestionDetail();
  }

  void _loadQuestionDetail() {
    _questionDetailFuture =
        QuestionAnswerApi.getQuestionDetail(widget.questionID);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FutureBuilder<QuestionDetailModel?>(
        future: _questionDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading question details'));
          } else if (snapshot.hasData) {
            final questionDetail = snapshot.data!;
            final List<AnswerModel> answers = questionDetail.answerList;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v14,
                Text(
                  '타 창업자 도움 ${questionDetail.answerCount.toString()}',
                  style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
                ),
                Gaps.v24,
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: answers.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final answer = answers[index];
                    final shouldShowAllReplies =
                        index == showAllRepliesForAnswerIndex;
                    final repliesToShow = shouldShowAllReplies
                        ? answer.replyResponse
                        : answer.replyResponse.take(3).toList();

                    return Column(
                      children: [
                        CommentList(
                          thisUserName: answer.userName,
                          thisAnswer: answer.content,
                          thisDate: answer.createdAt,
                          thisLike: answer.heartCount,
                          isMyHeart: answer.isMyHeart,
                          thisTap: () {
                            widget.thisTap(
                              answer.answerId,
                              answer.userName,
                            ); // Pass answerId to the callback
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
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
