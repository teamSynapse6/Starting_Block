import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

const existing = [
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

class RoadMapAdd extends StatefulWidget {
  const RoadMapAdd({super.key});

  @override
  State<RoadMapAdd> createState() => _RoadMapAddState();
}

class _RoadMapAddState extends State<RoadMapAdd> {
  final TextEditingController _textController = TextEditingController();
  int _currentLength = 0;
  String? _selectedChip;
  bool _isNextButtonEnabled = false;

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
        appBar: const CloseAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v22,
              Text(
                '단계를 추가해 보세요',
                style: AppTextStyles.h5.copyWith(color: AppColors.black),
              ),
              Gaps.v34,
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
                  onTap: _isNextButtonEnabled
                      ? () {
                          final roadmapModel =
                              Provider.of<RoadMapModel>(context, listen: false);
                          String newItem =
                              _selectedChip ?? _textController.text;
                          roadmapModel.addNewItem(newItem);
                          Navigator.pop(
                              context); // 현재 화면을 스택에서 제거하고 이전 화면으로 돌아갑니다.
                        }
                      : null,
                  child: NextContained(
                    text: "다음",
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
