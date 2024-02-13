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

class CustomDividerG2 extends StatelessWidget {
  const CustomDividerG2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        color: AppColors.g2,
      ),
    );
  }
}

class CustomeDividerH5 extends StatelessWidget {
  const CustomeDividerH5({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      decoration: const BoxDecoration(
        color: AppColors.g1,
      ),
    );
  }
}
