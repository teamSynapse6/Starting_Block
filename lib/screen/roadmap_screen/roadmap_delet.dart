import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/screen/roadmap_screen/widget/delete_list.dart';

class RoadMapDelete extends StatefulWidget {
  const RoadMapDelete({super.key});

  @override
  State<RoadMapDelete> createState() => _RoadMapDeleteState();
}

class _RoadMapDeleteState extends State<RoadMapDelete> {
  int? selectedDeleteIndex; // 선택된 삭제 항목의 인덱스
  List<RoadMapModel>? roadMaps;

  @override
  void initState() {
    super.initState();
    loadRoadMaps();
  }

  void loadRoadMaps() async {
    final roadMapList = await RoadMapApi.getRoadMapList();
    roadMapList
        .sort((a, b) => a.sequence.compareTo(b.sequence)); // sequence에 따라 정렬
    setState(() {
      roadMaps = roadMapList;
    });
  }

  void _thisDeleteTap(int roadmapId) {
    // 다이얼로그를 표시
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogComponent(
          title: '단계를 삭제하겠습니까?',
          description: '단계 내에 저장한 지원 사업까지 삭제됩니다',
          rightActionText: '삭제',
          rightActionTap: () async {
            Navigator.of(context).pop(); // 다이얼로그 닫기
            try {
              // 로드맵 삭제 실행
              await RoadMapApi.deleteRoadMap(roadmapId.toString());
              // 삭제 후 로드맵 리스트 재로딩
              loadRoadMaps();
            } catch (e) {
              // 오류 발생 시 사용자에게 알림
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('로드맵 삭제 중 오류가 발생했습니다: $e')),
              );
            }
          },
        );
      },
    ).then((_) {
      setState(() {
        selectedDeleteIndex = null; // 선택된 삭제 인덱스 초기화
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CloseAppBar(
        state: true,
      ),
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
                  '단계를 삭제할까요?',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.g6,
                  ),
                ),
                Gaps.v50,
              ],
            ),
          ),
          Expanded(
            child: roadMaps != null
                ? ListView.builder(
                    itemCount: roadMaps!.length,
                    itemBuilder: (context, index) {
                      final roadMap = roadMaps![index];
                      return DeleteList(
                        thisText: roadMap.title,
                        thisTap: () {
                          _thisDeleteTap(roadMap.roadmapId);
                          setState(() {
                            selectedDeleteIndex = index;
                          });
                        },
                        thisBackgroundColor: selectedDeleteIndex == index
                            ? AppColors.g1
                            : AppColors.white,
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
