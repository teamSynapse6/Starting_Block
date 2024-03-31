import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/qestion_answer_api_manage.dart';
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

  @override
  void initState() {
    print('질문 ID: ${widget.questionID}');
    super.initState();
    _loadQuestionDetail();

    _controller.addListener(() {
      if (_controller.text.isNotEmpty && !_isTyped) {
        // TextField에 값이 있고, _isTyped가 false인 경우
        setState(() {
          _isTyped = true; // _isTyped를 true로 설정합니다.
        });
      } else if (_controller.text.isEmpty && _isTyped) {
        // TextField가 비어있고, _isTyped가 true인 경우
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

  // 질문 상세 정보를 로드하는 메서드
  void _loadQuestionDetail() {
    _questionDetailFuture =
        QuestionAnswerApi.getQuestionDetail(widget.questionID);
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
      onTap: () async {
        if (_isTyped && replyingToAnswerId != null) {
          FocusScope.of(context).unfocus(); // 키보드 숨김
          final content = _controller.text;

          try {
            // 답글 작성 API 호출
            await QuestionAnswerApi.postReplyWrite(
                replyingToAnswerId!, content);
            print("답글이 성공적으로 등록되었습니다.");

            // 성공적으로 답글이 작성된 후의 처리
            _controller.clear(); // 입력 필드 초기화
            _loadQuestionDetail();
            setState(() {
              _isTyped = false;
              isReplying = false; // 답글 작성 UI 숨김
            });
          } catch (e) {
            // 답글 작성 중 오류 발생 시 처리
            print("답글 등록 중 오류가 발생했습니다: $e");
          }
        }
      },
      child: _isTyped ? AppIcon.send_actived : AppIcon.send_inactived,
    );
  }

  // 'thisTap' 콜백 내에서 포커스 요청 로직 추가
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const BackAppBar(),
        body: SingleChildScrollView(
          child: FutureBuilder<QuestionDetailModel?>(
              future: _questionDetailFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error loading question details'));
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
                      ),
                      const CustomDividerH8G1(),
                      QuestionUserComment(
                        questionID: widget.questionID,
                        thisTap: (int answerId, String userName) {
                          _handleReplyTap(answerId, userName);
                        },
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('No question details available'));
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
