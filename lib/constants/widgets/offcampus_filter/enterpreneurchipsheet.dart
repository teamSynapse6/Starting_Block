import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/offcampus_filter/model/filter_model.dart';

const enterpreneur = [
  "전체",
  "예비창업자",
  "1년미만",
  "2년미만",
  "3년미만",
  "5년미만",
  "7년미만",
  "10년미만",
];

class EnterPreneurChipsSheet extends StatefulWidget {
  const EnterPreneurChipsSheet({super.key});

  @override
  State<EnterPreneurChipsSheet> createState() => _EnterPreneurChipsSheetState();
}

class _EnterPreneurChipsSheetState extends State<EnterPreneurChipsSheet> {
  Future<void> _saveSelectedEntrepreneur(String entrepreneur) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedEntrepreneur', entrepreneur);
  }

  void _onEntrePreneurBottom(BuildContext context) async {
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
                      '사업자 형태',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                  ),
                  Gaps.v8,
                  Expanded(
                    child: Scrollbar(
                      thickness: 4,
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: enterpreneur.length,
                        itemBuilder: (context, index) {
                          String entrepreneur = enterpreneur[index];
                          return BottomSheetList(
                            thisText: entrepreneur,
                            thisColor:
                                filterModel.selectedEntrepreneur == entrepreneur
                                    ? AppColors.g1
                                    : AppColors.white,
                            thisTapAction: () {
                              setStateBottomSheet(() {
                                filterModel
                                    .setSelectedEntrepreneur(entrepreneur);
                              });
                              _saveSelectedEntrepreneur(entrepreneur);
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
    final selectedEntrepreneur =
        Provider.of<FilterModel>(context).selectedEntrepreneur;

    return GestureDetector(
      onTap: () => _onEntrePreneurBottom(context),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: selectedEntrepreneur == "전체" ? AppColors.g1 : AppColors.blue,
          borderRadius: BorderRadius.circular(46),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.h12,
            Text(
              selectedEntrepreneur == "전체" ? '사업자 형태' : selectedEntrepreneur,
              style: AppTextStyles.btn2.copyWith(
                color: selectedEntrepreneur == "전체"
                    ? AppColors.g4
                    : AppColors.white,
              ),
            ),
            Gaps.h4,
            selectedEntrepreneur == "전체" ? AppIcon.down_g3 : AppIcon.down_g1,
            Gaps.h8,
          ],
        ),
      ),
    );
  }
}
