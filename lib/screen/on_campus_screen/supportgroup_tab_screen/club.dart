// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_group_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class OnCaGroupClub extends StatefulWidget {
  const OnCaGroupClub({super.key});

  @override
  State<OnCaGroupClub> createState() => _OnCaGroupClubState();
}

class _OnCaGroupClubState extends State<OnCaGroupClub> {
  List<OnCaClubModel> _clubList = []; // 동아리 리스트를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadClubData(); // 동아리 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadClubData() async {
    try {
      List<OnCaClubModel> clubList = await OnCampusGroupApi.getOnCaClub();
      setState(() {
        _clubList = clubList;
      });
    } catch (e) {
      print('동아리 정보 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      body: _clubList.isEmpty
          ? Container()
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
