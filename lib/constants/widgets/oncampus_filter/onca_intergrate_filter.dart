import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/oncampus_filter/model/onca_filter_model.dart';

class OnCaIntergrateFilter extends StatefulWidget {
  const OnCaIntergrateFilter({super.key});

  @override
  State<OnCaIntergrateFilter> createState() => _OnCaIntergrateFilterState();
}

class _OnCaIntergrateFilterState extends State<OnCaIntergrateFilter> {
  @override
  Widget build(BuildContext context) {
    // OnCaFilterModel 인스턴스를 생성하고, 이를 자식 위젯에 제공
    return ChangeNotifierProvider<OnCaFilterModel>(
      create: (_) => OnCaFilterModel(),
      child: const Row(
        children: [
          OnCaResetButton(),
          Gaps.h8,
          ProgramChipsSheet(),
        ],
      ),
    );
  }
}
