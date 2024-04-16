import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';

class RoadmapScreenAdd extends StatefulWidget {
  const RoadmapScreenAdd({super.key});

  @override
  State<RoadmapScreenAdd> createState() => _RoadmapScreenAddState();
}

class _RoadmapScreenAddState extends State<RoadmapScreenAdd> {
  final TextEditingController _textController = TextEditingController();
  int _currentLength = 0;
  String? _selectedChip;
  bool _isNextButtonEnabled = false;
  final existing = [
    "창업 교육",
    "아이디어 창출",
    "공간 마련",
    "사업계획서",
    "R&D / 시제품 제작",
    "사업 검증",
    "IR Deck 작성",
    "자금 확보",
    "사업화",
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _currentLength = _textController.text.length;
        _selectedChip = null; // 텍스트 필드에 입력 시 모든 칩 선택 해제
        _isNextButtonEnabled = _currentLength > 0;
      });
    });
  }

  void _onChipTap(String chipName) {
    setState(() {
      if (_selectedChip != chipName) {
        _textController.clear(); // 칩 선택 시 텍스트 필드 비우기
        _selectedChip = chipName;
        _isNextButtonEnabled = true;
      }
    });
  }

  void _onCompleteTap() {
    if (_isNextButtonEnabled) {
      String valueToAdd = _selectedChip ?? _textController.text;

      // UserInfo 인스턴스를 Provider를 통해 가져옵니다.
      final userInfo = Provider.of<UserInfo>(context, listen: false);

      // SharedPreferences에 새로운 roadmap item을 추가합니다.
      UserInfo.getTempInitialRoadmapItems().then((List<String> currentItems) {
        // 현재 저장된 아이템 리스트에 새 아이템을 추가합니다.
        currentItems.add(valueToAdd);

        // 변경된 아이템 리스트를 다시 저장합니다.
        userInfo.setTempInitialRoadmapItems(currentItems).then((_) {
          // 저장 후에 화면을 닫거나 다른 처리를 할 수 있습니다.
          Navigator.pop(context);
        }).catchError((error) {
          // 오류 처리
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('추가하는 데 실패했습니다: $error')),
          );
        });
      });
    }
  }

  @override
  void dispose() {
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
        appBar: const CloseAppBar(
          state: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v20,
              Text(
                '단계를 추가해 보세요',
                style: AppTextStyles.h5.copyWith(color: AppColors.black),
              ),
              Gaps.v10,
              Text(
                '기존 단계 선택이 아닌 직접 추가 시, 추천 지원사업은 제외됩니다',
                style: AppTextStyles.bd6.copyWith(color: AppColors.g6),
              ),
              Gaps.v24,
              TextField(
                controller: _textController,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: '원하는 단계명을 추가해 주세요',
                  hintStyle: AppTextStyles.bd2.copyWith(color: AppColors.g4),
                  counterText: '', // 기본 카운터 숨김
                ),
              ),
              Gaps.v4,
              Row(
                children: [
                  const Spacer(),
                  Text(
                    '$_currentLength',
                    style:
                        AppTextStyles.caption.copyWith(color: AppColors.blue),
                  ),
                  Text(
                    '/20',
                    style: AppTextStyles.caption.copyWith(color: AppColors.g5),
                  ),
                ],
              ),
              Gaps.v32,
              Text(
                '기존 단계로 추가하시고 싶으신가요',
                style: AppTextStyles.bd4.copyWith(color: AppColors.g5),
              ),
              Gaps.v20,
              Wrap(
                runSpacing: 16,
                spacing: 16,
                children: [
                  for (var list in existing)
                    DefaultInputChip(
                      text: list,
                      chipTap: () => _onChipTap(list),
                      isSelected: _selectedChip == list,
                    ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: Sizes.size24),
                child: GestureDetector(
                  onTap: _onCompleteTap,
                  child: NextContained(
                    text: "완료하기",
                    disabled: !_isNextButtonEnabled,
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
