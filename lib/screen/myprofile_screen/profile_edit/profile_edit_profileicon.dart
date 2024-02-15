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

  void _onIconTap(int index) {
    setState(() {
      if (_selectedIconIndex != index) {
        _selectedIconIndex = index;
        _isButtonDisabled = false;
      }
    });
  }

  void _onNextTap() async {
    if (_selectedIconIndex == null) return;
    await _saveSelectedIcon();
    Navigator.of(context).pop();
  }

  Widget _iconSelection(int index, Widget icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(48),
      onTap: () => _onIconTap(index),
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.g1,
          border: Border.all(
            color: _selectedIconIndex == index
                ? AppColors.blue
                : Colors.transparent,
            width: 4,
          ),
        ),
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      AppIcon.profile_image_1,
      AppIcon.profile_image_2,
      AppIcon.profile_image_3
    ];
    final selectedIcon = _selectedIconIndex != null
        ? icons[_selectedIconIndex! - 1]
        : Container();

    return Scaffold(
      appBar: const BackAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v32,
                Text(
                  "프로필 아이콘 수정",
                  style: AppTextStyles.h5.copyWith(color: AppColors.g6),
                ),
                Gaps.v32,
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.g1,
                    ),
                    child: selectedIcon,
                  ),
                ),
                Gaps.v48,
              ],
            ),
          ),
          const CustomDividerH8G2(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v32,
                Text(
                  '스타터님!',
                  style: AppTextStyles.bd3.copyWith(color: AppColors.g6),
                ),
                Text(
                  '프로필 아이콘으로 자신의 단계를 표현해 보세요!',
                  style: AppTextStyles.bd3.copyWith(color: AppColors.g6),
                ),
                Gaps.v24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    icons.length,
                    (index) => SizedBox(
                      width: 96,
                      height: 125,
                      child: Column(
                        children: [
                          _iconSelection(index + 1, icons[index]),
                          Gaps.v11,
                          Text(
                            '${index + 1}단계',
                            style:
                                AppTextStyles.bd5.copyWith(color: AppColors.g5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: GestureDetector(
              onTap: _isButtonDisabled ? null : _onNextTap,
              child: NextContained(
                text: "저장",
                disabled: _isButtonDisabled,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
