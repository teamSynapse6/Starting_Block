import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class AlarmSetting extends StatefulWidget {
  const AlarmSetting({super.key});

  @override
  State<AlarmSetting> createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  // 각 알림 설정에 대한 상태를 관리하는 불리언 변수들
  bool _isStorageNoticeEnabled = false;
  bool _isResponseNoticeEnabled = false;
  bool _isUserAnswerNoticeEnabled = false;

  // 설정 항목을 위한 위젯을 생성하는 메소드
  Widget _buildSettingOption(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v24,
            Text(
              '알림 설정',
              style: AppTextStyles.st1.copyWith(color: AppColors.g6),
            ),
            Gaps.v24,
            _buildSettingOption(
              '저장 지원공고 마감 예정 알림',
              _isStorageNoticeEnabled,
              (newValue) => setState(() => _isStorageNoticeEnabled = newValue),
            ),
            _buildSettingOption(
              '공고 담당처의 답변 알림',
              _isResponseNoticeEnabled,
              (newValue) => setState(() => _isResponseNoticeEnabled = newValue),
            ),
            _buildSettingOption(
              '다른 사용자의 답변 알림',
              _isUserAnswerNoticeEnabled,
              (newValue) =>
                  setState(() => _isUserAnswerNoticeEnabled = newValue),
            ),
          ],
        ),
      ),
    );
  }
}
