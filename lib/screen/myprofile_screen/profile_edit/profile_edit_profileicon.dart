// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';

class ProfileIconEdit extends StatefulWidget {
  const ProfileIconEdit({super.key});

  @override
  State<ProfileIconEdit> createState() => _ProfileIconEditState();
}

class _ProfileIconEditState extends State<ProfileIconEdit> {
  int? _selectedIconIndex;
  bool _isButtonDisabled = true;

  List<Map<String, dynamic>> iconStageData = [
    {
      "icon": AppIcon.profile_image_1,
      "title": "준비",
      "subtitle": "(출발선)", // 올바르게 수정된 키
      "content": "스트레칭을 하며 준비에 임하기",
    },
    {
      "icon": AppIcon.profile_image_2,
      "title": "사교적 달리기",
      "subtitle": "(출발 ~ 15km)", // 올바르게 수정된 키
      "content": "천천히 주위를 돌아보며 달리기에 적응",
    },
    {
      "icon": AppIcon.profile_image_3,
      "title": "과도",
      "subtitle": "(15~32km)", // 올바르게 수정된 키
      "content": "자신에 몰두하며, 힘을 낼 수 있는 태세 갖추기",
    },
    {
      "icon": AppIcon.profile_image_4,
      "title": "집중",
      "subtitle": "(32~42.195km)", // 올바르게 수정된 키
      "content": "본격적으로 달리기, 스피치를 올리며 집중",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedIcon();
  }

  void _loadSelectedIcon() async {
    // UserInfo의 getSelectedIconIndex 메소드를 사용하여 선택된 아이콘 인덱스를 로드합니다.
    int index = await UserInfo.getSelectedIconIndex();
    setState(() {
      _selectedIconIndex = index;
      // 인덱스가 0이 아니면 선택된 것으로 간주하고 버튼을 활성화합니다.
      _isButtonDisabled = index == 0;
    });
  }

  Future<void> _saveSelectedIcon() async {
    // UserInfo 인스턴스에 접근합니다.
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    await userInfo.setSelectedIconIndex(_selectedIconIndex!); // 수정된 부분
  }

  void _onNextTap() async {
    if (_selectedIconIndex == null) return;
    await _saveSelectedIcon();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      AppIcon.profile_image_1,
      AppIcon.profile_image_2,
      AppIcon.profile_image_3,
      AppIcon.profile_image_4,
    ];
    final selectedIcon = _selectedIconIndex != null
        ? icons[_selectedIconIndex! - 1]
        : Container();

    return Scaffold(
      appBar: const BackAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v20,
                  Text(
                    "프로필 아이콘 수정",
                    style: AppTextStyles.h5.copyWith(color: AppColors.g6),
                  ),
                  Gaps.v8,
                  Text(
                    "프로필 아이콘으로 자신의 단계를 표현해 보세요",
                    style: AppTextStyles.bd6.copyWith(color: AppColors.g6),
                  ),
                  Gaps.v24,
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.g1,
                          border: Border.all(
                            width: 1,
                            color: AppColors.g2,
                          )),
                      child: selectedIcon,
                    ),
                  ),
                  Gaps.v16,
                  Align(
                    alignment: Alignment.center,
                    child: _selectedIconIndex != null
                        ? Column(
                            children: [
                              Text(
                                iconStageData[_selectedIconIndex! - 1]
                                    ['title'], // 현재 선택된 아이템의 title
                                style: AppTextStyles.bd3
                                    .copyWith(color: AppColors.g6),
                              ),
                              Text(
                                iconStageData[_selectedIconIndex! - 1]
                                    ['subtitle'], // 현재 선택된 아이템의 subtitle
                                style: AppTextStyles.bd3
                                    .copyWith(color: AppColors.g6),
                              ),
                            ],
                          )
                        : Container(), // _selectedIconIndex가 null인 경우 빈 컨테이너 표시
                  ),
                  Gaps.v40,
                ],
              ),
            ),
            const CustomDividerH8G2(),
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // 리스트가 스크롤되지 않도록 설정
              itemCount: iconStageData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = iconStageData[index];
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () => setState(() {
                        _selectedIconIndex = index + 1;
                        _isButtonDisabled = false;
                      }),
                      child: ProfileEditIconList(
                        thisIcon: item['icon'],
                        thisTitle: item['title'],
                        thisSubTitle: item['subtitle'],
                        thisContent: item['content'],
                      ),
                    ),
                    if (index !=
                        iconStageData.length - 1) // 마지막 아이템이 아니면 Divider 추가
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 88,
                          right: 24,
                        ),
                        child: CustomDividerG2(),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 92,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: GestureDetector(
            onTap: _isButtonDisabled ? null : _onNextTap,
            child: NextContained(
              text: "저장",
              disabled: _isButtonDisabled,
            ),
          ),
        ),
      ),
    );
  }
}
