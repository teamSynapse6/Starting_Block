// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCaGroupCamp extends StatefulWidget {
  const OnCaGroupCamp({super.key});

  @override
  State<OnCaGroupCamp> createState() => _OnCaGroupCampState();
}

class _OnCaGroupCampState extends State<OnCaGroupCamp> {
  List<OncaSupportGroupModel> _clubList = []; // 동아리 리스트를 저장할 변수
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClubData(); // 동아리 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadClubData() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<OncaSupportGroupModel> clubList =
          await OnCampusApi.getOncaSupportGroup(keyword: 'CAMP');
      setState(() {
        _clubList = clubList;
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
              itemCount: _clubList.length,
              itemBuilder: (context, index) {
                final item = _clubList[index];
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
