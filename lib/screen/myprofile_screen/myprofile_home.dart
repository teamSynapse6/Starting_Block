import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class MyProfileHome extends StatefulWidget {
  const MyProfileHome({super.key});

  @override
  State<MyProfileHome> createState() => _MyProfileHomeState();
}

class _MyProfileHomeState extends State<MyProfileHome>
    with SingleTickerProviderStateMixin {
  String _svgLogo = ""; // SVG 데이터를 저장할 변수
  String _nickName = "";
  String _schoolName = "";
  String _entrepreneurCheck = "사업자 등록 미완료"; // 사업자 등록 여부를 저장할 변수
  String _residenceName = ""; // 거주지 정보를 저장할 변수
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadNickName();
    _loadSvgLogo();
    _loadSchoolName();
    _loadEntrepreneurCheck();
    _loadResidenceName();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSvgLogo() async {
    String svgData = await OnCampusAPI.onCampusLogo();
    setState(() {
      _svgLogo = svgData;
    });
  }

  Future<void> _loadNickName() async {
    String nickName = await UserInfo.getNickName();
    setState(() {
      _nickName = nickName;
    });
  }

  Future<void> _loadSchoolName() async {
    String schoolName = await UserInfo.getSchoolName();
    setState(() {
      _schoolName = schoolName;
    });
  }

  Future<void> _loadEntrepreneurCheck() async {
    bool isEntrepreneur = await UserInfo.getEntrepreneurCheck();
    setState(() {
      _entrepreneurCheck = isEntrepreneur ? "등록 완료" : "등록 미완료";
    });
  }

  Future<void> _loadResidenceName() async {
    String residenceName = await UserInfo.getResidence();
    setState(() {
      _residenceName = residenceName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      appBar: const SettingAppBar(),
      body: Consumer<UserInfo>(
        builder: (context, userInfo, child) {
          if (userInfo.hasChanged) {
            _loadNickName();
            _loadSchoolName();
            _loadEntrepreneurCheck();
            _loadResidenceName();
            userInfo.resetChangeFlag(); // 데이터 로딩 후 플래그 리셋
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.white,
                height: 152,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 22),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nickName,
                            style: AppTextStyles.st2
                                .copyWith(color: AppColors.black),
                          ),
                          Gaps.v8,
                          Row(
                            children: [
                              _svgLogo.isNotEmpty
                                  ? SvgPicture.string(
                                      _svgLogo,
                                      fit: BoxFit.scaleDown,
                                      width: 18,
                                      height: 18,
                                    )
                                  : Container(),
                              Gaps.h5,
                              Text(
                                _schoolName,
                                style: AppTextStyles.bd4
                                    .copyWith(color: AppColors.g6),
                              ),
                            ],
                          ),
                          Gaps.v8,
                          Row(
                            children: [
                              Text(
                                _entrepreneurCheck,
                                style: AppTextStyles.bd4
                                    .copyWith(color: AppColors.g5),
                              ),
                              Text(
                                ' · ',
                                style: AppTextStyles.bd4
                                    .copyWith(color: AppColors.g5),
                              ),
                              Text(
                                '$_residenceName 거주',
                                style: AppTextStyles.bd4
                                    .copyWith(color: AppColors.g5),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileEditHome(),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 36,
                              child: Row(
                                children: [
                                  Text(
                                    '프로필 설정',
                                    style: AppTextStyles.bd4
                                        .copyWith(color: AppColors.g5),
                                  ),
                                  Gaps.h4,
                                  AppIcon.next_right_16
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            color: AppColors.g1,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: AppColors.g2,
                            ),
                          ),
                          child: AppIcon.profile_image_3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                color: AppColors.white,
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '내 질문'),
                    Tab(text: '내 답변'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    // '내 질문' 탭 내용
                    Center(
                      child: Text('내 질문 내용'),
                    ),
                    // '내 답변' 탭 내용
                    Center(
                      child: Text('내 답변 내용'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
