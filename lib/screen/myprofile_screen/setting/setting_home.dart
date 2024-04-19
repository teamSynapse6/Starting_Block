import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class SettingHome extends StatefulWidget {
  const SettingHome({super.key});

  @override
  State<SettingHome> createState() => _SettingHomeState();
}

class _SettingHomeState extends State<SettingHome> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void _logOutTap() async {
    bool success = await UserInfoManageApi.postUserLogOut();
    if (success) {
      await secureStorage.deleteAll();
      await UserInfo().setLoginStatus(false);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  void _deleteAccountTap() async {
    bool success = await UserInfoManageApi.postDeleteAccount();
    if (success) {
      await secureStorage.deleteAll();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

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
          SettingListWithDialog(
            thisText: '로그아웃',
            thisTitle: '로그아웃',
            thisDescription: '정말 로그아웃 할까요?',
            thisRightActionText: '확인',
            thisRightactionTap: _logOutTap,
          ),
          SettingListWithDialog(
            //여기 수정필요
            thisText: '회원탈퇴',
            thisTitle: '회원탈퇴',
            thisDescription: '회원 탈퇴 시 기존 데이터를 복구할 수 없어요.',
            thisRightActionText: '확인',
            thisRightactionTap: _deleteAccountTap,
          ),
        ],
      ),
    );
  }
}
