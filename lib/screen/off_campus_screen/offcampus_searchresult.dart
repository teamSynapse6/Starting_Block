import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/recentsearch_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class OffCampusSearchResult extends StatefulWidget {
  final String searchWord; // 검색어를 저장할 변수

  const OffCampusSearchResult({
    super.key,
    required this.searchWord,
  });

  @override
  State<OffCampusSearchResult> createState() => _OffCampusSearchResultState();
}

class _OffCampusSearchResultState extends State<OffCampusSearchResult> {
  String dropdownValue = '최신순'; // 선택된 옵션을 저장하는 변수
  final TextEditingController _controller = TextEditingController();
  final RecentSearchManager recentSearchManager = RecentSearchManager();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchWord;

    // 검색 결과 페이지가 로드될 때, 검색어를 RecentSearchManager에 추가
    recentSearchManager.addSearch(widget.searchWord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchFiledAppBar(
        hintText: '검색어를 입력해주세요', // hintText 설정
        controller: _controller, // 컨트롤러 사용
        recentSearchManager: recentSearchManager,
        onBackTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OffCampusSearch()),
            (Route<dynamic> route) => false,
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Gaps.v12,
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntergrateFilter(),
            ),
            Gaps.v12,
            Container(
              height: 32,
              decoration: const BoxDecoration(
                border: BorderDirectional(
                  top: BorderSide(width: 2, color: AppColors.g1),
                  bottom: BorderSide(width: 2, color: AppColors.g1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '24개의 공고',
                    style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                  ),
                  const Spacer(), // 왼쪽 텍스트와 오른쪽 버튼 사이의 공간을 만듦
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        dropdownValue = value; // 사용자가 선택한 값을 저장
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: '최신순',
                          child: Text('최신순'),
                        ),
                        const PopupMenuItem(
                          value: '오래된 순',
                          child: Text('오래된 순'),
                        ),
                        const PopupMenuItem(
                          value: '찜 많은 순',
                          child: Text('찜 많은 순'),
                        ),
                      ];
                    },
                    child: Row(
                      children: [
                        Text(
                          dropdownValue,
                          style: const TextStyle(
                              fontFamily: 'pretendard',
                              fontSize: 14,
                              color: AppColors.g4),
                        ), // 현재 선택된 값으로 텍스트 업데이트
                        AppIcon.down,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
