import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

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

  @override
  void initState() {
    super.initState();
    _loadNickName();
    _tabController = TabController(length: 4, vsync: this);
    // _selectedRoadmapText를 로드하는 논리를 여기에 추가합니다
  }

  final GlobalKey<State<RoadMapList>> roadMapListKey = GlobalKey();

  void resetToCurrentStage() {
    RoadMapList.resetToCurrentStage(roadMapListKey);
  }

  Future<void> _loadNickName() async {
    String nickName = await UserInfo.getNickName();
    setState(() {
      _nickName = nickName;
    });
  }

  // 콜백 함수 구현
  void _onSelectedRoadmapChanged(
      String selectedText, int selectedIndex, bool isCurrentStage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedRoadmapText = selectedText;
        _isCurrentStageSelected = isCurrentStage;
      });
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 152,
              width: MediaQuery.of(context).size.width,
              color: AppColors.blue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Gaps.v36,
                    Text(
                      '$_nickName님의 현재 단계는',
                      style: AppTextStyles.bd6.copyWith(color: AppColors.white),
                    ),
                    Gaps.v4,
                    RoadMapList(
                      key: roadMapListKey, // GlobalKey를 RoadMapList에 할당
                      onSelectedRoadmapChanged: _onSelectedRoadmapChanged,
                    ),
                    Gaps.v12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        _isCurrentStageSelected
                            ? NextStep(
                                onResetToCurrentStage: resetToCurrentStage)
                            : GoBackToStep(
                                onResetToCurrentStage: resetToCurrentStage),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: AppColors.white,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: '제도'),
                  Tab(text: '정규교과'),
                  Tab(text: '비교과'),
                  Tab(text: '교외사업'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Center(child: Text('제도')),
                  const Center(child: Text('정규교과')),
                  const Center(child: Text('비교과')),
                  TabScreenOfCaBiz(
                    key: ValueKey(_selectedRoadmapText), // Key를 추가합니다.
                    thisSelectedText: _selectedRoadmapText,
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
