// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_group_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class OnCaGroupEtc extends StatefulWidget {
  const OnCaGroupEtc({super.key});

  @override
  State<OnCaGroupEtc> createState() => _OnCaGroupEtcState();
}

class _OnCaGroupEtcState extends State<OnCaGroupEtc> {
  List<OnCaEtcModel> _etcList = []; // '기타' 리스트를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadEtcData(); // '기타' 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadEtcData() async {
    try {
      List<OnCaEtcModel> etcList = await OnCampusGroupApi.getOnCaEtc();
      setState(() {
        _etcList = etcList;
      });
    } catch (e) {
      print('기타 정보 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      body: _etcList.isEmpty
          ? Container()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _etcList.length,
              itemBuilder: (context, index) {
                final item = _etcList[index];
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
