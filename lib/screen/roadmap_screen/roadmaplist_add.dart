import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

const List<String> existing = globalDataRoadmapList;

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

  void _onCompleteTap() {
    if (_isNextButtonEnabled) {
      String valueToAdd = _selectedChip ?? _textController.text;
      RoadMapApi.addRoadMap(valueToAdd).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('추가하는 데 실패했습니다: $error')),
        );
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
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.g6,
                ),
              ),
              Gaps.v40,
              TextField(
                controller: _textController,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: '원하는 단계명을 추가해 주세요',
                  hintStyle: AppTextStyles.bd2.copyWith(color: AppColors.g2),
                  counterText: '', // 기본 카운터 숨김
                ),
              ),
              Gaps.v4,
              Row(
                children: [
                  const Spacer(),
                  Text(
                    '$_currentLength',
                    style: _currentLength == 0
                        ? AppTextStyles.caption.copyWith(color: AppColors.g3)
                        : AppTextStyles.caption.copyWith(color: AppColors.blue),
                  ),
                  Text(
                    '/20',
                    style: _currentLength == 0
                        ? AppTextStyles.caption.copyWith(color: AppColors.g3)
                        : AppTextStyles.caption.copyWith(color: AppColors.g5),
                  ),
                ],
              ),
              Gaps.v52,
              Text(
                '추천 사업이 제공되는 단계로 추가해 볼까요?',
                style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
              ),
              Gaps.v20,
              Wrap(
                runSpacing: 14,
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
