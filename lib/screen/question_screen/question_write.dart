// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/question_answer_api_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class QuestionWrite extends StatefulWidget {
  final String thisID;
  final bool isContactExist;

  const QuestionWrite({
    super.key,
    required this.thisID,
    required this.isContactExist,
  });

  @override
  State<QuestionWrite> createState() => _QuestionWriteState();
}

class _QuestionWriteState extends State<QuestionWrite> {
  final TextEditingController _textController = TextEditingController();
  bool _isChecked = false;
  bool _isTextEntered = false; // 텍스트 입력 여부를 추적하는 플래그

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      setState(() {
        // 텍스트 필드에 텍스트가 있으면 true, 아니면 false
        _isTextEntered = _textController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // 위젯이 제거될 때 컨트롤러를 정리합니다.
    _textController.dispose();
    super.dispose();
  }

  void _thisWriteTap() {
    if (!_isTextEntered) return;
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: (context) {
        if (_isChecked) {
          // _isChecked가 true일 때의 DialogComponent
          return DialogComponent(
            title: '문의처로 질문이 발송됩니다',
            description:
                '답변을 받기까지 일정 시간이 소요됩니다.\n매너있고 상세한 질문은\n문의처의 빠른 답변으로 이어집니다.',
            rightActionText: '발송',
            rightActionTap: _postQuestion, // 여기서 실제 발송 로직을 연결할 수 있습니다.
          );
        } else {
          // _isChecked가 false일 때의 DialogComponent
          return DialogComponent(
            title: '질문 작성 확인',
            description:
                '문의처에 질문하기 전에, 질문 내용을 다시 한번 확인해주세요.\n문의처에 질문하기를 선택하지 않았습니다.',
            rightActionText: '확인',
            rightActionTap: _postQuestion,
          );
        }
      },
    );
  }

  void _postQuestion() async {
    // API 호출을 통해 질문 게시
    await QuestionAnswerApi.postQuestionWrite(
      int.tryParse(widget.thisID) ?? 0, // thisID를 int로 변환, 실패 시 0 사용
      _textController.text,
      _isChecked,
    );

    // 질문이 성공적으로 게시된 후에는 화면을 닫거나 사용자에게 알림을 표시할 수 있습니다.
    if (mounted) {
      Navigator.of(context).pop();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const QuestionWriteComplete()));
    }
    if (mounted) {
      Navigator.of(context).pop(true); // 작성화면 닫기
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BackTitleAppBar(
          thisOnTap: _thisWriteTap,
          text: '작성하기',
          thisTextStyle: _isTextEntered
              ? AppTextStyles.btn1.copyWith(color: AppColors.blue)
              : AppTextStyles.btn1.copyWith(color: AppColors.g4),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v20,
              Container(
                width: MediaQuery.of(context).size.width,
                color: AppColors.g1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: RichText(
                    text: TextSpan(
                      // 기본 스타일을 정의합니다. 모든 TextSpan에 공통적으로 적용됩니다.
                      style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                      children: <TextSpan>[
                        const TextSpan(
                            text: '글 작성 시 다른 창업자들이 작성한 답변을 유지하기 위해,\n'),
                        TextSpan(
                            text: '글을 수정 및 삭제할 수 없습니다.',
                            style: AppTextStyles.bd5
                                .copyWith(color: AppColors.g4)),
                      ],
                    ),
                  ),
                ),
              ),
              Gaps.v20,
              TextFormField(
                controller: _textController,
                maxLength: 160, // 최대 글자 수를 160으로 설정합니다.
                maxLines: null, // 무제한 줄 입력을 허용합니다. (자동으로 높이가 조정됩니다)
                keyboardType: TextInputType.multiline,
                buildCounter: (BuildContext context,
                    {int? currentLength, bool? isFocused, int? maxLength}) {
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '$currentLength', // 현재 글자수
                            style: AppTextStyles.bd6
                                .copyWith(color: AppColors.g5)),
                        TextSpan(
                            text: ' /$maxLength', // 최대 글자수
                            style: AppTextStyles.bd6
                                .copyWith(color: AppColors.g4)),
                      ],
                    ),
                  );
                },

                decoration: InputDecoration(
                  hintText: '질문을 작성해 주세요',
                  hintStyle: AppTextStyles.bd2.copyWith(color: AppColors.g3),
                  enabledBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                ),
                style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
              ),
              const Spacer(),
              Text(
                "문의처 이메일이 안내된 공고에 대해 질문할 수 있어요.\n메일은 '평일 오전 9시'에 발송돼요.",
                style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
              ),
              Gaps.v24,
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: BottomAppBar(
            height: 44,
            child: IgnorePointer(
              ignoring: !widget.isContactExist,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
                child: Container(
                  height: 44,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    border: BorderDirectional(
                      top: BorderSide(width: 1, color: AppColors.g2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _isChecked
                            ? AppIcon.checkbox_actived
                            : AppIcon.checkbox_inactived,
                        Gaps.h10,
                        Text(
                          '문의처에 질문하기',
                          style:
                              AppTextStyles.bd2.copyWith(color: AppColors.g5),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
