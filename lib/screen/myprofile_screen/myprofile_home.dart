import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class MyProfileHome extends StatefulWidget {
  const MyProfileHome({super.key});

  @override
  State<MyProfileHome> createState() => _MyProfileHomeState();
}

class _MyProfileHomeState extends State<MyProfileHome>
    with SingleTickerProviderStateMixin {
  String _nickName = "";
  String _schoolName = "";
  String _entrepreneurCheck = "사업자 등록 미완료"; // 사업자 등록 여부를 저장할 변수
  String _residenceName = ""; // 거주지 정보를 저장할 변수
  int _selectedProfileIcon = 1; // 현재 선택된 프로필 아이콘을 저장하는 위젯 변수
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    String nickName = await UserInfo.getNickName();
    String schoolName = await UserInfo.getSchoolName();
    bool isEntrepreneur = await UserInfo.getEntrepreneurCheck();
    String residenceName = await UserInfo.getResidence();
    int selectedIconIndex = await UserInfo.getSelectedIconIndex();
    setState(() {
      _nickName = nickName;
      _schoolName = schoolName;
      _entrepreneurCheck = isEntrepreneur ? "사업자 등록 완료" : "사업자 등록 미완료";
      _residenceName = residenceName;
      _selectedProfileIcon = selectedIconIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const SettingAppBar(),
      body: Consumer<UserInfo>(
        builder: (context, userInfo, child) {
          if (userInfo.hasChanged) {
            _loadUserData();
            userInfo.resetChangeFlag(); // 데이터 로딩 후 플래그 리셋
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.white,
                height: 166,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 22),
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
                          if (_schoolName.isNotEmpty)
                            Column(
                              children: [
                                Gaps.v8,
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: SchoolLogoWidget(
                                        userSchoolNameInput: _schoolName,
                                      ),
                                    ),
                                    Gaps.h5,
                                    Text(
                                      _schoolName,
                                      style: AppTextStyles.bd4
                                          .copyWith(color: AppColors.g6),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          Gaps.v8,
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: AppColors.g1,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    '$_residenceName 거주',
                                    style: AppTextStyles.btn2
                                        .copyWith(color: AppColors.blue),
                                  ),
                                ),
                              ),
                              Gaps.h8,
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: AppColors.g1,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    _entrepreneurCheck,
                                    style: AppTextStyles.btn2
                                        .copyWith(color: AppColors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileEditHome(),
                                ),
                              );
                              _loadUserData();
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
                          child: ProfileIconWidget(
                              iconIndex: _selectedProfileIcon),
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
                    Tab(text: '내 궁금해요'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: const [
                    MyProfileMyQuestion(),
                    MyProfileMyAnswerReply(),
                    MyProfileMyHeart(),
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
