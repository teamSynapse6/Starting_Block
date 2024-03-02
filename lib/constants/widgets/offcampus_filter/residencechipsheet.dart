import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/offcampus_filter/model/filter_model.dart';

const residence = [
  "전체",
  "서울",
  "부산",
  "대구",
  "인천",
  "경기",
  "강원",
  "충북",
  "충남",
  "전북",
  "광주",
  "대전",
  "울산",
  "세종",
  "전남",
  "경북",
  "경남",
  "제주",
];

class ResidenceChipsSheet extends StatefulWidget {
  const ResidenceChipsSheet({super.key});

  @override
  State<ResidenceChipsSheet> createState() => _ResidenceChipsSheetState();
}

class _ResidenceChipsSheetState extends State<ResidenceChipsSheet> {
  Future<void> _saveSelectedResidence(String thisResidence) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedResidence', thisResidence);
  }

  void _onResidenceBottom(BuildContext context) async {
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
                      '지역',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                  ),
                  Gaps.v8,
                  Expanded(
                    child: Scrollbar(
                      thickness: 4,
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: residence.length,
                        itemBuilder: (context, index) {
                          String thisResidence = residence[index];
                          return BottomSheetList(
                            thisText: thisResidence,
                            thisColor:
                                filterModel.selectedResidence == thisResidence
                                    ? AppColors.g1
                                    : AppColors.white,
                            thisTapAction: () {
                              setStateBottomSheet(() {
                                filterModel.setSelectedResidence(thisResidence);
                              });
                              _saveSelectedResidence(thisResidence);
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
    final selectedResidence =
        Provider.of<FilterModel>(context).selectedResidence;

    return GestureDetector(
      onTap: () => _onResidenceBottom(context),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: selectedResidence == "전체" ? AppColors.g1 : AppColors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.h12,
            Text(
              selectedResidence == "전체" ? '지역' : selectedResidence,
              style: AppTextStyles.btn2.copyWith(
                color:
                    selectedResidence == "전체" ? AppColors.g4 : AppColors.white,
              ),
            ),
            Gaps.h4,
            selectedResidence == "전체" ? AppIcon.down_g3 : AppIcon.down_g1,
            Gaps.h8,
          ],
        ),
      ),
    );
  }
}
