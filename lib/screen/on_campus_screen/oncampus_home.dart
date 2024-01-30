// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnCampusHome extends StatefulWidget {
  const OnCampusHome({super.key});

  @override
  State<OnCampusHome> createState() => _OnCampusHomeState();
}

class _OnCampusHomeState extends State<OnCampusHome> {
  String _schoolName = "";
  String _svgLogo = ""; // SVG 데이터를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadSchoolName();
    _loadSvgLogo();
  }

  Future<void> _loadSchoolName() async {
    String schoolName = await UserInfo.getSchoolName();
    setState(() {
      _schoolName = schoolName;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OnCampusSearchAppBar(
        searchTapScreen: null,
        thisBackGroundColor: AppColors.bluebg,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 274,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [244 / 272, 244 / 272], // 색상 변경 지점을 정의합니다.
                colors: [
                  AppColors.bluebg, // 0부터 324/272까지
                  AppColors.white, // 324/272부터 272/272까지
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v16,
                  Row(
                    children: [
                      _svgLogo.isNotEmpty
                          ? SvgPicture.string(
                              _svgLogo,
                              fit: BoxFit.scaleDown,
                            )
                          : Container(), // SVG 이미지가 로드되지 않았을 경우 빈 컨테이너 표시
                      Gaps.h4,
                      Text(
                        _schoolName,
                        style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                      ),
                      Gaps.h8,
                      Container(
                        height: 24,
                        width: 151,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "교내 창업 지원의 통합 확인",
                            style: AppTextStyles.bd6
                                .copyWith(color: AppColors.bluedeep),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.v28,
                  const OnCampusCardLarge(),
                  Gaps.v12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * (152 / 360),
                        child: const OnCampusCardMedium(),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * (72 / 360),
                        child: const OnCampusCardSmallSystem(),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * (72 / 360),
                        child: const OnCampusCardSmallClass(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Gaps.v48,
          Text(
            '최신 교내 지원 사업',
            style: AppTextStyles.st2.copyWith(color: AppColors.g6),
          ),
        ],
      ),
    );
  }
}
