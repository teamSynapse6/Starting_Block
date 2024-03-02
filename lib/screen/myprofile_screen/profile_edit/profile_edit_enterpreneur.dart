// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';

class EnterprenutEdit extends StatefulWidget {
  const EnterprenutEdit({super.key});

  @override
  State<EnterprenutEdit> createState() => _EnterprenutEditState();
}

class _EnterprenutEditState extends State<EnterprenutEdit> {
  int? selectedCard; // 선택된 카드의 인덱스를 추적

  void _onCardTap(int cardIndex) {
    setState(() {
      selectedCard = cardIndex;
    });
  }

  Future<void> _saveEntrepreneurCheck() async {
    // Provider를 사용하여 UserInfo 인스턴스에 접근
    final userInfo = Provider.of<UserInfo>(context, listen: false);

    // UserInfo 인스턴스의 setEntrepreneurCheck 메소드를 호출하여 사업자 등록 여부 저장
    bool isEntrepreneur = selectedCard == 1; // '네' 선택 시 true, '아니오' 선택 시 false
    await userInfo.setEntrepreneurCheck(isEntrepreneur);
  }

  void _onNextTap() async {
    if (selectedCard == null) return; // 카드가 선택되지 않으면 반환
    await _saveEntrepreneurCheck();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v20,
              Text(
                "사업자 등록을 완료하셨나요?",
                style: AppTextStyles.h5.copyWith(color: AppColors.g6),
              ),
              Gaps.v10,
              Text(
                "지원공고 맞춤 추천을 위해 사용됩니다",
                style: AppTextStyles.bd6.copyWith(color: AppColors.g6),
              ),
              Gaps.v36,
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _onCardTap(1),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(
                            color: selectedCard == 1
                                ? AppColors.blue
                                : AppColors.g2,
                            width: selectedCard == 1 ? 3 : 1),
                      ),
                      color: selectedCard == 1
                          ? AppColors.bluebg
                          : AppColors.white,
                      child: SizedBox(
                        width: 148,
                        height: 148,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AppIcon.run_yes,
                            const Text(
                              '네,',
                              style: TextStyle(
                                  fontFamily: 'pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.g6),
                            ),
                            const Text(
                              '완료했습니다',
                              style: TextStyle(
                                  fontFamily: 'pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: AppColors.g6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onCardTap(2),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(
                            color: selectedCard == 2
                                ? AppColors.blue
                                : AppColors.g2,
                            width: selectedCard == 2 ? 3 : 1),
                      ),
                      color: selectedCard == 2
                          ? AppColors.bluebg
                          : AppColors.white,
                      child: SizedBox(
                        width: 148,
                        height: 148,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AppIcon.run_no,
                            const Text(
                              '아니요,',
                              style: TextStyle(
                                  fontFamily: 'pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.g6),
                            ),
                            const Text(
                              '준비중입니다',
                              style: TextStyle(
                                  fontFamily: 'pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: AppColors.g6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: Sizes.size24,
                ),
                child: GestureDetector(
                  onTap: _onNextTap,
                  child: NextContained(
                    text: "저장",
                    disabled: selectedCard == null, // 선택된 카드가 없으면 비활성화
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
