// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCaGroupLecture extends StatefulWidget {
  const OnCaGroupLecture({super.key});

  @override
  State<OnCaGroupLecture> createState() => _OnCaGroupLectureState();
}

class _OnCaGroupLectureState extends State<OnCaGroupLecture> {
  List<OncaSupportGroupModel> _lectureList = []; // 강연 리스트를 저장할 변수
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLectureData(); // 강연 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadLectureData() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<OncaSupportGroupModel> lectureList =
          await OnCampusApi.getOncaSupportGroup(keyword: 'LECTURE');
      setState(() {
        _lectureList = lectureList;
        isLoading = false;
      });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      body: isLoading
          ? const OncaSkeletonSupportGroup()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _lectureList.length,
              itemBuilder: (context, index) {
                final item = _lectureList[index];
                return Column(
                  children: [
                    if (index == 0) Gaps.v16,
                    OnCampusGroupList(
                      thisTitle: item.title,
                      thisContent: item.content,
                    ),
                    Gaps.v16,
                  ],
                );
              },
            ),
    );
  }
}
