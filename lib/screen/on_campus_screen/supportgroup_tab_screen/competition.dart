import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_api_group_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';

class OnCaGroupCompetition extends StatefulWidget {
  const OnCaGroupCompetition({super.key});

  @override
  State<OnCaGroupCompetition> createState() => _OnCaGroupCompetitionState();
}

class _OnCaGroupCompetitionState extends State<OnCaGroupCompetition> {
  List<OnCaCompetitionModel> _competitionList = []; // 경진대회 리스트를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadCompetitionData(); // 경진대회 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadCompetitionData() async {
    try {
      List<OnCaCompetitionModel> competitionList =
          await OnCampusGroupApi.getOnCaCompetition();
      setState(() {
        _competitionList = competitionList;
      });
    } catch (e) {
      print('경진대회 정보 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _competitionList.isEmpty
            ? const Center(
                child:
                    CircularProgressIndicator()) // 데이터 로딩 중이거나 실패했을 때를 대비한 처리
            : ListView.builder(
                itemCount: _competitionList.length,
                itemBuilder: (context, index) {
                  final item = _competitionList[index];
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
