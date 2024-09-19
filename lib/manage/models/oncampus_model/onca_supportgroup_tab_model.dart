// SupportGroupTabModel 클래스 정의
class SupportGroupTabModel {
  final String name;

  SupportGroupTabModel(this.name);

  // 탭 이름에 대한 매핑
  static final Map<String, String> _nameMap = {
    'CLUB': '동아리',
    'CAMP': '캠프',
    'CONTEST': '경진대회',
    'LECTURE': '특강',
    'MENTORING': '멘토링',
    'SPACE': '공간',
    'ETC': '기타'
  };

  // 받은 데이터를 변환하는 메소드
  static String translate(String code) => _nameMap[code] ?? code;
}
