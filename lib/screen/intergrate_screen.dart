import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

enum SwitchIndex {
  none,
  toZero,
  toOne,
  toTwo,
  toThree,
  toFour,
}

class IntergrateScreen extends StatefulWidget {
  final SwitchIndex switchIndex;

  const IntergrateScreen({
    super.key,
    this.switchIndex = SwitchIndex.none,
  });

  // 외부에서 접근 가능한 함수를 정의_교외지원사업 탭
  static void setSelectedIndexToZero(BuildContext context) {
    final state = context.findAncestorStateOfType<_IntergrateScreenState>();
    state?.setSelectedIndexToZero();
  }

  // 외부에서 접근 가능한 함수를 정의_교내지원사업 탭
  static void setSelectedIndexToOne(BuildContext context) {
    final state = context.findAncestorStateOfType<_IntergrateScreenState>();
    state?.setSelectedIndexToOne();
  }

  @override
  State<IntergrateScreen> createState() => _IntergrateScreenState();
}

class _IntergrateScreenState extends State<IntergrateScreen> {
  int _selectedIndex = 3;
  String _schoolName = "";
  final bool _isRoadMapEmpty = false;

  @override
  void initState() {
    super.initState();

    _loadSchoolName();
    switch (widget.switchIndex) {
      case SwitchIndex.none:
        // 초기 설정이 필요 없는 경우
        break;
      case SwitchIndex.toZero:
        _selectedIndex = 0;
        break;
      case SwitchIndex.toOne:
        _selectedIndex = 1;
        break;
      case SwitchIndex.toTwo:
        _selectedIndex = 2;
        break;
      case SwitchIndex.toThree:
        _selectedIndex = 3;
        break;
      case SwitchIndex.toFour:
        _selectedIndex = 4;
        break;
    }
  }

  Future<void> _loadSchoolName() async {
    String schoolName = await UserInfo.getSchoolName(); // 비동기 호출
    setState(() {
      _schoolName = schoolName;
    });
  }

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

  void setSelectedIndexToOne() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const OffCampusHome();
      case 1:
        if (_schoolName == '') {
          return const OnCampusSchoolSet();
        } else {
          return const OnCampusHome();
        }
      case 2:
        return const HomeScreen();
      case 3:
        if (_isRoadMapEmpty) {
          return const RoadMapListSet();
        } else {
          return const RoadmapHome();
        }
      case 4:
      default:
        return const MyProfileHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<UserInfo>(
            builder: (context, userInfo, child) {
              if (userInfo.hasChanged) {
                _loadSchoolName();
                userInfo.resetChangeFlag();
              }
              return _getCurrentScreen();
            },
          ),
          const Positioned(
            bottom: 0,
            child: BottomGradient(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 56,
        elevation: 0,
        color: const Color.fromRGBO(0, 0, 0, 0),
        child: Column(
          children: [
            Gaps.v8,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 각 탭 구성
                GnbTap(
                  text: '교외 지원',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onTap(0),
                  selectedIndex: _selectedIndex,
                  selecetedIcon: AppIcon.outSchool_active,
                  unselecetedIcon: AppIcon.outSchool_inactive,
                ),
                GnbTap(
                  text: '교내 지원',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onTap(1),
                  selectedIndex: _selectedIndex,
                  selecetedIcon: AppIcon.school_active,
                  unselecetedIcon: AppIcon.school_inactive,
                ),
                GnbTap(
                  text: '홈',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onTap(2),
                  selectedIndex: _selectedIndex,
                  selecetedIcon: AppIcon.home_active,
                  unselecetedIcon: AppIcon.home_inactive,
                ),
                GnbTap(
                  text: '로드맵',
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onTap(3),
                  selectedIndex: _selectedIndex,
                  selecetedIcon: AppIcon.roadMap_active,
                  unselecetedIcon: AppIcon.roadMap_inactive,
                ),
                GnbTap(
                  text: '마이페이지',
                  isSelected: _selectedIndex == 4,
                  onTap: () => _onTap(4),
                  selectedIndex: _selectedIndex,
                  selecetedIcon: AppIcon.myProfile_active,
                  unselecetedIcon: AppIcon.myProfile_inactive,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
