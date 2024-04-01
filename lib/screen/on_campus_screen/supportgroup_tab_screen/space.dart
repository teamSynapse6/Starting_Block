// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_group_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class OnCaGroupSpace extends StatefulWidget {
  const OnCaGroupSpace({super.key});

  @override
  State<OnCaGroupSpace> createState() => _OnCaGroupSpaceState();
}

class _OnCaGroupSpaceState extends State<OnCaGroupSpace> {
  List<OnCaSpaceModel> _spaceList = []; // 공간 리스트를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadSpaceData(); // 공간 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadSpaceData() async {
    try {
      List<OnCaSpaceModel> spaceList = await OnCampusGroupApi.getOnCaSpace();
      setState(() {
        _spaceList = spaceList;
      });
    } catch (e) {
      print('공간 정보 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _spaceList.isEmpty
            ? Container()
            : ListView.builder(
                itemCount: _spaceList.length,
                itemBuilder: (context, index) {
                  final item = _spaceList[index];
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
