// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class DialogComponent extends StatelessWidget {
  final String title, description, rightActionText;
  final rightActionTap, leftActionTap;

  const DialogComponent({
    super.key,
    required this.title,
    required this.description,
    required this.rightActionText,
    required this.rightActionTap,
    this.leftActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Gaps.v24,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bd1.copyWith(color: AppColors.black),
                ),
                Gaps.v18,
                Text(
                  description,
                  style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                ),
              ],
            ),
          ),
          Gaps.v24,
          Container(
            height: 1,
            color: AppColors.g2,
          ),
          SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: leftActionTap ??
                      () {
                        Navigator.pop(context);
                      },
                  child: SizedBox(
                    width: 76,
                    height: 36,
                    child: Center(
                      child: Text(
                        '취소',
                        style: AppTextStyles.btn1.copyWith(color: AppColors.g4),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: rightActionTap,
                  child: SizedBox(
                    width: 76,
                    height: 36,
                    child: Center(
                      child: Text(
                        rightActionText,
                        style:
                            AppTextStyles.btn1.copyWith(color: AppColors.blue),
                      ),
                    ),
                  ),
                ),
                Gaps.h8,
              ],
            ),
          )
        ],
      ),
    );
  }
}
