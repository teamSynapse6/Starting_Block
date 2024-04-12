import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';

class QuestionUserReply extends StatelessWidget {
  final List<ReplyModel> replies; // 댓글 목록을 저장할 변수
  final void Function(int replyId) thisReplyHeartTap;
  final void Function(int replyHeartId) thisReplyHeartDeleteTap;

  const QuestionUserReply({
    super.key,
    required this.replies,
    required this.thisReplyHeartTap,
    required this.thisReplyHeartDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
        padding: const EdgeInsets.fromLTRB(66 - 24, 8, 0, 8),
        itemCount: replies.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final reply = replies[index];
          return ReplyList(
            thisUserName: reply.userName,
            thisDate: reply.createdAt,
            thisAnswer: reply.content,
            thisLike: reply.heartCount,
            isMyHeart: reply.isMyHeart,
            thisReplyHeartTap: () {
              thisReplyHeartTap(reply.replyId);
            },
            thisReplyHeartDeleteTap: () {
              thisReplyHeartDeleteTap(reply.heartId!);
            },
          );
        });
  }
}
