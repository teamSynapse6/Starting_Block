// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart'; // schoolList가 여기에 정의되어 있다고 가정

class SchoolNameEdit extends StatefulWidget {
  const SchoolNameEdit({super.key});

  @override
  State<SchoolNameEdit> createState() => _SchoolNameEditState();
}

class _SchoolNameEditState extends State<SchoolNameEdit> {
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

  void _onSchoolTap(String selectedSchool) {
    setState(() {
      _schoolInfoController.text = selectedSchool;
      _schoolInfo = selectedSchool;
      filteredSchoolList = List.from(schoolList);
    });
  }

  Future<void> _saveSchoolName() async {
    // Provider를 사용하여 UserInfo 인스턴스에 접근
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    await userInfo.setSchoolName(_schoolInfo);
  }

  void _onNextTap() async {
    if (_schoolInfo.isEmpty) return;
    // 대학교명을 SharedPreferences에 저장
    await _saveSchoolName();
    // 현재 화면을 pop하여 이전 화면으로 돌아감
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v40,
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
                controller: _schoolInfoController,
                decoration: const InputDecoration(hintText: "학교명을 입력해주세요"),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filteredSchoolList.length > 3
                      ? 3
                      : filteredSchoolList.length, // 최대 3개만 표시
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        filteredSchoolList[index],
                        style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                      ),
                      onTap: () => _onSchoolTap(filteredSchoolList[index]),
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
                    text: "저장",
                    disabled: _schoolInfo.isEmpty,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
