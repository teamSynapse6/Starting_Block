// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/on_campus_screen/widget/oncampus_notify_delegate.dart';

class OnCampusNotify extends StatefulWidget {
  const OnCampusNotify({super.key});

  @override
  State<OnCampusNotify> createState() => _OnCampusNotifyState();
}

class _OnCampusNotifyState extends State<OnCampusNotify> {
  String _svgLogo = ""; // SVG 데이터를 저장할 변수
  List<OnCampusNotifyModel> _notifyList = []; // 공고 데이터를 저장할 리스트

  @override
  void initState() {
    super.initState();
    _loadSvgLogo();
    _loadOnCampusNotify();
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

  // 공고 데이터를 불러오는 새로운 메서드
  Future<void> _loadOnCampusNotify() async {
    try {
      List<OnCampusNotifyModel> notifyList =
          await OnCampusAPI.getOnCampusNotify();
      setState(() {
        _notifyList = notifyList;
      });
    } catch (e) {
      print('공고 정보 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                      '지원 공고',
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
                              top: BorderSide(width: 2, color: AppColors.g1),
                              bottom: BorderSide(width: 2, color: AppColors.g1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '24개의 공고',
                                style: AppTextStyles.bd6
                                    .copyWith(color: AppColors.g4),
                              ),
                              const Spacer(), // 왼쪽 텍스트와 오른쪽 버튼 사이의 공간을 만듦
                              GestureDetector(
                                onTap: null,
                                child: Row(
                                  children: [
                                    const Text(
                                      '최신순',
                                      style: TextStyle(
                                          fontFamily: 'pretendard',
                                          fontSize: 14,
                                          color: AppColors.g4),
                                    ), // 현재 선택된 값으로 텍스트 업데이트
                                    AppIcon.down,
                                  ],
                                ),
                              ),
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
        body: SingleChildScrollView(
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
                    OnCampusNotifyModel notify = _notifyList[index];
                    return OnCampusNotifyListCard(
                      thisProgramText: notify.type,
                      thisId: notify.id,
                      thisTitle: notify.title,
                      thisStartDate: notify.stardate,
                      thisUrl: notify.detailurl,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
