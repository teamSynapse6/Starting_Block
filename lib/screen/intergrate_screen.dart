import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class IntergrateScreen extends StatefulWidget {
  const IntergrateScreen({super.key});

  // 외부에서 접근 가능한 함수를 정의
  static void setSelectedIndexToZero(BuildContext context) {
    final state = context.findAncestorStateOfType<_OffCampusState>();
    state?.setSelectedIndexToZero();
  }

  @override
  State<IntergrateScreen> createState() => _OffCampusState();
}

class _OffCampusState extends State<IntergrateScreen> {
  int _selectedIndex = 1;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void setSelectedIndexToZero() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const OffCampusHome(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const OnCampusHome(),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: const Center(
              child: Text('홈'),
            ),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const RoadmapHome(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const Center(
              child: Text('마이페이지'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent, // BottomAppBar의 배경색을 투명하게 설정
        child: Column(
          children: [
            Gaps.v8,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Gaps.v8,
                GnbTap(
                  text: '교외 지원',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onTap(0),
                  selectedIndex: _selectedIndex,
                  selecetedImage: AppImages.outSchool_active,
                  unselecetedImage: AppImages.outSchool_inactive,
                ),
                GnbTap(
                  text: '교내 지원',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onTap(1),
                  selectedIndex: _selectedIndex,
                  selecetedImage: AppImages.school_active,
                  unselecetedImage: AppImages.school_inactive,
                ),
                GnbTap(
                  text: '홈',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onTap(2),
                  selectedIndex: _selectedIndex,
                  selecetedImage: AppImages.home_active,
                  unselecetedImage: AppImages.home_inactive,
                ),
                GnbTap(
                  text: '로드맵',
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onTap(3),
                  selectedIndex: _selectedIndex,
                  selecetedImage: AppImages.roadMap_active,
                  unselecetedImage: AppImages.roadMap_inactive,
                ),
                GnbTap(
                  text: '마이페이지',
                  isSelected: _selectedIndex == 4,
                  onTap: () => _onTap(4),
                  selectedIndex: _selectedIndex,
                  selecetedImage: AppImages.myProfile_active,
                  unselecetedImage: AppImages.myProfile_inactive,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
