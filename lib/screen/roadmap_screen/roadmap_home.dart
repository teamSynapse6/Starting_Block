import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/widget/roadmap_card.dart';
import 'package:starting_block/screen/roadmap_screen/widget/roadmap_stepnotify.dart';

class RoadmapHome extends StatefulWidget {
  const RoadmapHome({super.key});

  @override
  State<RoadmapHome> createState() => _RoadmapHomeState();
}

class _RoadmapHomeState extends State<RoadmapHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _nickName = "";
  final bool _isRecommend = false;
  final bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadNickName();
    _tabController = TabController(length: 4, vsync: this); // 4개의 탭
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNickName() async {
    String nickName = await UserInfo.getNickName();
    setState(() {
      _nickName = nickName;
    });
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
                    const RoadMapList(),
                    Gaps.v12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: 32,
                          width: 129,
                          child: Center(
                            child: Row(
                              children: [
                                Gaps.h12,
                                Text(
                                  '다음 단계 도약하기',
                                  style: AppTextStyles.btn2
                                      .copyWith(color: AppColors.white),
                                ),
                                Gaps.h2,
                                Image(image: AppImages.next_g1)
                              ],
                            ),
                          ),
                        )
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.v24,
                      _isRecommend
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '추천 사업',
                                        style: AppTextStyles.st2
                                            .copyWith(color: AppColors.blue),
                                      ),
                                      TextSpan(
                                        text: ' 이 도착했습니다',
                                        style: AppTextStyles.st2
                                            .copyWith(color: AppColors.g6),
                                      ),
                                    ],
                                  ),
                                ),
                                Gaps.v16,
                                SizedBox(
                                  height: 198, // RoadMapCard의 높이
                                  child: PageView.builder(
                                    itemCount: 3, // 카드의 개수
                                    controller: PageController(
                                      viewportFraction: 314 /
                                          MediaQuery.of(context)
                                              .size
                                              .width, // 페이지 뷰에서 한 번에 보여지는 카드의 비율
                                    ),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 6), // 좌우 마진 (카드 간 간격)
                                        child:
                                            const RoadMapCard(), // 여기에 RoadMapCard 위젯을 넣습니다.
                                      );
                                    },
                                  ),
                                ),
                                Gaps.v36,
                              ],
                            )
                          : const RoadMapStepNotify(),
                      Text(
                        '저장한 사업으로 도약하기',
                        style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                      ),
                      Gaps.v4,
                      Text(
                        '신청 완료한 사업은 도약 완료 버튼으로 진행도 확인하기',
                        style:
                            AppTextStyles.caption.copyWith(color: AppColors.g5),
                      ),
                      Gaps.v20,
                      _isSaved
                          ? const RoadMapCard()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Gaps.v40,
                                Text(
                                  '저장한 지원 사업이 없어요',
                                  style: AppTextStyles.bd4
                                      .copyWith(color: AppColors.g4),
                                ),
                                Gaps.v8,
                                Container(
                                  width: 130,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.g3,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '지원사업 저장하러가기',
                                      style: AppTextStyles.bd6
                                          .copyWith(color: AppColors.g4),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                  const Center(child: Text('정규교과')),
                  const Center(child: Text('비교과')),
                  const Center(child: Text('교외사업')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
