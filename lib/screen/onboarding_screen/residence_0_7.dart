// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class ResidenceScreen extends StatefulWidget {
  const ResidenceScreen({super.key});

  @override
  State<ResidenceScreen> createState() => _ResidenceScreenState();
}

class _ResidenceScreenState extends State<ResidenceScreen> {
  String? selectedRegion; // 선택된 지역을 추적

  final List<String> regions = [
    '서울',
    '부산',
    '대구',
    '인천',
    '경기',
    '강원',
    '충북',
    '충남',
    '전북',
    '광주',
    '대전',
    '울산',
    '세종',
    '전남',
    '경북',
    '경남',
    '제주',
  ];

  Widget buildGrid() {
    List<Widget> rows = [];
    for (int i = 0; i < regions.length; i += 2) {
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 2 && j < regions.length; j++) {
        rowChildren.add(
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: selectedRegion == regions[j]
                    ? AppColors.g2
                    : AppColors.white,
                border: Border(
                  top: const BorderSide(width: 1, color: AppColors.g1),
                  right: j % 2 == 0
                      ? const BorderSide(width: 0.5, color: AppColors.g1)
                      : BorderSide.none,
                ),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  backgroundColor: selectedRegion == regions[j]
                      ? AppColors.g2
                      : AppColors.white,
                ),
                onPressed: () => _onRegionTap(regions[j]),
                child: Text(
                  regions[j],
                  style: const TextStyle(
                    color: AppColors.g6,
                    fontFamily: 'pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        );

        // 중간의 수직 선 추가
        if (j % 2 == 0 && j + 1 < regions.length) {
          rowChildren.add(
            const VerticalDivider(
              width: 0.5,
              color: AppColors.g1,
              indent: 14,
              endIndent: 14,
            ),
          );
        }
      }

      if (i + 2 > regions.length) {
        rowChildren.add(const Expanded(child: SizedBox()));
      }

      rows.add(Row(children: rowChildren));
    }
    return Column(children: rows);
  }

  void _onRegionTap(String region) {
    setState(() {
      selectedRegion = region;
    });
  }

  Future<void> _saveUserResidence() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userResidence', selectedRegion ?? "");
  }

  void _onNextTap() async {
    if (selectedRegion == null) return; // 지역이 선택되지 않으면 반환

    // 선택된 지역명을 SharedPreferences에 저장
    await _saveUserResidence();

    // 다음 화면으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SchoolScreen(),
      ),
    );
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
                ],
              ),
              Gaps.v36,
              Text(
                "거주지를 선택해주세요",
                style: AppTextStyles.h5.copyWith(color: AppColors.g6),
              ),
              Gaps.v10,
              Text(
                "주민등록상의 거주지를 선택해주세요",
                style: AppTextStyles.bd6.copyWith(color: AppColors.g6),
              ),
              Gaps.v32,
              buildGrid(),
              const Spacer(), // 나머지 공간을 채우는 위젯
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GestureDetector(
                  onTap: _onNextTap,
                  child: NextContained(
                    text: "다음",
                    disabled: selectedRegion == null,
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
