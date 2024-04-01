import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class SettingHome extends StatelessWidget {
  const SettingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v24,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '설정',
              style: AppTextStyles.st1.copyWith(color: AppColors.g6),
            ),
          ),
          Gaps.v24,
          const SettingList(
            onTapScreen: AlarmSetting(),
            thisText: "알림 설정",
          ),
          const SettingList(
            onTapScreen: SettingTermWebview(
              url:
                  'https://www.youtube.com/watch?v=Km71Rr9K-Bw&list=RDx7gUk3mzT8s&index=12', //링크 수정필요
            ),
            thisText: "개인정보처리방침 및 이용약관",
          ),
          const SettingListWithDialog(
            thisText: '로그아웃',
            thisTitle: '로그아웃',
            thisDescription: '해당 계정이 로그아웃됩니다.\n다시 서비스에 진입 시 계정 로그인이 필요합니다.',
            thisRightActionText: '확인',
            thisRightactionTap: null,
          ),
          const SettingListWithDialog(
            //여기 수정필요
            thisText: '회원탈퇴',
            thisTitle: '회원탈퇴',
            thisDescription: '회원탈퇴 시 어떻게 여기는 채워야함',
            thisRightActionText: '확인',
            thisRightactionTap: null,
          ),
        ],
      ),
    );
  }
}
