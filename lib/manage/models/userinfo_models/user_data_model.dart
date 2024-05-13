class UserDataModel {
  final String nickname;
  final String birth;
  final bool isCompletedBusinessRegistration;
  final String residence;
  final String university;
  final String email;
  final String provider;
  final String providerId;
  final String role;

  // JSON 객체를 이용하여 클래스의 생성자 정의
  UserDataModel.fromJson(Map<String, dynamic> json)
      : nickname = json['nickname'] as String,
        birth = json['birth'] as String,
        isCompletedBusinessRegistration =
            json['isCompletedBusinessRegistration'] as bool,
        residence = json['residence'] as String,
        university = json['university'] as String,
        email = json['email'] as String,
        provider = json['provider'] as String,
        providerId = json['providerId'] as String,
        role = json['role'] as String;
}
