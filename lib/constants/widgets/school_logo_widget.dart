import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:starting_block/manage/model_manage.dart';

class SchoolLogoWidget extends StatefulWidget {
  final String? userSchoolNameInput;

  const SchoolLogoWidget({
    super.key,
    this.userSchoolNameInput,
  });

  @override
  State<SchoolLogoWidget> createState() => _SchoolLogoWidgetState();
}

class _SchoolLogoWidgetState extends State<SchoolLogoWidget> {
  Map<String, int> schoolNameToNumber = {
    '가톨릭대학교': 1,
    '강서대학교': 2,
    '건국대학교': 3,
    '경기대학교': 4,
    '경희대학교': 5,
    '고려대학교': 6,
    '광운대학교': 7,
    '국민대학교': 8,
    '덕성여자대학교': 9,
    '동국대학교': 10,
    '동덕여자대학교': 11,
    '명지대학교': 12,
    '삼육대학교': 13,
    '상명대학교': 14,
    '서강대학교': 15,
    '서경대학교': 16,
    '서울과학기술대학교': 17,
    '서울교육대학교': 18,
    '서울대학교': 19,
    '서울시립대학교': 20,
    '서울여자대학교': 21,
    '서울한영대학교': 22,
    '성공회대학교': 23,
    '성균관대학교': 24,
    '성신여자대학교': 25,
    '세종대학교': 26,
    '숙명여자대학교': 27,
    '숭실대학교': 28,
    '연세대학교': 29,
    '이화여자대학교': 30,
    '중앙대학교': 31,
    '총신대학교': 32,
    '추계예술대학교': 33,
    '한국외국어대학교': 34,
    '한국체육대학교': 35,
    '한성대학교': 36,
    '한양대학교': 37,
    '홍익대학교': 38
  };

  Future<int> getSchoolNumber() async {
    String schoolName;

    if (widget.userSchoolNameInput != null) {
      schoolName = widget.userSchoolNameInput!;
    } else {
      schoolName = await UserInfo.getSchoolName(); // 비동기 호출로 학교명을 가져옵니다.
    }

    return schoolNameToNumber[schoolName] ?? 0; // 맵에서 학교 번호를 찾고, 없으면 0을 반환합니다.
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getSchoolNumber(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 인디케이터
        } else if (snapshot.hasError) {
          return const Text('데이터를 불러오는 데 실패했습니다.'); // 에러 처리
        } else if (snapshot.data == 0) {
          return const Text('학교 정보가 없습니다.'); // 학교 번호가 없는 경우
        } else {
          // 학교 번호를 사용하여 로고 로드
          String assetPath = 'assets/school_logo/${snapshot.data}.svg';
          return SvgPicture.asset(assetPath, fit: BoxFit.fitWidth);
        }
      },
    );
  }
}
