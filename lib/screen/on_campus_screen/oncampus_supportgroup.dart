// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/on_campus_screen/widget/oncampus_supportgroup_delegate.dart';

const List<Tab> myTabs = [
  Tab(text: '멘토링'),
  Tab(text: '동아리'),
  Tab(text: '특강'),
  Tab(text: '경진대회 및 캠프'),
  Tab(text: '공간'),
  Tab(text: '기타'),
];

class OnCampusSupportGroup extends StatefulWidget {
  const OnCampusSupportGroup({super.key});

  @override
  State<OnCampusSupportGroup> createState() => _OnCampusSupportGroupState();
}

class _OnCampusSupportGroupState extends State<OnCampusSupportGroup>
    with SingleTickerProviderStateMixin {
  String _svgLogo = ""; // SVG 데이터를 저장할 변수
  String _schoolName = "";
  late TabController _tabController; // TabController 추가

  @override
  void initState() {
    super.initState();
    _loadSchoolName();
    _loadSvgLogo();
    _tabController =
        TabController(length: myTabs.length, vsync: this); // TabController 초기화
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
            if (isTabPresent('멘토링')) const Center(child: Text('Tab 1 내용')),
            if (isTabPresent('동아리')) const Center(child: Text('Tab 2 내용')),
            if (isTabPresent('특강')) const Center(child: Text('Tab 3 내용')),
            if (isTabPresent('경진대회 및 캠프'))
              const Center(child: Text('Tab 4 내용')),
            if (isTabPresent('공간')) const Center(child: Text('Tab 5 내용')),
            if (isTabPresent('기타')) const Center(child: Text('Tab 6 내용')),
          ],
        ),
      ),
    );
  }
}
