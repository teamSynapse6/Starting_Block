import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/manage/userdata/gpt_list_manage.dart';

class SettingHome extends StatefulWidget {
  const SettingHome({super.key});

  @override
  State<SettingHome> createState() => _SettingHomeState();
}

class _SettingHomeState extends State<SettingHome> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void _logOutTap() async {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false,
      );
      await secureStorage.deleteAll();
      await DeleteAllChatData.deleteAllGptChatData();
      await UserInfo().setLoginStatus(false);
      await UserInfoManageApi.postUserLogOut();
    }
  }

  void _deleteAccountTap() async {
    bool success = await UserInfoManageApi.postDeleteAccount();
    if (success) {
      await secureStorage.deleteAll();
      await DeleteAllChatData.deleteAllGptChatData();
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
              '설정 및 활동',
              style: AppTextStyles.st1.copyWith(color: AppColors.g6),
            ),
          ),
          Gaps.v24,
          const SettingList(
            onTapScreen: SettingTermWebview(
              url: 'https://www.startingblock.co.kr/term', //링크 1차 수정
            ),
            thisText: "개인정보처리방침 및 이용약관",
          ),
          const SettingList(
            onTapScreen: CustomLicensePage(),
            thisText: "오픈소스 라이선스",
          ),
          SettingListWithDialog(
            thisText: '로그아웃',
            thisTitle: '정말 로그아웃할까요?',
            thisDescription: '로그아웃 시, 공고 분석 내역이 삭제됩니다.',
            thisRightActionText: '확인',
            thisRightactionTap: _logOutTap,
          ),
          SettingListWithDialog(
            //여기 수정필요
            thisText: '회원탈퇴',
            thisTitle: '정말 회원 탈퇴할까요?',
            thisDescription: '회원 탈퇴 시 기존 데이터를 복구할 수 없어요.',
            thisRightActionText: '확인',
            thisRightactionTap: _deleteAccountTap,
          ),
        ],
      ),
    );
  }
}
