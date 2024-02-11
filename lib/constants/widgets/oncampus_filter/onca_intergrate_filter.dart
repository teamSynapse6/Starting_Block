import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCaIntergrateFilter extends StatefulWidget {
  const OnCaIntergrateFilter({super.key});

  @override
  State<OnCaIntergrateFilter> createState() => _OnCaIntergrateFilterState();
}

class _OnCaIntergrateFilterState extends State<OnCaIntergrateFilter> {
  @override
  Widget build(BuildContext context) {
    // Provider.of<OnCaFilterModel>(context)를 사용하여 OnCaFilterModel 인스턴스에 접근합니다.
    // 이 예시에서는 직접적으로 Provider.of를 사용하지 않고 있지만, 자식 위젯에서 필요할 경우 이 방법을 사용할 수 있습니다.
    return const Row(
      children: [
        OnCaResetButton(),
        Gaps.h8,
        ProgramChipsSheet(),
      ],
    );
  }
}
