class UserSignInModel {
  final bool isSignUpComplete;
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  UserSignInModel.fromJson(Map<String, dynamic> json)
      : isSignUpComplete = json['isSignUpComplete'] as bool,
        accessToken = json['accessToken'] as String,
        refreshToken = json['refreshToken'] as String,
        tokenType = json['tokenType'] as String;
}
