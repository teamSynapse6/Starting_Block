import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class ProfileIconWidget extends StatelessWidget {
  final int iconIndex;

  const ProfileIconWidget({
    super.key,
    required this.iconIndex,
  });

  @override
  Widget build(BuildContext context) {
    // 프로필 아이콘을 결정하는 로직
    Widget profileIcon;
    switch (iconIndex) {
      case 1:
        profileIcon = AppIcon.profile_image_1; // 실제 아이콘 경로를 입력하세요.
        break;
      case 2:
        profileIcon = AppIcon.profile_image_2; // 실제 아이콘 경로를 입력하세요.
        break;
      case 3:
        profileIcon = AppIcon.profile_image_3; // 실제 아이콘 경로를 입력하세요.
        break;
      case 4:
        profileIcon = AppIcon.profile_image_4; // 실제 아이콘 경로를 입력하세요.
        break;
      default:
        profileIcon = Container(); // 기본값 설정, 빈 컨테이너나 기본 이미지를 표시할 수 있습니다.
    }

    return FittedBox(
      fit: BoxFit.contain, // 이미지가 부모 컨테이너에 맞춰 조절되도록 설정
      child: profileIcon,
    );
  }
}
