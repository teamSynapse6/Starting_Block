// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:starting_block/screen/on_campus_screen/widget/oncampus_supportgroup_delegate.dart';

class OnCampusSupportGroup extends StatefulWidget {
  const OnCampusSupportGroup({super.key});

  @override
  State<OnCampusSupportGroup> createState() => _OnCampusSupportGroupState();
}

class _OnCampusSupportGroupState extends State<OnCampusSupportGroup>
    with TickerProviderStateMixin {
  String _svgLogo = ""; // SVG 데이터를 저장할 변수
  String _schoolName = "";
  late TabController _tabController; // TabController 추가
  List<Tab> myTabs = [];

  @override
  void initState() {
    super.initState();
    _loadSchoolName();
    _loadSvgLogo();

    _loadTabs(); // 서버로부터 탭 데이터를 로드하는 메서드 호출
  }

  Future<void> _loadTabs() async {
    try {
      List<String> tabTitles = await OnCampusAPI.getSupportTabList();
      List<Tab> tabs = tabTitles.map((tabText) => Tab(text: tabText)).toList();

      setState(() {
        // try-catch 블록을 사용하여 _tabController의 초기화 여부를 확인
        try {
          _tabController.dispose();
        } catch (_) {
          // _tabController가 초기화되지 않았으면 여기서 에러가 발생합니다.
          // 이 경우 특별히 해야 할 작업이 없으므로 무시합니다.
        }
        myTabs = tabs;
        _tabController = TabController(length: myTabs.length, vsync: this);
      });
    } catch (e) {
      print("탭 데이터 로드 실패: $e");
    }
  }

  Future<void> _loadSchoolName() async {
    String schoolName = await UserInfo.getSchoolName();
    setState(() {
      _schoolName = schoolName;
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // TabController 해제
    super.dispose();
  }

  Future<void> _loadSvgLogo() async {
    try {
      String svgData = await OnCampusAPI.onCampusLogo();
      setState(() {
        _svgLogo = svgData;
      });
    } catch (e) {
      print('SVG 로고 로드 실패: $e');
    }
  }

  // 특정 탭이 myTabs에 있는지 확인하는 함수
  bool isTabPresent(String tabText) {
    return myTabs.any((tab) => tab.text == tabText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              snap: true,
              floating: true,
              elevation: 0,
              forceElevated: innerBoxIsScrolled,
              backgroundColor: AppColors.white,
              pinned: true,
              expandedHeight: 116,
              collapsedHeight: 56,
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: AppIcon.back,
                ),
              ),
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // AppBar의 최대 높이와 현재 높이를 기준으로 패딩 값을 계산
                  double appBarHeight = constraints.biggest.height;
                  double maxPaddingTop = 32.0;
                  double minPaddingTop = 5;
                  double paddingTopRange = maxPaddingTop - minPaddingTop;
                  double heightRange =
                      116 - 56; // expandedHeight - collapsedHeight

                  // 선형적으로 paddingBottom 계산
                  double paddingBottom = minPaddingTop +
                      paddingTopRange * ((appBarHeight - 56) / heightRange);

                  return FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    titlePadding: EdgeInsets.only(
                      bottom: paddingBottom,
                      left: 60,
                    ),
                    title: Text(
                      '$_schoolName 창업지원단',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                    background: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gaps.v74,
                          _svgLogo.isNotEmpty
                              ? SvgPicture.string(
                                  _svgLogo,
                                  fit: BoxFit.scaleDown,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverPersistentHeader(
              delegate: OnCampusSupprtGroupDelegate(
                TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  unselectedLabelColor: AppColors.g3,
                  labelColor: AppColors.g6,
                  unselectedLabelStyle: AppTextStyles.bd2,
                  labelStyle: AppTextStyles.bd1,
                  indicatorColor: AppColors.g6,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                        width: 2.0, color: AppColors.g6), // 높이가 2인 인디케이터 설정
                    insets: EdgeInsets.zero, // 인디케이터의 패딩을 0으로 설정
                  ),
                  controller: _tabController,
                  tabs: myTabs,
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            if (isTabPresent('멘토링')) const OnCaGroupMentoring(),
            if (isTabPresent('동아리')) const OnCaGroupClub(),
            if (isTabPresent('특강')) const OnCaGroupLecture(),
            if (isTabPresent('경진대회 및 캠프')) const OnCaGroupCompetition(),
            if (isTabPresent('공간')) const OnCaGroupSpace(),
            if (isTabPresent('기타')) const OnCaGroupEtc(),
          ],
        ),
      ),
    );
  }
}
