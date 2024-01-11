import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: const BoxDecoration(
        color: AppColors.g1,
      ),
    );
  }
}
