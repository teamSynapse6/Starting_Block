// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class SettingList extends StatelessWidget {
  final onTapScreen;
  final String thisText;

  const SettingList({
    super.key,
    required this.onTapScreen,
    required this.thisText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => onTapScreen,
          ),
        );
      },
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              thisText,
              style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingListWithDialog extends StatelessWidget {
  final thisRightactionTap;
  final String thisText;
  final String thisTitle, thisDescription, thisRightActionText;

  const SettingListWithDialog({
    super.key,
    required this.thisText,
    required this.thisTitle,
    required this.thisDescription,
    required this.thisRightActionText,
    required this.thisRightactionTap,
  });

  @override
  Widget build(BuildContext context) {
    void thisTap() {
      showDialog(
          context: context,
          builder: ((context) {
            return DialogComponent(
                title: thisTitle,
                description: thisDescription,
                rightActionText: thisRightActionText,
                rightActionTap: thisRightactionTap);
          }));
    }

    return InkWell(
      onTap: () {
        thisTap();
      },
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              thisText,
              style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            ),
          ),
        ),
      ),
    );
  }
}
