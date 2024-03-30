// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_group_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class OnCaGroupMentoring extends StatefulWidget {
  const OnCaGroupMentoring({super.key});

  @override
  State<OnCaGroupMentoring> createState() => _OnCaGroupMentoringState();
}

class _OnCaGroupMentoringState extends State<OnCaGroupMentoring> {
  List<OnCaMentoringModel> _mentoringList = []; // 멘토링 리스트를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadMentoringData(); // 멘토링 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadMentoringData() async {
    try {
      List<OnCaMentoringModel> mentoringList =
          await OnCampusGroupApi.getOnCaMentoring();
      setState(() {
        _mentoringList = mentoringList;
      });
    } catch (e) {
      print('멘토링 정보 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _mentoringList.isEmpty
            ? const Center(
                child:
                    CircularProgressIndicator()) // 데이터 로딩 중이거나 실패했을 때를 대비한 처리
            : ListView.builder(
                itemCount: _mentoringList.length,
                itemBuilder: (context, index) {
                  final item = _mentoringList[index];
                  return OnCampusGroupList(
                    thisTitle: item.title,
                    thisContent: item.content,
                  );
                },
              ),
      ),
    );
  }
}
