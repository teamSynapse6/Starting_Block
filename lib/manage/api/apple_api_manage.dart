import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

const FlutterSecureStorage appleSecureStorage = FlutterSecureStorage();

class AppleLoginUser {
  final String authorizationCode;
  final String? identityToken;
  final String? userIdentifier;
  final String? email;
  final String? givenName;
  final String? familyName;

  const AppleLoginUser({
    required this.authorizationCode,
    this.identityToken,
    this.userIdentifier,
    this.email,
    this.givenName,
    this.familyName,
  });

  Map<String, dynamic> toSignInBody() {
    final body = <String, dynamic>{
      'authorizationCode': authorizationCode,
      'identityToken': identityToken,
      'providerId': userIdentifier,
      'userIdentifier': userIdentifier,
      'email': email,
      'givenName': givenName,
      'familyName': familyName,
    };

    body.removeWhere((_, value) => value == null);
    return body;
  }
}

Future<bool> isAppleSignInSupportedOnCurrentPlatform() async {
  if (kIsWeb) {
    return false;
  }

  if (defaultTargetPlatform != TargetPlatform.iOS) {
    return false;
  }

  return SignInWithApple.isAvailable();
}

Future<AppleLoginUser> signInWithApple() async {
  final isAvailable = await isAppleSignInSupportedOnCurrentPlatform();

  if (!isAvailable) {
    throw Exception('Apple 로그인을 사용할 수 없는 기기입니다.');
  }

  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );

  await _persistAppleCredential(credential);

  return AppleLoginUser(
    authorizationCode: credential.authorizationCode,
    identityToken: credential.identityToken,
    userIdentifier: credential.userIdentifier,
    email: credential.email,
    givenName: credential.givenName,
    familyName: credential.familyName,
  );
}

Future<void> _persistAppleCredential(
  AuthorizationCredentialAppleID credential,
) async {
  final values = <String, String?>{
    'appleUserIdentifier': credential.userIdentifier,
    'appleUserEmail': credential.email,
    'appleUserGivenName': credential.givenName,
    'appleUserFamilyName': credential.familyName,
  };

  for (final entry in values.entries) {
    final value = entry.value;
    if (value != null && value.isNotEmpty) {
      await appleSecureStorage.write(key: entry.key, value: value);
    }
  }
}
