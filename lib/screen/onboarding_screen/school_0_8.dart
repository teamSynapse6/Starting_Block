// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
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
    _schoolInfoController.text = selectedSchool;
    setState(() {
      _schoolInfo = selectedSchool;
      filteredSchoolList = _filterSchoolList(selectedSchool);
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }
      _onNextTap();
    });
  }

  Future<void> _saveSchoolName() async {
    UserInfo().setSchoolName(_schoolInfo);
  }

  Future<void> _skipSchoolName() async {
    UserInfo().setSchoolName('');
  }

  void _onNextTap() async {
    if (_schoolInfo.isEmpty) return;
    await _saveSchoolName();
    if (!mounted) {
      return;
    }
    // 다음 화면으로 이동
    Navigator.of(context).push(
      trackedRoute(
        builder: (context) => const RoadmapScreen(),
      ),
    );
  }

  void _onSkipTap() async {
    await _skipSchoolName();
    if (!mounted) {
      return;
    }
    Navigator.of(context).push(
      trackedRoute(
        builder: (context) => const RoadmapScreen(),
      ),
    );
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
                    "대학교(원)을 선택해 주세요",
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
                      hintStyle:
                          AppTextStyles.bd2.copyWith(color: AppColors.g3),
                    ),
                  ),
                  Gaps.v20,
                ],
              ),
            ),
            if (_schoolInfo.isNotEmpty && filteredSchoolList.isNotEmpty)
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "'현재 수도권 대학만을 지원해요.\n입력하신 학교의 정보를 빠르게 제공하도록 노력할게요'",
                  style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
                ),
              )
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
                  '다음에 설정하기',
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
