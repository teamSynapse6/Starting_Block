// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/on_campus_screen/widget/oncampus_supportgroup_delegate.dart';

class OnCampusSupportGroup extends StatefulWidget {
  const OnCampusSupportGroup({super.key});

  @override
  State<OnCampusSupportGroup> createState() => _OnCampusSupportGroupState();
}

class _OnCampusSupportGroupState extends State<OnCampusSupportGroup>
    with TickerProviderStateMixin {
  String _schoolName = "";
  TabController? _tabController;
  List<Tab> myTabs = [
    const Tab(text: '멘토링'),
    const Tab(text: '동아리'),
    const Tab(text: '특강'),
    const Tab(text: '경진대회 및 캠프'),
    const Tab(text: '공간'),
    const Tab(text: '기타'),
  ];
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _loadSchoolName();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController?.dispose(); // TabController 해제
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose(); // 위젯 사용이 끝날 때 컨트롤러 해제
    super.dispose();
  }

  Future<void> _loadSchoolName() async {
    String schoolName = await UserInfo.getSchoolName();
    setState(() {
      _schoolName = schoolName;
    });
  }

  // 특정 탭이 myTabs에 있는지 확인하는 함수
  bool isTabPresent(String tabText) {
    return myTabs.any((tab) => tab.text == tabText);
  }

  void _onScroll() {
    if (_scrollController.offset == 0) {
      setState(() {
        _isScrolled = false;
      });
    }
    if (_scrollController.offset != 0) {
      setState(() {
        _isScrolled = true;
      });
    }
  }

  void backToTopTap() {
    _scrollController.animateTo(
      0.0, // 최상단 위치
      duration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
      curve: Curves.easeOut, // 애니메이션 곡선 설정
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: AppColors.white,
          )),
      body: _tabController == null
          ? Container()
          : NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    snap: true,
                    floating: true,
                    elevation: 0,
                    forceElevated: innerBoxIsScrolled,
                    backgroundColor: AppColors.white,
                    pinned: true,
                    expandedHeight: 128,
                    collapsedHeight: 56,
                    leading: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: AppIcon.back,
                      ),
                    ),
                    flexibleSpace: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        // AppBar의 최대 높이와 현재 높이를 기준으로 패딩 값을 계산
                        double appBarHeight = constraints.biggest.height;
                        double maxPaddingTop = 20;
                        double minPaddingTop = 16;
                        double paddingTopRange = maxPaddingTop - minPaddingTop;
                        double heightRange = 128 - 56;
                        // 선형적으로 paddingBottom 계산
                        double paddingBottom = minPaddingTop +
                            paddingTopRange *
                                ((appBarHeight - 56) / heightRange);

                        return FlexibleSpaceBar(
                          expandedTitleScale: 24 / 18,
                          titlePadding: EdgeInsets.only(
                            top: 16,
                            bottom: paddingBottom,
                            left: 60,
                          ),
                          title: Text(
                            '$_schoolName 창업지원단',
                            style:
                                AppTextStyles.st2.copyWith(color: AppColors.g6),
                          ),
                          background: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gaps.v80,
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: SchoolLogoWidget(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
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
                              width: 2.0,
                              color: AppColors.g6), // 높이가 2인 인디케이터 설정
                          insets: EdgeInsets.zero, // 인디케이터의 패딩을 0으로 설정
                        ),
                        controller: _tabController,
                        tabs: myTabs,
                      ),
                    ),
                  ),
                ];
              },
              body: Stack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: [
                      if (isTabPresent('멘토링')) const OnCaGroupMentoring(),
                      if (isTabPresent('동아리')) const OnCaGroupClub(),
                      if (isTabPresent('특강')) const OnCaGroupLecture(),
                      if (isTabPresent('경진대회 및 캠프'))
                        const OnCaGroupCompetition(),
                      if (isTabPresent('공간')) const OnCaGroupSpace(),
                      if (isTabPresent('기타')) const OnCaGroupEtc(),
                    ],
                  ),
                  _isScrolled
                      ? Positioned(
                          right: 24,
                          bottom: 12,
                          child: ScrollToTopButton(
                            thisBackToTopTap: backToTopTap,
                          ))
                      : Container()
                ],
              ),
            ),
    );
  }
}
