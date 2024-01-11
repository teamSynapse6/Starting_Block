import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/widget/delete_list.dart';

class RoadMapDelete extends StatefulWidget {
  const RoadMapDelete({super.key});

  @override
  State<RoadMapDelete> createState() => _RoadMapDeleteState();
}

class _RoadMapDeleteState extends State<RoadMapDelete> {
  int? selectedDeleteIndex; // 선택된 삭제 항목의 인덱스

  void _thisDeleteTap(int index) {
    setState(() {
      selectedDeleteIndex = index;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogComponent(
          title: '단계를 삭제하겠습니까?',
          description: '단계 내에 저장한 지원 사업까지 삭제됩니다',
          rightActionText: '삭제',
          rightActionTap: () {
            final roadmapModel =
                Provider.of<RoadMapModel>(context, listen: false);
            roadmapModel.removeAt(selectedDeleteIndex!); // 삭제 로직
            Navigator.pop(context); // Dialog 닫기
          },
        );
      },
    ).then((_) {
      setState(() {
        selectedDeleteIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final roadmapModel = Provider.of<RoadMapModel>(context);
    final roadmapList = roadmapModel.roadmapList;

    return Scaffold(
      appBar: const CloseAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v22,
                Text(
                  '로드맵 단계 삭제',
                  style: AppTextStyles.h5.copyWith(color: AppColors.black),
                ),
                Gaps.v50,
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: roadmapList.length,
              itemBuilder: (context, index) {
                return DeleteList(
                  thisText: roadmapList[index],
                  thisTap: () => _thisDeleteTap(index),
                  thisBackgroundColor: selectedDeleteIndex == index
                      ? AppColors.g2
                      : AppColors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
