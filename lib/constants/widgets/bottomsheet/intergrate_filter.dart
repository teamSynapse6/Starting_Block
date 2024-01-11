import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/bottomsheet/model/filter_model.dart';

class IntergrateFilter extends StatefulWidget {
  const IntergrateFilter({super.key});

  @override
  State<IntergrateFilter> createState() => _IntergrateFilterState();
}

class _IntergrateFilterState extends State<IntergrateFilter> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterModel(),
      child: const Row(
        children: [
          ResetButton(),
          Gaps.h8,
          EnterPreneurChipsSheet(),
          Gaps.h8,
          ResidenceChipsSheet(),
          Gaps.h8,
          SupportTypeChipsSheet(),
        ],
      ),
    );
  }
}
