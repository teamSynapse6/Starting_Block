// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

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
    filteredSchoolList = List.from(schoolList);
    _schoolInfoController.addListener(_handleSchoolInputChange);
  }

  void _handleSchoolInputChange() {
    final query = _schoolInfoController.text;
    final nextFilteredSchoolList = _filterSchoolList(query);
    setState(() {
      _schoolInfo = query;
      filteredSchoolList = nextFilteredSchoolList;
    });
  }

  List<String> _filterSchoolList(String query) {
    if (query.isEmpty) {
      return List.from(schoolList);
    }
    return schoolList
        .where((school) => school.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _onSchoolTap(String selectedSchool) async {
    FocusScope.of(context).unfocus();
    _schoolInfoController.text = selectedSchool;
    setState(() {
      _schoolInfo = selectedSchool;
      filteredSchoolList = _filterSchoolList(selectedSchool);
    });
    await _saveSchoolName();
    await Future.delayed(const Duration(milliseconds: 500)).then((_) {
      if (!mounted) {
        return;
      }
      _onNextTap();
    });
  }

  Future<void> _saveSchoolName() async {
    await UserInfo().setSchoolName(_schoolInfo);
    await SaveUserData.loadFromLocalAndFetchToServer(
        inputSchoolName: _schoolInfo);
  }

  void _onNextTap() async {
    if (_schoolInfo.isEmpty) return;
    // 대학교명을 SharedPreferences에 저장
    await _saveSchoolName();
    if (!mounted) {
      return;
    }
    // 현재 화면을 pop하여 이전 화면으로 돌아감
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _schoolInfoController.removeListener(_handleSchoolInputChange);
    _schoolInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const BackAppBar(),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v20,
              Text(
                "대학교(원)을 선택해주세요",
                style: AppTextStyles.h5.copyWith(color: AppColors.g6),
              ),
              Gaps.v6,
              Text(
                "재학중인 학교에서 제공하는 지원 제도를 안내드릴 수 있어요",
                style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
              ),
              Gaps.v30,
              TextField(
                style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                controller: _schoolInfoController,
                decoration: InputDecoration(
                  hintText: "학교명을 입력해주세요",
                  hintStyle: AppTextStyles.bd2.copyWith(color: AppColors.g3),
                ),
              ),
              Gaps.v20,
              if (_schoolInfo.isNotEmpty &&
                  filteredSchoolList.isNotEmpty) // 조건 추가
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
                          onTap: () => _onSchoolTap(filteredSchoolList[index]),
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
                )
              else if (_schoolInfo.isNotEmpty && filteredSchoolList.isEmpty)
                Text(
                  "현재 수도권 대학만을 지원해요.\n입력하신 학교의 정보를 빠르게 제공하도록 노력할게요",
                  style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
