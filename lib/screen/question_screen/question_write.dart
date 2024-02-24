import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionWrite extends StatefulWidget {
  const QuestionWrite({super.key});

  @override
  State<QuestionWrite> createState() => _QuestionWriteState();
}

class _QuestionWriteState extends State<QuestionWrite> {
  final TextEditingController _textController = TextEditingController();
  bool _isChecked = false;

  @override
  void dispose() {
    // 위젯이 제거될 때 컨트롤러를 정리합니다.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BackTitleAppBar(
          text: '작성하기',
          thisTextStyle: AppTextStyles.btn1.copyWith(color: AppColors.g4),
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
