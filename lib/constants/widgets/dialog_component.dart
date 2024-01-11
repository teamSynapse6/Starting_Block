import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class DialogComponent extends StatelessWidget {
  final String title, description, rightActionText;
  final rightActionTap;

  const DialogComponent({
    super.key,
    required this.title,
    required this.description,
    required this.rightActionText,
    required this.rightActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      child: SizedBox(
        width: 312,
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
                children: [
                  Gaps.h152,
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 76,
                      height: 36,
                      child: Center(
                        child: Text(
                          '취소',
                          style:
                              AppTextStyles.btn1.copyWith(color: AppColors.g4),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: rightActionTap,
                    child: SizedBox(
                      width: 76,
                      height: 36,
                      child: Center(
                        child: Text(
                          rightActionText,
                          style: AppTextStyles.btn1
                              .copyWith(color: AppColors.blue),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
