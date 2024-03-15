import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
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
  final String _selectedRoadmapText = ""; // 선택된 Roadmap 텍스트를 저장
  final bool _isCurrentStageSelected = false; // 현재 단계가 선택되었는지 여부

  @override
  void initState() {
    super.initState();
    _loadNickName();
    _tabController = TabController(length: 4, vsync: this);
    // _selectedRoadmapText를 로드하는 논리를 여기에 추가합니다
  }

  Future<void> _loadNickName() async {
    String nickName = await UserInfo.getNickName();
    setState(() {
      _nickName = nickName;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
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
                    // AppBar의 현재 높이에 따라 backgroundOpacity를 계산합니다.
                    // if (appBarHeight > 85) {
                    //   backgroundOpacity = ((appBarHeight - 85) / (152 - 85));
                    // } else {
                    //   backgroundOpacity = 0.0; // 85 이하일 때 투명도를 0으로 설정
                    // }
                    // print('앱바높이: $appBarHeight');
                    // print('투명도: $backgroundOpacity');
                    return Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding),
                      child: const RoadMapList(),
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            // GoBackToStep(
                            //     onResetToCurrentStage: resetToCurrentStage),
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
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TabScreenOfCaBiz(
                    thisSelectedText: _selectedRoadmapText,
                    thisCurrentStage: _isCurrentStageSelected,
                  ),
                  TabScreenOnCaNotify(
                    thisSelectedText: _selectedRoadmapText,
                    thisCurrentStage: _isCurrentStageSelected,
                  ),
                  TabScreenOnCaClass(
                    thisSelectedText: _selectedRoadmapText,
                    thisCurrentStage: _isCurrentStageSelected,
                  ),
                  TabScreenOnCaSystem(
                    thisSelectedText: _selectedRoadmapText,
                    thisCurrentStage: _isCurrentStageSelected,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
