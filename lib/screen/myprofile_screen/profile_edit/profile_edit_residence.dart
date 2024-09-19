// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class ResidenceEdit extends StatefulWidget {
  const ResidenceEdit({super.key});

  @override
  State<ResidenceEdit> createState() => _ResidenceEditState();
}

class _ResidenceEditState extends State<ResidenceEdit> {
  String? selectedRegion; // 선택된 지역을 추적

  final List<String> regions = globalDataRegionList;

  Widget residenceGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // 스크롤 방지

      shrinkWrap: true, // 내용물 크기에 맞게 축소
      itemCount: regions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2열로 나열
        childAspectRatio: 156 / 44, // 아이템의 너비와 높이의 비율 조정
      ),
      itemBuilder: (context, index) {
        // 마지막 항목 이전의 가장 오른쪽 아래에 있는 항목인지 확인
        bool isSecondLastItemInOddRow =
            index == regions.length - 2 && regions.length % 2 != 0;
        // 모든 셀에 상단 경계선 추가
        BorderSide topBorder = const BorderSide(width: 1, color: AppColors.g1);

        return Container(
          decoration: BoxDecoration(
            color: selectedRegion == regions[index]
                ? AppColors.bluebg
                : AppColors.white,
            border: Border(
              top: topBorder,
              bottom: isSecondLastItemInOddRow
                  ? const BorderSide(width: 1, color: AppColors.g1)
                  : BorderSide.none,
            ),
          ),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    backgroundColor: selectedRegion == regions[index]
                        ? AppColors.bluebg
                        : AppColors.white,
                  ),
                  onPressed: regions[index].isNotEmpty
                      ? () => _onRegionTap(regions[index])
                      : null,
                  child: Text(
                    regions[index],
                    style: TextStyle(
                      color: selectedRegion == regions[index]
                          ? AppColors.blue
                          : AppColors.g6,
                      fontFamily: 'pretendard',
                      fontSize: 14,
                      fontWeight: selectedRegion == regions[index]
                          ? FontWeight.bold
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
              if (index % 2 == 0) // 첫 번째 열의 오른쪽에만 선을 그립니다.
                Positioned(
                  top: 0.31 * 44, // 여기서 44는 셀의 높이입니다.
                  bottom: 0.31 * 44,
                  right: 0,
                  child: Container(
                    width: 0.5,
                    color: AppColors.g2,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onRegionTap(String region) async {
    setState(() {
      selectedRegion = region;
    });
    await _saveUserResidence();
    await Future.delayed(const Duration(milliseconds: 500)).then((_) {
      _onNextTap();
    });
  }

  Future<void> _saveUserResidence() async {
    await SaveUserData.loadFromLocalAndFetchToServer(
        inputResidence: selectedRegion);
  }

  void _onNextTap() {
    if (selectedRegion == null) return;
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
                "거주지를 선택해주세요",
                style: AppTextStyles.h5.copyWith(color: AppColors.g6),
              ),
              Gaps.v32,
              residenceGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
