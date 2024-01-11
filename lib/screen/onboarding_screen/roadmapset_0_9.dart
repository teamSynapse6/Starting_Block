import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON 인코딩/디코딩을 위해 추가

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  // 항상 초기 리스트를 사용합니다.
  List<String> roadmapItems = [
    '창업 교육',
    '아이디어 창출',
    '공간 마련',
    '사업 계획서',
    'R&D / 시제품 제작',
    '사업 검증',
    'IR Deck 작성',
    '자금 확보',
    '사업화',
  ];

  Future<void> _saveRoadmapItems() async {
    final prefs = await SharedPreferences.getInstance();
    String roadmapItemsString = json.encode(roadmapItems);
    await prefs.setString('roadmapList', roadmapItemsString);
  }

  void _onNextTap() async {
    await _saveRoadmapItems();

    // Navigator.of(context) 호출 전에 현재 위젯이 위젯 트리에 여전히 있는지 확인
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const IntergrateScreen()),
      (Route<dynamic> route) => false,
    );  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image(image: AppImages.back),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // 건너뛰기 버튼을 눌렀을 때의 동작
            },
            child: const Text(
              '건너뛰기',
              style: TextStyle(
                color: AppColors.activered, // 텍스트 색상
                // 다른 스타일 속성을 여기에 추가할 수 있습니다.
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v12,
              const Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.g2,
                  ),
                  Gaps.h4,
                  Icon(
                    Icons.circle,
                    size: Sizes.size8,
                    color: AppColors.blue,
                  ),
                ],
              ),
              Gaps.v36,
              Text(
                "로드맵을 설정해보세요",
                style: AppTextStyles.h5.copyWith(color: AppColors.g6),
              ),
              Gaps.v10,
              Text(
                "본인에게 맞는 창업 로드맵을 설정할 수 있습니다",
                style: AppTextStyles.bd6.copyWith(color: AppColors.g6),
              ),
              Gaps.v32,
              Expanded(
                child: ReorderableListView(
                  children: <Widget>[
                    for (final item
                        in roadmapItems) // roadmapItems는 screen_manage.dart에서 정의된 것으로 가정
                      SizedBox(
                        key: Key(item),
                        height: 48, // 여기에서 높이를 지정합니다
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: Text(
                            item,
                            style:
                                AppTextStyles.bd2.copyWith(color: AppColors.g6),
                          ),
                          trailing: Image(image: AppImages.sort_actived),
                        ),
                      ),
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = roadmapItems.removeAt(oldIndex);
                      roadmapItems.insert(newIndex, item);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GestureDetector(
                  onTap: _onNextTap,
                  child: const NextContained(
                    text: "시작하기",
                    disabled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
