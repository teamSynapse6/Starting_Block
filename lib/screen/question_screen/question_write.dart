// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/question_answer_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class QuestionWrite extends StatefulWidget {
  final String thisID;

  const QuestionWrite({
    super.key,
    required this.thisID,
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
    // 리스너 추가
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
    showDialog(
      context: context,
      builder: (context) {
        if (_isChecked) {
          // _isChecked가 true일 때의 DialogComponent
          return DialogComponent(
            title: '문의처로 질문이 발송됩니다',
            description:
                '답변을 받기까지 일정 시간이 소요됩니다.\n매너있고 상세한 질문은\n문의처의 빠른 답변으로 이어집니다',
            rightActionText: '발송',
            rightActionTap: sendQuestion, // 여기서 실제 발송 로직을 연결할 수 있습니다.
          );
        } else {
          // _isChecked가 false일 때의 DialogComponent
          return DialogComponent(
            title: '질문 작성 확인',
            description:
                '문의처에 질문하기 전에, 질문 내용을 다시 한번 확인해주세요.\n문의처에 질문하기를 선택하지 않았습니다.',
            rightActionText: '확인',
            rightActionTap: sendQuestion, // 필요한 경우 여기에 확인 액션을 연결할 수 있습니다.
          );
        }
      },
    );
  }

  Future<void> sendQuestion() async {
    try {
      final String userUuid = await UserInfo.getUserUUID();
      final String userNickName = await UserInfo.getNickName();
      final String questionText = _textController.text;
      final bool forContact = _isChecked;
      final int profileNum = await UserInfo.getSelectedIconIndex();

      // QuestionAnswerApi의 writeQuestion 메소드를 호출하여 질문 데이터 전송
      final String qid = await QuestionAnswerApi.writeQuestion(
        questionId: widget.thisID,
        questionText: questionText,
        forContact: forContact,
        userUuid: userUuid,
        userName: userNickName,
        profileNum: profileNum,
      );

      // 성공적으로 질문이 전송되었을 때의 처리, 예를 들어 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('질문이 성공적으로 등록되었습니다. QID: $qid')),
      );
      // QuestionDetail 화면으로 이동
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionDetail(qid: qid),
          ));
    } catch (e) {
      // 오류 발생 시 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('질문 등록에 실패했습니다. 오류: $e')),
      );
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
              Text(
                '질문하기',
                style: AppTextStyles.h5.copyWith(color: AppColors.g6),
              ),
              Gaps.v20,
              SizedBox(
                height: 300,
                child: TextFormField(
                  controller: _textController,
                  maxLength: 160, // 최대 글자 수를 400으로 설정합니다.
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

                  decoration: const InputDecoration(
                    hintText: '여기에 질문을 작성하세요.',
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                ),
              ),
              const Spacer(),
              Text(
                "문의처 이메일이 제공된 공고글에 한해,\n'문의처에 질문하기' 기능이 제공됩니다.\n주말(공휴일) 제외 오전 9시에 문의처에 메일이\n발송됩니다.",
                style: AppTextStyles.bd2.copyWith(color: AppColors.g4),
              ),
              Gaps.v52,
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: BottomAppBar(
            height: 44,
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
                        style: AppTextStyles.bd2.copyWith(color: AppColors.g5),
                      )
                    ],
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
