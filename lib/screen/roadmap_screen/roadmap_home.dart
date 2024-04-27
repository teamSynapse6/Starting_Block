import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'dart:math' as math;

class RoadmapHome extends StatefulWidget {
  const RoadmapHome({super.key});

  @override
  State<RoadmapHome> createState() => _RoadmapHomeState();
}

class _RoadmapHomeState extends State<RoadmapHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _nickName = "";
  String _selectedRoadmapText = ""; // 선택된 Roadmap 텍스트를 저장
  bool _isCurrentStageSelected = false; // 현재 단계가 선택되었는지 여부
  int _roadMapId = 0;
  final GlobalKey<RoadMapListState> roadMapListKey =
      GlobalKey<RoadMapListState>(); // RoadMapListState에 접근하기 위해 사용
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _loadNickName();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadNickName() async {
    String nickName = await UserInfo.getNickName();
    setState(() {
      _nickName = nickName;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _tabController.dispose();
    super.dispose();
  }

  void backToTopTap() {
    _scrollController.animateTo(
      0.0, // 최상단 위치
      duration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
      curve: Curves.easeOut, // 애니메이션 곡선 설정
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBG,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          color: AppColors.blue,
        ),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              forceElevated: true,
              backgroundColor: AppColors.blue,
              pinned: true,
              expandedHeight: 152,
              collapsedHeight: 56,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24),
                expandedTitleScale: 1.33,
                title: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // AppBar의 최대 확장 높이를 계산합니다.
                    final double appBarHeight = constraints.biggest.height;
                    // AppBar의 최소 높이를 정의합니다.
                    const double collapsedHeight = 56;
                    // AppBar의 최대 높이를 정의합니다.
                    const double expandedHeight = 152;
                    // AppBar의 확장 정도를 계산합니다.
                    final double expansionRatio =
                        (appBarHeight - collapsedHeight) /
                            (expandedHeight - collapsedHeight);
                    // bottomPadding이 음수가 되지 않도록 보장합니다.
                    final double bottomPadding =
                        math.max(0, 16 + (32 * expansionRatio));

                    return Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding),
                      child: RoadMapList(
                        key: roadMapListKey,
                        selectedRoadMapTitle: (String title) {
                          setState(() {
                            _selectedRoadmapText = title;
                          });
                        },
                        selectedRoadMapId: (int id) {
                          setState(() {
                            _roadMapId = id;
                          });
                        },
                        isCurrentStage: (bool currentStage) {
                          setState(() {
                            _isCurrentStageSelected = currentStage;
                          });
                        },
                      ),
                    );
                  },
                ),
                background: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Gaps.v36,
                        Text(
                          '$_nickName님의 현재 단계는',
                          style: AppTextStyles.bd6
                              .copyWith(color: AppColors.white),
                        ),
                        Gaps.v46,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            _isCurrentStageSelected
                                ? NextStep(
                                    thisRightActionTap: () async {
                                      Navigator.of(context).pop();
                                      await RoadMapApi.roadMapLeap();
                                      roadMapListKey.currentState
                                          ?.loadRoadMaps();
                                    },
                                  )
                                : GoBackToStep(thisTap: () {
                                    roadMapListKey.currentState
                                        ?.selectInProgressRoadMap();
                                  }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: RoadMapPersistantTabBar(
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '교외사업'),
                    Tab(text: '교내사업'),
                    Tab(text: '창업강의'),
                    Tab(text: '창업제도'),
                  ],
                ),
              ),
            )
          ];
        },
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      TabScreenOfCaBiz(
                        thisSelectedText: _selectedRoadmapText,
                        thisCurrentStage: _isCurrentStageSelected,
                        thisSelectedId: _roadMapId,
                      ),
                      TabScreenOnCaNotify(
                        thisSelectedText: _selectedRoadmapText,
                        thisCurrentStage: _isCurrentStageSelected,
                        thisSelectedId: _roadMapId,
                      ),
                      TabScreenOnCaClass(
                        thisSelectedText: _selectedRoadmapText,
                        thisCurrentStage: _isCurrentStageSelected,
                        thisSelectedId: _roadMapId,
                      ),
                      TabScreenOnCaSystem(
                        thisSelectedText: _selectedRoadmapText,
                        thisCurrentStage: _isCurrentStageSelected,
                        thisSelectedId: _roadMapId,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isScrolled
                ? Positioned(
                    right: 24,
                    bottom: 15 + 9,
                    child: ScrollToTopButtion(
                      thisBackToTopTap: backToTopTap,
                    ))
                : Container()
          ],
        ),
      ),
    );
  }
}
