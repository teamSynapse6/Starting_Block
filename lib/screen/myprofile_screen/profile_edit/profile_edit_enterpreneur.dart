import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/save_fetch_userdata.dart';

class EnterprenutEdit extends StatefulWidget {
  const EnterprenutEdit({super.key});

  @override
  State<EnterprenutEdit> createState() => _EnterprenutEditState();
}

class _EnterprenutEditState extends State<EnterprenutEdit> {
  int? selectedCard; // 선택된 카드의 인덱스를 추적

  void _onCardTap(int cardIndex) async {
    setState(() {
      selectedCard = cardIndex;
    });
    await _saveEntrepreneurCheck();
    await Future.delayed(const Duration(milliseconds: 500)).then((_) {
      _onNextTap();
    });
  }

  Future<void> _saveEntrepreneurCheck() async {
    bool isEntrepreneur = selectedCard == 1; // '네' 선택 시 true, '아니오' 선택 시 false
    await SaveUserData.loadFromLocalAndFetchToServer(
        inputEntrepreneurCheck: isEntrepreneur);
  }

  void _onNextTap() async {
    if (selectedCard == null) return;
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
              Gaps.v32,
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
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
                  ),
                  Gaps.h10,
                  Expanded(
                    child: GestureDetector(
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
