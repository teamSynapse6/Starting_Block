// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart'; // schoolList가 여기에 정의되어 있다고 가정

class OnCampusSchoolSearch extends StatefulWidget {
  const OnCampusSchoolSearch({super.key});

  @override
  State<OnCampusSchoolSearch> createState() => _OnCampusSchoolSearchState();
}

class _OnCampusSchoolSearchState extends State<OnCampusSchoolSearch> {
  final TextEditingController _schoolInfoController = TextEditingController();
  List<String> filteredSchoolList = [];
  String _schoolInfo = '';
  bool _isSchoolSelected = false; // 사용자가 리스트에서 학교를 선택했는지 추적

  @override
  void initState() {
    super.initState();
    _schoolInfoController.addListener(() {
      setState(() {
        _schoolInfo = _schoolInfoController.text;
        filterSearchResults(_schoolInfo);
        _isSchoolSelected = false; // 사용자가 입력을 변경하면 선택 상태를 초기화
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
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _schoolInfoController.text = selectedSchool;
      _schoolInfo = selectedSchool;
      _isSchoolSelected = true; // 사용자가 리스트에서 학교를 선택했음을 표시
    });
  }

  Future<void> _saveSchoolName() async {
    await UserInfo().setSchoolName(_schoolInfo);
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
    if (_schoolInfo.isEmpty) {
      return;
    } else if (_schoolInfo.isNotEmpty && _isSchoolSelected) {
      bool updateSuccess = await _saveUserInfoToServer();
      if (updateSuccess) {
        await _saveSchoolName();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const IntergrateScreen(
              switchIndex: SwitchIndex.toOne,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        print('에러 발생');
      }
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v40,
                  Text(
                    "대학교(원)을 선택해주세요",
                    style: AppTextStyles.h5.copyWith(color: AppColors.g6),
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
            if (_schoolInfo.isNotEmpty &&
                filteredSchoolList.isNotEmpty) // 조건 추가
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
              )
            else if (_schoolInfo.isNotEmpty && filteredSchoolList.isEmpty)
              Center(
                child: Text(
                  '현재 일부 대학의 지원 사업을 제공해드립니다',
                  style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
                ),
              )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 92,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: InkWell(
            onTap: _onNextTap,
            child: NextContained(
              disabled: !_isSchoolSelected,
              text: '완료하기',
            ),
          ),
        ),
      ),
    );
  }
}
