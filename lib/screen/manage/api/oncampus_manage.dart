Map<String, int> schoolNameToNumber = {
  '가톨릭대학교': 1,
  '감리교신학대학교': 2,
  '강서대학교': 3,
  '건국대학교': 4,
  '경기대학교': 5,
  '경희대학교': 6,
  '고려대학교': 7,
  '광운대학교': 8,
  '국민대학교': 9,
  '덕성여자대학교': 10,
  '동국대학교': 11,
  '동덕여자대학교': 12,
  '명지대학교': 13,
  '삼육대학교': 14,
  '상명대학교': 15,
  '서강대학교': 16,
  '서경대학교': 17,
  '서울과학기술대학교': 18,
  '서울교육대학교': 19,
  '서울기독대학교': 20,
  '서울대학교': 21,
  '서울시립대학교': 22,
  '서울여자대학교': 23,
  '서울한 영대학교': 24,
  '성공회대학교': 25,
  '성균관대학교': 26,
  '성신여자대학교': 27,
  '세종대학교': 28,
  '숙명여자대학교': 29,
  '숭실대학교': 30,
  '연세대학교': 31,
  '이화여자대학교': 32,
  '정로회신학대학교': 33,
  '중앙대학교': 34,
  '총신대학교': 35,
  '추계예술대학교': 36,
  '한국성서대학교': 37,
  '한국외국어대학교': 38,
  '한국체육대학교': 39,
  '한성대학교': 40,
  '한양대학교': 41,
  '홍익대학교': 42
};

int getSchoolNumber(String schoolName) {
  return schoolNameToNumber[schoolName] ?? -1; // 학교명이 없을 경우 -1을 반환
}
