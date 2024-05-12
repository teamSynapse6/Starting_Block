// ignore_for_file: avoid_print

import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class SaveUserData {
  static Future<void> fetchAndSaveUserData() async {
    try {
      // UserInfoManageApi에서 사용자 정보를 가져옴
      UserDataModel userData = await UserInfoManageApi.getUserInfoData();
      print(
          '유저 데이터: ${userData.nickname}, ${userData.birth}, ${userData.isCompletedBusinessRegistration}, ${userData.residence}, ${userData.university}');

      //불러온 데이터를 UesrInfo에 저장
      await UserInfo().setNickName(userData.nickname);
      await UserInfo().setUserBirthday(userData.birth);
      await UserInfo()
          .setEntrepreneurCheck(userData.isCompletedBusinessRegistration);
      await UserInfo().setResidence(userData.residence);
      await UserInfo().setSchoolName(userData.university);
      print('사용자 정보 저장 완료');
    } catch (e) {
      // 예외 발생 시 오류 메시지 출력
      print('사용자 정보를 저장하는 중 오류 발생: $e');
    }
  }
}
