// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class GnbTap extends StatelessWidget {
  const GnbTap({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.selectedIndex,
    required this.selecetedIcon,
    required this.unselecetedIcon,
  });

  final String text;
  final bool isSelected;
  final selecetedIcon;
  final unselecetedIcon;
  final Function onTap;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSelected ? selecetedIcon : unselecetedIcon,
              Gaps.v2,
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.g5 : AppColors.g3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
