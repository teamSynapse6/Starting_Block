// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class EnterprenutScreen extends StatefulWidget {
  const EnterprenutScreen({super.key});

  @override
  State<EnterprenutScreen> createState() => _EnterprenutScreenState();
}

class _EnterprenutScreenState extends State<EnterprenutScreen> {
  int? selectedCard; // 선택된 카드의 인덱스를 추적

  void _onCardTap(int cardIndex) {
    setState(() {
      selectedCard = cardIndex;
    });
  }

  Future<void> _saveEntrepreneurCheck() async {
    final prefs = await SharedPreferences.getInstance();
    bool isEntrepreneur = selectedCard == 1; // '네' 선택 시 true, '아니오' 선택 시 false
    await prefs.setBool('enterpreneurCheck', isEntrepreneur);
  }

  void _onNextTap() async {
    if (selectedCard == null) return; // 카드가 선택되지 않으면 반환

    // 선택된 값을 SharedPreferences에 저장
    await _saveEntrepreneurCheck();

    // 다음 화면으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ResidenceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image(image: AppImages.back),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v12,
              const Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.blue,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                ],
              ),
              Gaps.v32,
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
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: AppColors.g2, width: 1)),
                      color: selectedCard == 1
                          ? AppColors.g2
                          : AppColors.white, // 선택 상태에 따라 색상 변경
                      child: SizedBox(
                        width: 148,
                        height: 148,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/onboard_image/run_yes.png',
                                width: 80, height: 80),
                            const Text(
                              '네,',
                              style: TextStyle(
                                  fontFamily: 'pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.g6),
                            ),
                            const Text(
                              '완료했습니다,',
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: AppColors.g2, width: 1),
                      ),
                      color: selectedCard == 2
                          ? AppColors.g2
                          : AppColors.white, // 선택 상태에 따라 색상 변경
                      child: SizedBox(
                        width: 148,
                        height: 148,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/onboard_image/run_no.png',
                                width: 80, height: 80),
                            const Text(
                              '아니요,',
                              style: TextStyle(
                                  fontFamily: 'pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.g6),
                            ),
                            const Text(
                              '준비중입니다,',
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
                    text: "다음",
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
