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
        profileIcon = AppIcon.profile_image_1;
        break;
      case 2:
        profileIcon = AppIcon.profile_image_2;
        break;
      case 3:
        profileIcon = AppIcon.profile_image_3;
        break;
      case 4:
        profileIcon = AppIcon.profile_image_4;
        break;
      default:
        profileIcon = AppIcon.profile_image_1;
    }

    return FittedBox(
      fit: BoxFit.contain,
      child: profileIcon,
    );
  }
}
