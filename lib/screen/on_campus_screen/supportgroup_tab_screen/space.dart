import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCaGroupSpace extends StatefulWidget {
  const OnCaGroupSpace({super.key});

  @override
  State<OnCaGroupSpace> createState() => _OnCaGroupSpaceState();
}

class _OnCaGroupSpaceState extends State<OnCaGroupSpace> {
  List<OncaSupportGroupModel> _spaceList = []; // 공간 리스트를 저장할 변수
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSpaceData(); // 공간 데이터를 로드하는 메서드를 호출합니다.
  }

  Future<void> _loadSpaceData() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<OncaSupportGroupModel> spaceList =
          await OnCampusApi.getOncaSupportGroup(keyword: 'SPACE');
      setState(() {
        _spaceList = spaceList;
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
              itemCount: _spaceList.length,
              itemBuilder: (context, index) {
                final item = _spaceList[index];
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
