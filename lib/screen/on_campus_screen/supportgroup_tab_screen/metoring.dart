import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCaGroupMentoring extends StatefulWidget {
  const OnCaGroupMentoring({super.key});

  @override
  State<OnCaGroupMentoring> createState() => _OnCaGroupMentoringState();
}

class _OnCaGroupMentoringState extends State<OnCaGroupMentoring> {
  List<OncaSupportGroupModel> _mentoringList = []; // 멘토링 리스트를 저장할 변수
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMentoringData(); // 멘토링 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadMentoringData() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<OncaSupportGroupModel> mentoringList =
          await OnCampusApi.getOncaSupportGroup(keyword: 'MENTORING');
      setState(() {
        _mentoringList = mentoringList;
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
              itemCount: _mentoringList.length,
              itemBuilder: (context, index) {
                final item = _mentoringList[index];
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
