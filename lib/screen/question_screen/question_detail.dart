import 'dart:async'; // 추가된 임포트
import 'package:flutter/material.dart';
import 'package:korean_profanity_filter/korean_profanity_filter.dart'; // 비속어 필터링 패키지 추가
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/question_answer_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class QuestionDetail extends StatefulWidget {
  final int questionID;

  const QuestionDetail({
    super.key,
    required this.questionID,
  });

  @override
  State<QuestionDetail> createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  Future<QuestionDetailModel?>? _questionDetailFuture;
  int? replyingToAnswerId; // 답글 대상 답변의 ID
  final FocusNode _replyFocusNode = FocusNode(); // 답글 작성을 위한 FocusNode 추가

  final TextEditingController _controller = TextEditingController();
  bool _isTyped = false;
  String? replyingToUserName; // 답글 대상 사용자 이름
  bool isReplying = false; // 답글 작성 UI 표시 여부
  bool isHeartLoading = false;
  String userNickName = ''; // 유저 닉네임으로 내 글인지 아닌지 판단
  bool hasKoreanProfanity = false; // 비속어 포함 여부

  @override
  void initState() {
    super.initState();
    _loadQuestionDetail();
    _loadUserNickName();

    _controller.addListener(() {
      final currentText = _controller.text;
      hasKoreanProfanity = currentText.containsBadWords;
      if (currentText.isNotEmpty && !_isTyped && !hasKoreanProfanity) {
        setState(() {
          _isTyped = true; // _isTyped를 true로 설정합니다.
        });
      } else if (currentText.isEmpty || hasKoreanProfanity) {
        setState(() {
          _isTyped = false; // _isTyped를 false로 설정합니다.
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // 리소스를 정리합니다.
    super.dispose();
  }

  // 유저 닉네임 로드 메소드
  void _loadUserNickName() async {
    final user = await UserInfo.getNickName();
    setState(() {
      userNickName = user;
    });
  }

  // 질문 상세 정보를 로드하는 메서드
  void _loadQuestionDetail() {
    Future<QuestionDetailModel> questionDetailFuture =
        QuestionAnswerApi.getQuestionDetail(widget.questionID); // 여기 임시 데이터
    setState(() {
      _questionDetailFuture = questionDetailFuture;
    });
  }

  Widget _sendMessageButton() {
    return GestureDetector(
      onTap: () async {
        // 비동기 처리를 위해 async 추가
        if (_isTyped) {
          FocusScope.of(context).unfocus();
          // 입력된 텍스트가 있는 경우에만 요청 실행
          final content = _controller.text;
          final questionId = widget.questionID;
          const isContact = false; // isContact는 false로 설정

          await QuestionAnswerApi.postAnswerWrite(
              questionId, content, isContact);
          _loadQuestionDetail();

          setState(() {
            _controller.clear();
            _isTyped = false;
          });
        }
      },
      child: _isTyped ? AppIcon.send_actived : AppIcon.send_inactived,
    );
  }

  Widget _sendReplyButton() {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          if (_isTyped && replyingToAnswerId != null) {
            FocusScope.of(context).unfocus(); // 키보드 숨김
            final content = _controller.text;

            try {
              // 답글 작성 API 호출
              await QuestionAnswerApi.postReplyWrite(
                  replyingToAnswerId!, content);

              // 성공적으로 답글이 작성된 후의 처리
              _controller.clear(); // 입력 필드 초기화
              _loadQuestionDetail();
              setState(() {
                _isTyped = false;
                isReplying = false; // 답글 작성 UI 숨김
              });
            } catch (e) {
              // 답글 작성 중 오류 발생 시 처리
            }
          }
        },
        child: SizedBox(
          width: 24,
          height: 24,
          child: _isTyped && !hasKoreanProfanity
              ? AppIcon.send_actived
              : AppIcon.send_inactived,
        ));
  }

  // 답글(대댓글 작성 메소드)
  void _handleReplyTap(int answerId, String userName) {
    setState(() {
      replyingToUserName = userName;
      replyingToAnswerId = answerId;
      isReplying = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_replyFocusNode);
    });
  }

  // 질문에 대한 궁금해요 전송 메소드
  void postHeartForQuestion() async {
    if (isHeartLoading) return;

    setState(() {
      isHeartLoading = true;
    });

    bool success =
        await QuestionAnswerApi.postHeart(widget.questionID, 'QUESTION');
    if (success) {
      _loadQuestionDetail();
    }

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      isHeartLoading = false;
    });
  }

  // 질문에 대한 하트 취소 메소드
  void deleteHeartForQuestion() async {
    if (isHeartLoading) return;

    setState(() {
      isHeartLoading = true;
    });

    final questionDetail = await _questionDetailFuture;
    if (questionDetail?.heartId != null) {
      bool success =
          await QuestionAnswerApi.deleteHeart(questionDetail!.heartId);
      if (success) {
        _loadQuestionDetail();
      }
    } else {}

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      isHeartLoading = false;
    });
  }

  // 댓글에 대한 도움 하트 메소드
  void postHeartForAnswer(int answerId) async {
    if (isHeartLoading) return;

    setState(() {
      isHeartLoading = true;
    });

    bool success = await QuestionAnswerApi.postHeart(answerId, 'ANSWER');
    if (success) {
      _loadQuestionDetail();
    }

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      isHeartLoading = false;
    });
  }

  // 댓글에 대한 도움 하트 취소 메소드
  void deleteHeartForAnswer(int heartId) async {
    if (isHeartLoading) return;

    setState(() {
      isHeartLoading = true;
    });

    bool success = await QuestionAnswerApi.deleteHeart(heartId);
    if (success) {
      _loadQuestionDetail();
    }

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      isHeartLoading = false;
    });
  }

  // 답글(대댓글)에 대한 도움 하트 메소드
  void postHeartForReply(int replyId) async {
    if (isHeartLoading) return;

    setState(() {
      isHeartLoading = true;
    });

    bool success = await QuestionAnswerApi.postHeart(replyId, 'REPLY');
    if (success) {
      _loadQuestionDetail();
    }

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      isHeartLoading = false;
    });
  }

  // 답글(대댓글)에 대한 도움 하트 취소 메소드
  void deleteHeartForReply(int replyHeartId) async {
    if (isHeartLoading) return;

    setState(() {
      isHeartLoading = true;
    });

    bool success = await QuestionAnswerApi.deleteHeart(replyHeartId);
    if (success) {
      _loadQuestionDetail();
    }

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      isHeartLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const BackAppBar(
          state: true,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<QuestionDetailModel?>(
              future: _questionDetailFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text("질문의 '나도 궁금해요' 기능에서 오류가 발생했습니다."));
                } else if (snapshot.hasData) {
                  final questionDetail = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionDetailInfo(
                        thisUserName: questionDetail.userName,
                        thisQuestion: questionDetail.content,
                        thisDate: questionDetail.createdAt,
                        thisLike: questionDetail.heartCount,
                        isMyHeart: questionDetail.isMyHeart,
                        thisQuestionLikeTap: postHeartForQuestion,
                        thisQuestionLikeCancelTap: deleteHeartForQuestion,
                        thisQuestionHeardID: questionDetail.heartId,
                        myNickName: userNickName,
                        thisProfileNumber: questionDetail.profileNumber,
                      ),
                      const CustomDividerH8G1(),
                      QuestionContactComment(
                          contactAnswer: questionDetail.contactAnswer),
                      QuestionUserComment(
                        thisReplyTap: (int answerId, String userName) {
                          _handleReplyTap(answerId, userName);
                        },
                        answers: questionDetail.answerList,
                        thisCommentHeartTap: (int answerId) {
                          postHeartForAnswer(answerId);
                        },
                        thisCommenHeartDeleteTap: (int heartId) {
                          deleteHeartForAnswer(heartId);
                        },
                        thisReplyHeartTap: (int replyId) {
                          postHeartForReply(replyId);
                        },
                        thisReplyHeartDeleteTap: (int replyHeartId) {
                          deleteHeartForReply(replyHeartId);
                        },
                        thisAnswerDeleteTap: () {
                          _loadQuestionDetail();
                        },
                        thisReplyDeleteTap: () {
                          _loadQuestionDetail();
                        },
                        myNickName: userNickName,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ),
        bottomNavigationBar: isReplying
            ? Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: BottomAppBar(
                  height: 52 + 42,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        height: 42,
                        color: Colors.grey[200],
                        child: Row(
                          children: [
                            Text(
                              '$replyingToUserName에게 답글 남기는 중',
                              style: AppTextStyles.bd2
                                  .copyWith(color: AppColors.g4),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isReplying = false;
                                  replyingToAnswerId = null;
                                  replyingToUserName = null;
                                });
                              },
                              child: AppIcon.close,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 32,
                              width: MediaQuery.of(context).size.width *
                                  (280 / 360),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.5,
                                  color: AppColors.g2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                focusNode: _replyFocusNode,
                                controller: _controller,
                                cursorColor: AppColors.g6,
                                minLines: 1,
                                maxLines: null,
                                style: AppTextStyles.bd2
                                    .copyWith(color: AppColors.g6),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    bottom: 9,
                                    top: -9,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            Gaps.h8,
                            _sendReplyButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: BottomAppBar(
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 32,
                          width:
                              MediaQuery.of(context).size.width * (280 / 360),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: AppColors.g2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _controller,
                            cursorColor: AppColors.g6,
                            minLines: 1,
                            maxLines: null,
                            style:
                                AppTextStyles.bd2.copyWith(color: AppColors.g6),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                bottom: 9,
                                top: -9,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Gaps.h8,
                        _sendMessageButton(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
