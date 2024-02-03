import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_api_group_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';

class OnCaGroupLecture extends StatefulWidget {
  const OnCaGroupLecture({super.key});

  @override
  State<OnCaGroupLecture> createState() => _OnCaGroupLectureState();
}

class _OnCaGroupLectureState extends State<OnCaGroupLecture> {
  List<OnCaLectureModel> _lectureList = []; // 강연 리스트를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadLectureData(); // 강연 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadLectureData() async {
    try {
      List<OnCaLectureModel> lectureList =
          await OnCampusGroupApi.getOnCaLecture();
      setState(() {
        _lectureList = lectureList;
      });
    } catch (e) {
      print('강연 정보 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _lectureList.isEmpty
            ? const Center(
                child:
                    CircularProgressIndicator()) // 데이터 로딩 중이거나 실패했을 때를 대비한 처리
            : ListView.builder(
                itemCount: _lectureList.length,
                itemBuilder: (context, index) {
                  final item = _lectureList[index];
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
