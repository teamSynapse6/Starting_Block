import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class ProfileEditHome extends StatefulWidget {
  const ProfileEditHome({super.key});

  @override
  State<ProfileEditHome> createState() => _ProfileEditHomeState();
}

class _ProfileEditHomeState extends State<ProfileEditHome> {
  String _nickName = "";
  String _schoolName = "";
  String _entrepreneurCheck = "사업자 등록 미완료"; // 사업자 등록 여부를 저장할 변수
  String _residenceName = ""; // 거주지 정보를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadNickName();
    _loadSchoolName();
    _loadEntrepreneurCheck();
    _loadResidenceName();
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
      appBar: const BackAppBar(),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v24,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '프로필 수정',
                      style: AppTextStyles.st1.copyWith(color: AppColors.black),
                    ),
                  ),
                  Gaps.v32,
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.g1,
                      ),
                      child: AppIcon.profile_image_3,
                    ),
                  ),
                  Gaps.v4,
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 88,
                      height: 32,
                      child: Center(
                        child: Text(
                          "아이콘 변경",
                          style: AppTextStyles.btn1.copyWith(
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gaps.v24,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '닉네임',
                      style: AppTextStyles.bd5.copyWith(color: AppColors.g6),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SchoolNameEdit()),
                      );
                    },
                    child: SizedBox(
                      height: 56,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _nickName,
                              style: AppTextStyles.bd2
                                  .copyWith(color: AppColors.g6),
                            ),
                            const Spacer(),
                            AppIcon.next_20,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gaps.v8,
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CustomDividerH1G1(),
                  ),
                  Gaps.v16,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '학교',
                      style: AppTextStyles.bd5.copyWith(color: AppColors.g6),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SchoolNameEdit()),
                      );
                    },
                    child: SizedBox(
                      height: 56,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _schoolName,
                              style: AppTextStyles.bd2
                                  .copyWith(color: AppColors.g6),
                            ),
                            const Spacer(),
                            AppIcon.next_20,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gaps.v8,
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CustomDividerH1G1(),
                  ),
                  Gaps.v16,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '주민등록상 거주지',
                      style: AppTextStyles.bd5.copyWith(color: AppColors.g6),
                    ),
                  ),
                  InkWell(
                    onTap: null,
                    child: SizedBox(
                      height: 56,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _residenceName,
                              style: AppTextStyles.bd2
                                  .copyWith(color: AppColors.g6),
                            ),
                            const Spacer(),
                            AppIcon.next_20,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gaps.v8,
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CustomDividerH1G1(),
                  ),
                  Gaps.v16,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '사업자 등록 여부',
                      style: AppTextStyles.bd5.copyWith(color: AppColors.g6),
                    ),
                  ),
                  SizedBox(
                    height: 56,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '등록 완료',
                            style:
                                AppTextStyles.bd2.copyWith(color: AppColors.g6),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Gaps.v8
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
