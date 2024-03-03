import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeAlarmScreen extends StatefulWidget {
  const HomeAlarmScreen({super.key});

  @override
  State<HomeAlarmScreen> createState() => _HomeAlarmScreenState();
}

class _HomeAlarmScreenState extends State<HomeAlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Column(
        children: [
          Gaps.v24,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '알림',
              style: AppTextStyles.h4.copyWith(color: AppColors.g6),
            ),
          ),
          Gaps.v16,
        ],
      ),
    );
  }
}
