// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/models/oncampus_system_model.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCampusSystem extends StatefulWidget {
  const OnCampusSystem({super.key});

  @override
  State<OnCampusSystem> createState() => _OnCampusSystemState();
}

class _OnCampusSystemState extends State<OnCampusSystem> {
  List<OnCampusSystemModel> _systemList = []; // OnCampusSystemModel의 리스트
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadOnCampusSystem(); // 학사 제도 정보를 로드하는 함수 호출
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose(); // 위젯 사용이 끝날 때 컨트롤러 해제
    super.dispose();
  }

  Future<void> _loadOnCampusSystem() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<OnCampusSystemModel> systemList =
          await OnCampusAPI.getOnCampusSystem();
      setState(() {
        _systemList = systemList;
        isLoading = false;
      });
    } catch (e) {
      print('학사 제도 정보 로드 실패: $e');
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
      backgroundColor: AppColors.g1,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: AppColors.g1,
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
                  backgroundColor: AppColors.g1,
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
                            '창업 관련 학사 제도',
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
                          ));
                    },
                  ),
                )
              ];
            },
            body: isLoading
                ? const OncaSkeletonSystem()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true, // 스크롤뷰 내부의 리스트뷰에 필요
                            physics:
                                const NeverScrollableScrollPhysics(), // 중첩 스크롤 문제 방지
                            itemCount: _systemList.length,
                            itemBuilder: (context, index) {
                              OnCampusSystemModel item = _systemList[index];
                              return OnCampusSysListCard(
                                thisTitle: item.title,
                                thisId: item.id,
                                thisContent: item.content,
                                thisTarget: item.target,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
