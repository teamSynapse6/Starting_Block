// import 'package:flutter/material.dart';
// import 'package:starting_block/constants/constants.dart';
// import 'package:starting_block/screen/manage/screen_manage.dart';
// import 'dart:math' as math;

// class TestRoadmapHome extends StatefulWidget {
//   const TestRoadmapHome({super.key});

//   @override
//   State<TestRoadmapHome> createState() => _TestRoadmapHomeState();
// }

// class _TestRoadmapHomeState extends State<TestRoadmapHome>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _nickName = "";
//   String _selectedRoadmapText = ""; // 선택된 Roadmap 텍스트를 저장
//   bool _isCurrentStageSelected = false; // 현재 단계가 선택되었는지 여부

//   @override
//   void initState() {
//     super.initState();
//     _loadNickName();
//     _tabController = TabController(length: 4, vsync: this);
//     // _selectedRoadmapText를 로드하는 논리를 여기에 추가합니다
//   }

//   final GlobalKey<State<RoadMapList>> roadMapListKey = GlobalKey();

//   void resetToCurrentStage() {
//     RoadMapList.resetToCurrentStage(roadMapListKey);
//   }

//   Future<void> _loadNickName() async {
//     String nickName = await UserInfo.getNickName();
//     setState(() {
//       _nickName = nickName;
//     });
//   }

//   // 콜백 함수 구현
//   void _onSelectedRoadmapChanged(
//       String selectedText, int selectedIndex, bool isCurrentStage) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         _selectedRoadmapText = selectedText;
//         _isCurrentStageSelected = isCurrentStage;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondaryBG,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(0),
//         child: Container(
//           color: AppColors.blue,
//         ),
//       ),
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               elevation: 0,
//               forceElevated: true,
//               backgroundColor: AppColors.blue,
//               pinned: true,
//               expandedHeight: 152,
//               collapsedHeight: 56,
//               flexibleSpace: FlexibleSpaceBar(
//                 titlePadding: const EdgeInsets.symmetric(horizontal: 24),
//                 expandedTitleScale: 1.33,
//                 title: LayoutBuilder(
//                   builder: (BuildContext context, BoxConstraints constraints) {
//                     // AppBar의 최대 확장 높이를 계산합니다.
//                     final double appBarHeight = constraints.biggest.height;
//                     // AppBar의 최소 높이를 정의합니다.
//                     const double collapsedHeight = 56;
//                     // AppBar의 최대 높이를 정의합니다.
//                     const double expandedHeight = 152;
//                     // AppBar의 확장 정도를 계산합니다.
//                     final double expansionRatio =
//                         (appBarHeight - collapsedHeight) /
//                             (expandedHeight - collapsedHeight);
//                     // bottomPadding이 음수가 되지 않도록 보장합니다.
//                     final double bottomPadding =
//                         math.max(0, 16 + (32 * expansionRatio));
//                     // 패딩을 동적으로 계산합니다.
//                     return Padding(
//                       padding: EdgeInsets.only(bottom: bottomPadding),
//                       child: RoadMapList(
//                         key: roadMapListKey,
//                         onSelectedRoadmapChanged: _onSelectedRoadmapChanged,
//                       ),
//                     );
//                   },
//                 ),
//                 background: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Gaps.v36,
//                         Text(
//                           '$_nickName님의 현재 단계는',
//                           style: AppTextStyles.bd6
//                               .copyWith(color: AppColors.white),
//                         ),
//                         Gaps.v46,
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Spacer(),
//                             _isCurrentStageSelected
//                                 ? NextStep(
//                                     onResetToCurrentStage: resetToCurrentStage)
//                                 : GoBackToStep(
//                                     onResetToCurrentStage: resetToCurrentStage),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SliverPersistentHeader(
//               pinned: true,
//               delegate: RoadMapPersistantTabBar(
//                 child: TabBar(
//                   controller: _tabController,
//                   tabs: const [
//                     Tab(text: '교외사업'),
//                     Tab(text: '교내사업'),
//                     Tab(text: '창업강의'),
//                     Tab(text: '창업제도'),
//                   ],
//                 ),
//               ),
//             )
//           ];
//         },
//         body: Column(
//           children: [
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   TabScreenOfCaBiz(
//                     key: ValueKey(_selectedRoadmapText),
//                     thisSelectedText: _selectedRoadmapText,
//                   ),
//                   const Center(child: Text('교내사업')),
//                   const Center(child: Text('창업강의')),
//                   const Center(child: Text('창업제도')),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
