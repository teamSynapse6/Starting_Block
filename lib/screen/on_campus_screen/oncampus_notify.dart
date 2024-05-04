// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/onca_sorting_textbuttonsheet.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/on_campus_screen/widget/oncampus_notify_delegate.dart';

class OnCampusNotify extends StatefulWidget {
  const OnCampusNotify({super.key});

  @override
  State<OnCampusNotify> createState() => _OnCampusNotifyState();
}

class _OnCampusNotifyState extends State<OnCampusNotify> {
  List<OnCampusNotifyModel> _notifyList = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadFilteredOnCampusNotify();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose(); // 위젯 사용이 끝날 때 컨트롤러 해제
    super.dispose();
  }

  Future<void> _loadFilteredOnCampusNotify() async {
    setState(() {
      isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      String selectedProgram = prefs.getString('selectedProgram') ?? "전체";
      String selectedSorting =
          prefs.getString('selectedOnCaSorting') ?? "latest";
      List<OnCampusNotifyModel> notifyList =
          await OnCampusAPI.getOnCampusNotifyFiltered(
        program: selectedProgram,
        sorting: selectedSorting,
      );
      setState(() {
        _notifyList = notifyList;
        isLoading = false;
      });
    } catch (e) {
      print('공고 정보 로드 실패: $e');
    }
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
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: AppColors.white,
          )),
      body: Stack(
        children: [
          NestedScrollView(
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
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OnCampusSearch()),
                          );
                        },
                        child: SizedBox(
                          height: 48,
                          width: 48,
                          child: AppIcon.search,
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      // AppBar의 최대 높이와 현재 높이를 기준으로 패딩 값을 계산
                      double appBarHeight = constraints.biggest.height;
                      double maxPaddingTop = 20;
                      double minPaddingTop = 16;
                      double paddingTopRange = maxPaddingTop - minPaddingTop;
                      double heightRange =
                          128 - 56; // expandedHeight - collapsedHeight

                      // 선형적으로 paddingBottom 계산
                      double paddingBottom = minPaddingTop +
                          paddingTopRange * ((appBarHeight - 56) / heightRange);

                      return FlexibleSpaceBar(
                        expandedTitleScale: 24 / 18,
                        titlePadding: EdgeInsets.only(
                          top: 16,
                          bottom: paddingBottom,
                          left: 60,
                        ),
                        title: Text(
                          '지원 공고',
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
                  delegate: OnCampusNotifyDelegate(
                    child: Container(
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const OnCaIntergrateFilter(),
                            Gaps.v12,
                            Container(
                              height: 32,
                              decoration: const BoxDecoration(
                                border: BorderDirectional(
                                  top:
                                      BorderSide(width: 2, color: AppColors.g1),
                                  bottom:
                                      BorderSide(width: 2, color: AppColors.g1),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${_notifyList.length}개의 공고',
                                    style: AppTextStyles.bd4
                                        .copyWith(color: AppColors.g4),
                                  ),
                                  const Spacer(), // 왼쪽 텍스트와 오른쪽 버튼 사이의 공간을 만듦
                                  const OnCampusSortingButton()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: isLoading
                ? const OncaSkeletonNotify()
                : Consumer<OnCaFilterModel>(
                    builder: (context, filterModel, child) {
                      if (filterModel.hasChanged) {
                        _loadFilteredOnCampusNotify()
                            .then((_) => filterModel.resetChangeFlag());
                      }
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true, // 내부 스크롤 없이 전체 높이를 표시
                                physics:
                                    const NeverScrollableScrollPhysics(), // 부모 스크롤과의 충돌 방지
                                itemCount: _notifyList.length,
                                itemBuilder: (context, index) {
                                  OnCampusNotifyModel notify =
                                      _notifyList[index];
                                  return Column(
                                    children: [
                                      OnCampusNotifyListCard(
                                        thisProgramText: notify.type,
                                        thisId: notify.id,
                                        thisTitle: notify.title,
                                        thisStartDate: notify.startdate,
                                        thisUrl: notify.detailurl,
                                      ),
                                      if (index < _notifyList.length - 1)
                                        const CustomDividerH2G1(),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
    );
  }
}
