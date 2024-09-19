import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/oncampus_filter/model/onca_filter_model.dart';

const sortingList = [
  "최신순",
  "로드맵에 저장 많은 순",
];

class OnCampusSortingButton extends StatefulWidget {
  const OnCampusSortingButton({super.key});

  @override
  State<OnCampusSortingButton> createState() => _OnCampusSortingButtonState();
}

class _OnCampusSortingButtonState extends State<OnCampusSortingButton> {
  void onSortingBottom(
      BuildContext context, OnCaFilterModel filterModel) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateBottomSheet) {
            return Container(
              height: 176,
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v24,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '정렬',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                  ),
                  Gaps.v8,
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: sortingList.length,
                        itemBuilder: (context, index) {
                          String sortingItem = sortingList[index];
                          return BottomSheetList(
                            thisText: sortingItem,
                            thisColor: AppColors.white,
                            thisTapAction: () {
                              setStateBottomSheet(() {
                                filterModel.selectedSorting = sortingItem;
                              });
                              Navigator.pop(context); // 바텀 시트 닫기
                            },
                          );
                        },
                      ),
                    ),
                  ),
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
    // Provider를 사용하여 OnCaFilterModel 인스턴스에 접근
    final filterModel = Provider.of<OnCaFilterModel>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onSortingBottom(context, filterModel),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
        child: Row(
          children: [
            Text(
              filterModel.selectedSorting, // 선택된 정렬 옵션 표시
              style: AppTextStyles.btn1.copyWith(color: AppColors.g5),
            ),
            Gaps.h4,
            AppIcon.down_g3,
          ],
        ),
      ),
    );
  }
}
