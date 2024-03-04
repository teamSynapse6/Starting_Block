// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart'; // schoolList가 여기에 정의되어 있다고 가정

class OnCampusSchoolSet extends StatefulWidget {
  const OnCampusSchoolSet({super.key});

  @override
  State<OnCampusSchoolSet> createState() => _OnCampusSchoolSetState();
}

class _OnCampusSchoolSetState extends State<OnCampusSchoolSet> {
  final TextEditingController _schoolInfoController = TextEditingController();
  List<String> filteredSchoolList = [];
  String _schoolInfo = "";

  @override
  void initState() {
    super.initState();
    _schoolInfoController.addListener(() {
      setState(() {
        _schoolInfo = _schoolInfoController.text;
        filterSearchResults(_schoolInfo);
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // UserInfo에서 학교 이름이 설정되었는지 확인합니다.
      String schoolName = await UserInfo.getSchoolName();
      if (schoolName.isEmpty) {
        // 학교 이름이 설정되지 않았다면, OnCampusSetNotify 화면으로 이동합니다.
        _navigateToOnCampusSetNotify(context);
      }
      // 설정되었다면, 아무것도 하지 않습니다. 사용자는 OnCampusSchoolSet 화면에 남아있습니다.
    });
  }

  void _navigateToOnCampusSetNotify(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnCampusSetNotify(),
      ),
    );
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

  void _onSchoolTap(String selectedSchool) {
    setState(() {
      _schoolInfoController.text = selectedSchool;
      _schoolInfo = selectedSchool;
    });
  }

  Future<void> _saveSchoolName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userSchoolName', _schoolInfo);
  }

  void _onNextTap() async {
    if (_schoolInfo.isEmpty) return;
    await _saveSchoolName();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const IntergrateScreen(
                switchIndex: SwitchIndex.toOne,
              )),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v96,
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
                    hintStyle: AppTextStyles.bd2.copyWith(color: AppColors.g3),
                  ),
                ),
                Gaps.v20,
                if (_schoolInfo.isNotEmpty) // 조건 추가
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredSchoolList.length > 3
                          ? 3
                          : filteredSchoolList.length, // 최대 3개만 표시
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 32,
                          child: InkWell(
                            onTap: () =>
                                _onSchoolTap(filteredSchoolList[index]),
                            highlightColor: AppColors.bluebg,
                            splashColor: AppColors.bluebg,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                filteredSchoolList[index],
                                style: AppTextStyles.bd4
                                    .copyWith(color: AppColors.g6),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: GestureDetector(
                    onTap: _onNextTap,
                    child: NextContained(
                      text: "다음",
                      disabled: _schoolInfo.isEmpty,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
