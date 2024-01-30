import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_manage.dart';
import 'package:starting_block/screen/manage/models/oncampus_system_model.dart';

class OnCampusSystem extends StatefulWidget {
  const OnCampusSystem({super.key});

  @override
  State<OnCampusSystem> createState() => _OnCampusSystemState();
}

class _OnCampusSystemState extends State<OnCampusSystem> {
  String _svgLogo = ""; // SVG 데이터를 저장할 변수
  List<OnCampusSystemModel> _systemList = []; // OnCampusSystemModel의 리스트

  @override
  void initState() {
    super.initState();
    _loadSvgLogo();
    _loadOnCampusSystem(); // 학사 제도 정보를 로드하는 함수 호출
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

  Future<void> _loadOnCampusSystem() async {
    try {
      List<OnCampusSystemModel> systemList =
          await OnCampusAPI.getOnCampusSystem();
      setState(() {
        _systemList = systemList;
      });
    } catch (e) {
      print('학사 제도 정보 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              snap: true,
              floating: true,
              elevation: 0,
              forceElevated: innerBoxIsScrolled,
              backgroundColor: AppColors.g1,
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
                        '창업 관련 학사 제도',
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
                      ));
                },
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true, // 스크롤뷰 내부의 리스트뷰에 필요
                  physics: const NeverScrollableScrollPhysics(), // 중첩 스크롤 문제 방지
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
    );
  }
}
