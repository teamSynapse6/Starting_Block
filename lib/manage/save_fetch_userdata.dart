// ignore_for_file: avoid_print

import 'package:intl/intl.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class SaveUserData {
// 로그인 시 사용자 정보를 로컬에 저장하는 메소드
  static Future<void> fetchAndSaveUserData() async {
    try {
      // UserInfoManageApi에서 사용자 정보를 가져옴
      UserDataModel userData = await UserInfoManageApi.getUserInfoData();
      print(
          '유저 데이터: ${userData.nickname}, ${userData.birth}, ${userData.isCompletedBusinessRegistration}, ${userData.residence}, ${userData.university}');

      // birth 데이터에서 '-'를 제거하여 YYYYMMDD 형식으로 변환
      String formattedBirth = userData.birth.replaceAll('-', '');

      // 불러온 데이터를 UserInfo에 저장
      await UserInfo().setNickName(userData.nickname);
      await UserInfo().setUserBirthday(formattedBirth); // 수정된 생일 형식 저장
      await UserInfo()
          .setEntrepreneurCheck(userData.isCompletedBusinessRegistration);
      await UserInfo().setResidence(userData.residence);
      await UserInfo().setSchoolName(userData.university);
      await UserInfo().setSelectedIconIndex(userData.profileNumber);
      print('사용자 정보 저장 완료');
    } catch (e) {
      // 예외 발생 시 오류 메시지 출력
      print('사용자 정보를 저장하는 중 오류 발생: $e');
    }
  }

  static Future<void> loadFromLocalAndFetchToServer({
    String? inputUserBirthday,
    bool? inputEntrepreneurCheck,
    String? inputResidence,
    String? inputSchoolName,
    int? inputProfileNumber,
  }) async {
    try {
      // UserInfo 클래스에서 데이터를 가져옵니다.

      String finalUserBirthday = inputUserBirthday != null
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(inputUserBirthday))
          : DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(await UserInfo.getUserBirthday()));
      bool finalEntrepreneurCheck =
          inputEntrepreneurCheck ?? await UserInfo.getEntrepreneurCheck();
      String finalResidence = inputResidence ?? await UserInfo.getResidence();
      String finalSchoolName =
          inputSchoolName ?? await UserInfo.getSchoolName();
      int finalProfileNumber =
          inputProfileNumber ?? await UserInfo.getSelectedIconIndex();

      // 가져온 데이터를 출력하여 확인합니다.
      print(
          '유저 데이터: $finalUserBirthday, $finalEntrepreneurCheck, $finalResidence, $finalSchoolName, $finalProfileNumber');

      //이 데이터를 서버에 Fetch하여 저장.
      bool result = await UserInfoManageApi.patchUserInfo(
        birth: finalUserBirthday,
        isCompletedBusinessRegistration: finalEntrepreneurCheck,
        residence: finalResidence,
        university: finalSchoolName,
        profileNumber: finalProfileNumber,
      );
      if (result) {
        // 로컬 저장 시 '-'를 제거하여 YYYYMMDD 형식으로 저장
        String formattedBirth = finalUserBirthday.replaceAll('-', '');

        await UserInfo().setUserBirthday(formattedBirth);
        await UserInfo().setEntrepreneurCheck(finalEntrepreneurCheck);
        await UserInfo().setResidence(finalResidence);
        await UserInfo().setSchoolName(finalSchoolName);
        await UserInfo().setSelectedIconIndex(finalProfileNumber);
      } else {
        print('사용자 정보 저장 실패');
      }
    } catch (e) {
      print('서버에러 발생: $e');
    }
  }
}
