// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
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
  List<String> roadmapItems = globalDataRoadmapList;
  List<String> _initialRoadmapItems = [];

  @override
  void initState() {
    super.initState();
    _saveRoadmapItems().then((_) {
      _getRoadmapItems();
    });
  }

  // 초기 리스트를 shared_preferences에 저장.
  Future<void> _saveRoadmapItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('roadmapItems', roadmapItems);
  }

  // shared_preferences에 저장된 로드맵 리스트 가져오기
  Future<void> _getRoadmapItems() async {
    List<String> initialRoadmapItems =
        await UserInfo.getTempInitialRoadmapItems();
    setState(() {
      _initialRoadmapItems = initialRoadmapItems;
    });
  }

  // 변경된 순서를 SharedPreferences에 저장
  Future<void> _saveRoadmapOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('roadmapItems', _initialRoadmapItems);
  }

  Future<bool> _saveUserInfoToServer() async {
    bool isEnterpreneurCheck = await UserInfo.getEntrepreneurCheck();
    String residence = await UserInfo.getResidence();
    String university = await UserInfo.getSchoolName();
    String birth = await UserInfo.getUserBirthday();
    String formattedBirth =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(birth));
    int profileNumber = await UserInfo.getSelectedIconIndex();

    return await UserInfoManageApi.patchUserInfo(
      birth: formattedBirth,
      isCompletedBusinessRegistration: isEnterpreneurCheck,
      residence: residence,
      university: university,
      profileNumber: profileNumber,
    );
  }

  //완료하기 버튼 클릭 시
  void _onNextTap() async {
    List<Map<String, dynamic>> roadMaps =
        _initialRoadmapItems.asMap().entries.map((entry) {
      return {"title": entry.value, "sequence": entry.key};
    }).toList();
    try {
      bool isSuccess = await _saveUserInfoToServer();
      if (isSuccess) {
        await RoadMapApi.postInitialRoadMap(roadMaps);
        _saveLoginStatus();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CompleteScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
      if (!isSuccess) {
        print('유저 정보 저장 중 오류 발생');
      }
    } catch (e) {
      print('서버 저장 중 오류가 발생했습니다: $e');
    }
  }

  //다음에 설정 버튼 클릭 시
  void _onSkipTap() async {
    try {
      bool isSuccess = await _saveUserInfoToServer();
      if (isSuccess) {
        _saveLoginStatus();
        await UserInfo().setTempInitialRoadmapItems([]);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CompleteScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      print('다음에 설정하기_서버 저장 중 오류가 발생했습니다: $e');
    }
  }

  //자동로그인 설정
  Future<void> _saveLoginStatus() async {
    UserInfo().setLoginStatus(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Consumer<UserInfo>(
        builder: (context, userInfo, child) {
          if (userInfo.hasChanged) {
            _getRoadmapItems();
            userInfo.resetChangeFlag();
          }
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OnBoardingState(thisState: 6),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gaps.v52,
                        Text(
                          "로드맵을 설정해 보세요",
                          style: AppTextStyles.h5.copyWith(color: AppColors.g6),
                        ),
                        Gaps.v10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RoadmapScreenAdd(),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 32,
                                width: 50,
                                child: Center(
                                  child: Text(
                                    '추가',
                                    style: AppTextStyles.btn1
                                        .copyWith(color: AppColors.g6),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RoadmapScreenDelete(),
                                  ),
                                );

                                // RoadmapScreenDelete에서 돌아올 때 반환된 결과 확인
                                if (result == true) {
                                  // 변경사항이 있을 때 로드맵 아이템을 다시 불러옵니다.
                                  _getRoadmapItems();
                                }
                              },
                              child: SizedBox(
                                height: 32,
                                width: 50,
                                child: Center(
                                  child: Text(
                                    '삭제',
                                    style: AppTextStyles.btn1
                                        .copyWith(color: AppColors.g6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gaps.v8,
                      ],
                    ),
                  ),
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
                      proxyDecorator: (Widget child, int index,
                          Animation<double> animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            double elevation =
                                Tween<double>(begin: 0.0, end: 6.0)
                                    .evaluate(animation);
                            if (index == draggingIndex &&
                                index < _initialRoadmapItems.length) {
                              // 현재 드래그 중인 아이템의 텍스트를 참조합니다.
                              final String currentItemText =
                                  _initialRoadmapItems[index];
                              return Material(
                                elevation: elevation,
                                child: ReorderCustomTile(
                                  thisText: currentItemText,
                                  thisTextStyle: AppTextStyles.bd1
                                      .copyWith(color: AppColors.g6),
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
                            in _initialRoadmapItems) // roadmapItems는 screen_manage.dart에서 정의된 것으로 가정
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
                          final item = _initialRoadmapItems.removeAt(oldIndex);
                          _initialRoadmapItems.insert(newIndex, item);
                          _saveRoadmapOrder(); // 변경된 순서를 저장
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Positioned(
                bottom: 0,
                child: BottomGradient(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
        height: 118,
        child: Column(
          children: [
            InkWell(
              onTap: _onNextTap,
              child: const NextContained(
                disabled: false,
                text: '완료하기',
              ),
            ),
            Gaps.v8,
            Ink(
              height: 32,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: _onSkipTap,
                child: Center(
                  child: Text(
                    '다음에 설정하기',
                    style: AppTextStyles.btn1.copyWith(color: AppColors.g5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
