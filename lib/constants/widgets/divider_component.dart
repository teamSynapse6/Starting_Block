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

class CustomDividerH1G1 extends StatelessWidget {
  const CustomDividerH1G1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        color: AppColors.g1,
      ),
    );
  }
}

class CustomDividerH2G1 extends StatelessWidget {
  const CustomDividerH2G1({super.key});

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

class CustomDividerH8G2 extends StatelessWidget {
  const CustomDividerH8G2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.g2,
      ),
    );
  }
}

class CustomDividerH8G1 extends StatelessWidget {
  const CustomDividerH8G1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.g1,
      ),
    );
  }
}

class CustomDividerDDE1E5 extends StatelessWidget {
  const CustomDividerDDE1E5({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        color: Color(0xffDDE1E5),
      ),
    );
  }
}
