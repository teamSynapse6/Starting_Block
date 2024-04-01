import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/system_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  int? draggingIndex = -1;
  String? userNickname; // 사용자 닉네임을 저장할 변수 추가

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

  @override
  void initState() {
    super.initState();
    _loadUserNickname(); // 닉네임 불러오기
  }

  // 사용자 닉네임 불러오기 메소드
  Future<void> _loadUserNickname() async {
    userNickname = await UserInfo.getNickName();
  }

  //자동로그인 설정
  Future<void> _saveUserResidence() async {
    // Provider를 사용하여 UserInfo 인스턴스에 접근
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    await userInfo.setLoginStatus(true);
  }

  void _onNextTap() async {
    int kakaoUserID = await UserInfo.getKakaoUserID();

    // 닉네임과 함께 사용자 정보 생성 요청
    if (userNickname != null && userNickname!.isNotEmpty) {
      try {
        // kakaoUserID를 String으로 변환하여 API 요청
        final String uuid = await SystemApiManage.getCreateUserInfo(
            userNickname!, kakaoUserID.toString());

        // SharedPreferences에 UUID 저장
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userUuid', uuid);

        // 성공적으로 UUID를 저장한 후 다음 화면으로 네비게이션
        if (!mounted) return;
        {
          _saveUserResidence();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const IntergrateScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        if (!mounted) return;
        // 오류 처리: 사용자에게 실패 메시지를 표시합니다.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자 정보 생성에 실패했습니다. 오류: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v12,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OnBoardingState(thisState: 6),
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
                ],
              ),
            ),
            Gaps.v32,
            Expanded(
              child: ReorderableListView(
                onReorderStart: (int newIndex) {
                  setState(() {
                    draggingIndex = newIndex;
                  });
                },
                onReorderEnd: (int oldIndex) {
                  setState(() {
                    draggingIndex = -1;
                  });
                },
                proxyDecorator:
                    (Widget child, int index, Animation<double> animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      double elevation = Tween<double>(begin: 0.0, end: 6.0)
                          .evaluate(animation);
                      if (index == draggingIndex &&
                          index < roadmapItems.length) {
                        // 현재 드래그 중인 아이템의 텍스트를 참조합니다.
                        final String currentItemText = roadmapItems[index];
                        return Material(
                          elevation: elevation,
                          child: ReorderCustomTile(
                            thisText: currentItemText,
                            thisTextStyle:
                                AppTextStyles.bd1.copyWith(color: AppColors.g6),
                          ),
                        );
                      }
                      return Material(
                        elevation: 0.0,
                        child: child,
                      );
                    },
                    child: child,
                  );
                },
                children: <Widget>[
                  for (final item
                      in roadmapItems) // roadmapItems는 screen_manage.dart에서 정의된 것으로 가정
                    ReorderCustomTile(
                      key: Key(item),
                      thisText: item,
                      thisTextStyle: AppTextStyles.bd2.copyWith(
                        color: AppColors.g6,
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
              padding: const EdgeInsets.only(
                bottom: 24,
                left: 24,
                right: 24,
              ),
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
    );
  }
}
