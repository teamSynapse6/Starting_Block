import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/manage/userdata/user_info.dart';

class RoadMapSetFirstPopUp extends StatefulWidget {
  const RoadMapSetFirstPopUp({super.key});

  @override
  State<RoadMapSetFirstPopUp> createState() => _RoadMapSetFirstPopUpState();
}

class _RoadMapSetFirstPopUpState extends State<RoadMapSetFirstPopUp> {
  PageController pageController = PageController();
  int currentPage = 0;

  List<String> pageTexts = [
    '단계별로,\n필요한 공고를 저장하고\n관리해 보세요',
    '나만의 창업 로드맵을\n단계별로 계획할 수 있어요\n',
  ];
  List<Widget> pageIcons = [
    AppIcon.roadmap_pop1_illustrate,
    AppIcon.roadmap_pop2_illustrate
  ];

  @override
  void initState() {
    super.initState();
    setRoadmapPopUp();
  }

  //로드맵 팝업 True설정
  void setRoadmapPopUp() async {
    await UserInfo().setRoadMapPopUp(true);
  }

  //로드맵 설정하고 시작하기 탭
  void thisTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RoadmapListSet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CloseAppBar(),
      body: Column(
        children: [
          Gaps.v40,
          SizedBox(
            height: 381,
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                controller: pageController,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pageTexts[index],
                          style: const TextStyle(
                            fontFamily: 'pretendard',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Gaps.v52,
                        Center(child: pageIcons[index]),
                      ],
                    ),
                  );
                }),
          ),
          Gaps.v23,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(2, (int index) {
              return AnimatedContainer(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                duration: const Duration(milliseconds: 300),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index ? AppColors.salmon : AppColors.g3,
                ),
              );
            }),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 92,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: InkWell(
            onTap: thisTap,
            child: const NextContained(
              disabled: false,
              text: '로드맵 설정하고 시작하기',
            ),
          ),
        ),
      ),
    );
  }
}
