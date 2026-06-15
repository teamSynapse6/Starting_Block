// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class ProfileEditHome extends StatefulWidget {
  const ProfileEditHome({super.key});

  @override
  State<ProfileEditHome> createState() => _ProfileEditHomeState();
}

class _ProfileEditHomeState extends State<ProfileEditHome> {
  String _nickName = "";
  String _birthDay = "";
  String _schoolName = "";
  String _entrepreneurCheck = "사업자 등록 미완료";
  String _residenceName = "";
  int _iconIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    _loadNickName();
    _loadBirthDay();
    _loadSchoolName();
    _loadEntrepreneurCheck();
    _loadResidenceName();
    _loadSelectedProfileIcon(); // 프로필 아이콘 로드
  }

  Future<void> _loadNickName() async {
    String nickName = await UserInfo.getNickName();
    if (!mounted) {
      return;
    }
    setState(() {
      _nickName = nickName;
    });
  }

  Future<void> _loadBirthDay() async {
    String birthDay = await UserInfo.getUserBirthday();
    if (!mounted) {
      return;
    }
    if (birthDay.length == 8) {
      String formattedBirthDay =
          "${birthDay.substring(0, 4)}.${birthDay.substring(4, 6)}.${birthDay.substring(6, 8)}";
      setState(() {
        _birthDay = formattedBirthDay;
      });
    } else {
      setState(() {
        _birthDay = birthDay;
      });
    }
  }

  Future<void> _loadSchoolName() async {
    String schoolName = await UserInfo.getSchoolName();
    if (!mounted) {
      return;
    }
    setState(() {
      _schoolName = schoolName;
    });
  }

  Future<void> _loadEntrepreneurCheck() async {
    bool isEntrepreneur = await UserInfo.getEntrepreneurCheck();
    if (!mounted) {
      return;
    }
    setState(() {
      _entrepreneurCheck = isEntrepreneur ? "등록 완료" : "등록 미완료";
    });
  }

  Future<void> _loadResidenceName() async {
    String residenceName = await UserInfo.getResidence();
    if (!mounted) {
      return;
    }
    setState(() {
      _residenceName = residenceName;
    });
  }

  Future<void> _loadSelectedProfileIcon() async {
    int selectedIconIndex = await UserInfo.getSelectedIconIndex();
    if (!mounted) {
      return;
    }
    setState(() {
      _iconIndex = selectedIconIndex;
    });
  }

  bool _isUnregisteredValue(String value) {
    return value.trim().isEmpty || value.trim().toLowerCase() == 'null';
  }

  Widget _profileValueText(String value) {
    if (_isUnregisteredValue(value)) {
      return Text(
        "미등록",
        style: AppTextStyles.bd2.copyWith(color: AppColors.g4),
      );
    }

    return Text(
      value,
      style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: SingleChildScrollView(
        child: Consumer<UserInfo>(
          builder: (context, userInfo, child) {
            if (userInfo.hasChanged) {
              _loadUserInfo();
              userInfo.resetChangeFlag(); // 데이터 로딩 후 플래그 리셋
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '프로필 수정',
                    style: AppTextStyles.h5.copyWith(color: AppColors.g6),
                  ),
                ),
                Gaps.v32,
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.g1,
                      border: Border.all(
                        width: 1,
                        color: AppColors.g2,
                      ),
                    ),
                    child: ProfileIconWidget(iconIndex: _iconIndex),
                  ),
                ),
                Gaps.v4,
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      if (!mounted) return;
                      await Navigator.push(
                        context,
                        trackedRoute(
                            builder: (context) => const ProfileIconEdit()),
                      );
                      if (!mounted) return;
                      _loadUserInfo();
                    },
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
                ),
                Gaps.v24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '닉네임',
                    style: AppTextStyles.bd5.copyWith(color: AppColors.g6),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (!mounted) return;
                    await Navigator.push(
                      context,
                      trackedRoute(builder: (context) => const NickNameEdit()),
                    );
                    if (!mounted) return;
                    _loadUserInfo();
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
                            style:
                                AppTextStyles.bd2.copyWith(color: AppColors.g6),
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
                    '생년월일',
                    style: AppTextStyles.bd5.copyWith(color: AppColors.g6),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (!mounted) return;
                    await Navigator.push(
                      context,
                      trackedRoute(builder: (context) => const BirthdayEdit()),
                    );
                    if (!mounted) return;
                    _loadUserInfo();
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
                          _profileValueText(_birthDay),
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
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (!mounted) return;
                    await Navigator.push(
                      context,
                      trackedRoute(
                          builder: (context) => const SchoolNameEdit()),
                    );
                    if (!mounted) return;
                    _loadUserInfo();
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
                          _schoolName.isNotEmpty
                              ? Text(
                                  _schoolName,
                                  style: AppTextStyles.bd2
                                      .copyWith(color: AppColors.g6),
                                )
                              : Text(
                                  "미등록",
                                  style: AppTextStyles.bd2
                                      .copyWith(color: AppColors.g4),
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
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (!mounted) return;
                    await Navigator.push(
                      context,
                      trackedRoute(builder: (context) => const ResidenceEdit()),
                    );
                    if (!mounted) return;
                    _loadUserInfo();
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
                          _profileValueText(_residenceName),
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
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (!mounted) return;
                    await Navigator.push(
                      context,
                      trackedRoute(
                          builder: (context) => const EnterprenutEdit()),
                    );
                    if (!mounted) return;
                    _loadUserInfo();
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
                            _entrepreneurCheck,
                            style:
                                AppTextStyles.bd2.copyWith(color: AppColors.g6),
                          ),
                          const Spacer(),
                          AppIcon.next_20,
                        ],
                      ),
                    ),
                  ),
                ),
                Gaps.v20
              ],
            );
          },
        ),
      ),
    );
  }
}
