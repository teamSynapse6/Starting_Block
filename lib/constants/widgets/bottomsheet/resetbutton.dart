import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/widgets/bottomsheet/model/filter_model.dart';

class ResetButton extends StatefulWidget {
  const ResetButton({super.key});

  @override
  State<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
  Future<void> _resetSelections() async {
    // Provider를 사용하여 FilterModel에 접근
    final filterModel = Provider.of<FilterModel>(context, listen: false);

    // SharedPreferences에 필터를 "전체"로 재설정
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSupportType', "전체");
    await prefs.setString('selectedResidence', "전체");
    await prefs.setString('selectedEntrepreneur', "전체");

    // FilterModel의 메서드를 호출하여 모든 필터를 "전체"로 재설정
    filterModel.resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    // Provider를 사용하여 FilterModel의 현재 상태를 구독
    final filterModel = Provider.of<FilterModel>(context);

    // 필터가 모두 "전체"인지 확인하여 리셋 버튼 활성화 여부 결정
    bool resetIsActive = filterModel.selectedSupportType != "전체" ||
        filterModel.selectedResidence != "전체" ||
        filterModel.selectedEntrepreneur != "전체";

    return GestureDetector(
      onTap: resetIsActive ? _resetSelections : null, // 버튼 활성화 상태에 따라 동작 변경
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: resetIsActive ? AppColors.g1 : AppColors.white,
          borderRadius: BorderRadius.circular(46),
          border: Border.all(
              color: resetIsActive ? AppColors.g4 : AppColors.chipsColor,
              width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.h12,
            Text(
              '초기화',
              style: AppTextStyles.btn2.copyWith(
                color: AppColors.g5,
              ),
            ),
            Gaps.h4,
            Image(image: AppImages.re),
            Gaps.h8,
          ],
        ),
      ),
    );
  }
}
