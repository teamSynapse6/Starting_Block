// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart'; // schoolList가 여기에 정의되어 있다고 가정

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  final TextEditingController _schoolInfoController = TextEditingController();
  List<String> filteredSchoolList = [];
  String _schoolInfo = '';

  @override
  void initState() {
    super.initState();
    _schoolInfoController.addListener(() {
      setState(() {
        _schoolInfo = _schoolInfoController.text;
        filterSearchResults(_schoolInfo);
      });
    });
    filteredSchoolList = List.from(schoolList);
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> tempList = schoolList
          .where((school) => school.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        filteredSchoolList = tempList;
      });
    } else {
      setState(() {
        filteredSchoolList = List.from(schoolList);
      });
    }
  }

  void _onSchoolTap(String selectedSchool) async {
    setState(() {
      _schoolInfoController.text = selectedSchool;
      _schoolInfo = selectedSchool;
    });
    bool updateSuccess = await _saveUserInfoToServer();
    if (updateSuccess) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        _onNextTap();
      });
    } else {
      print('에러 발생');
    }
  }

  Future<void> _saveSchoolName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userSchoolName', _schoolInfo);
  }

  Future<void> _skipSchoolName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userSchoolName', '');
  }

  Future<bool> _saveUserInfoToServer() async {
    String nickName = await UserInfo.getNickName();
    bool isEnterpreneurCheck = await UserInfo.getEntrepreneurCheck();
    String residence = await UserInfo.getResidence();
    String university = _schoolInfo;
    String birth = await UserInfo.getUserBirthday();
    String formattedBirth =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(birth));

    return await UserInfoManageApi.patchUserInfo(
      nickname: nickName,
      birth: formattedBirth,
      isCompletedBusinessRegistration: isEnterpreneurCheck,
      residence: residence,
      university: university,
    );
  }

  void _onNextTap() async {
    if (_schoolInfo.isEmpty) return;
    await _saveSchoolName();
    // 다음 화면으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RoadmapScreen(),
      ),
    );
  }

  void _onSkipTap() async {
    bool updateSuccess = await _saveUserInfoToServer();
    if (updateSuccess) {
      await _skipSchoolName();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const RoadmapScreen(),
        ),
      );
    } else {
      print('에러 발생');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const BackAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OnBoardingState(thisState: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v52,
                  Text(
                    "대학교(원)을 선택해주세요",
                    style: AppTextStyles.h5.copyWith(color: AppColors.g6),
                  ),
                  Gaps.v10,
                  Text(
                    "현재 일부 대학의 교내 지원 사업을 제공해 드립니다",
                    style: AppTextStyles.bd6.copyWith(color: AppColors.g6),
                  ),
                  Gaps.v32,
                  TextField(
                    style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                    controller: _schoolInfoController,
                    decoration: InputDecoration(
                      hintText: "학교명을 입력해주세요",
                      hintStyle:
                          AppTextStyles.bd2.copyWith(color: AppColors.g3),
                    ),
                  ),
                  Gaps.v20,
                ],
              ),
            ),
            if (_schoolInfo.isNotEmpty) // 조건 추가
              ListView.separated(
                shrinkWrap: true,
                itemCount: filteredSchoolList.length > 3
                    ? 3
                    : filteredSchoolList.length,
                separatorBuilder: (context, index) => Gaps.v4,
                itemBuilder: (context, index) {
                  return Ink(
                    height: 32,
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: () => _onSchoolTap(filteredSchoolList[index]),
                      highlightColor: AppColors.bluebg,
                      splashColor: AppColors.bluebg,
                      child: Row(
                        children: [
                          Gaps.h24,
                          Text(
                            filteredSchoolList[index],
                            style:
                                AppTextStyles.bd4.copyWith(color: AppColors.g6),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 92,
          color: AppColors.white,
          child: Ink(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
            child: InkWell(
              onTap: _onSkipTap,
              child: Center(
                child: Text(
                  '다음에 설정',
                  style: AppTextStyles.btn1.copyWith(color: AppColors.g5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
