import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class IntergrateFilter extends StatelessWidget {
  const IntergrateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    // 여기서는 Provider.of 또는 Consumer를 사용하지 않아도 됩니다.
    // 왜냐하면 이 위젯 자체가 FilterModel의 상태를 직접적으로 사용하지 않기 때문입니다.
    // 그러나, 이 위젯의 자식들이 FilterModel을 사용할 수 있도록
    // FilterModel을 상위에서 이미 제공하고 있다는 점을 기억하세요.
    return const Wrap(
      spacing: 8,
      children: [
        EnterPreneurChipsSheet(),
        ResidenceChipsSheet(),
        SupportTypeChipsSheet(),
      ],
    );
  }
}
