import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/offcampus_filter/model/filter_model.dart';

const supporttype = [
  "전체",
  "시설/공간/보육",
  "행사/네트워크",
  "융자/금융",
  "판로/해외진출/수출",
  "인력",
  "경영/사업화/창업",
  "기술 개발(R&D)",
  "기타",
];

class SupportTypeChipsSheet extends StatefulWidget {
  const SupportTypeChipsSheet({super.key});

  @override
  State<SupportTypeChipsSheet> createState() => _SupportTypeChipsSheetState();
}

class _SupportTypeChipsSheetState extends State<SupportTypeChipsSheet> {
  Future<void> _saveSelectedSupportType(String supportType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSupportType', supportType);
  }

  void _onSupportTypeBottom(BuildContext context) async {
    final filterModel = Provider.of<FilterModel>(context, listen: false);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateBottomSheet) {
            return Container(
              height: 400,
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v24,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '지원 분야',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                  ),
                  Gaps.v8,
                  Expanded(
                    child: Scrollbar(
                      thickness: 4,
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: supporttype.length,
                        itemBuilder: (context, index) {
                          String supportType = supporttype[index];
                          return BottomSheetList(
                            thisText: supportType,
                            thisColor:
                                filterModel.selectedSupportType == supportType
                                    ? AppColors.g1
                                    : AppColors.white,
                            thisTapAction: () {
                              setStateBottomSheet(() {
                                filterModel.setSelectedSupportType(supportType);
                              });
                              _saveSelectedSupportType(supportType);
                              Navigator.pop(context); // 바텀 시트 닫기
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Gaps.v24
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedSupportType =
        Provider.of<FilterModel>(context).selectedSupportType;

    return GestureDetector(
      onTap: () => _onSupportTypeBottom(context),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: selectedSupportType == "전체" ? AppColors.g1 : AppColors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.h12,
            Text(
              selectedSupportType == "전체" ? '지원 분야' : selectedSupportType,
              style: AppTextStyles.btn2.copyWith(
                color: selectedSupportType == "전체"
                    ? AppColors.g4
                    : AppColors.white,
              ),
            ),
            Gaps.h4,
            selectedSupportType == "전체" ? AppIcon.down_g3 : AppIcon.down_g1,
            Gaps.h8,
          ],
        ),
      ),
    );
  }
}
