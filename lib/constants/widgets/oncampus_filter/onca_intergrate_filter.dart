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
    return const Row(
      children: [
        ProgramChipsSheet(),
      ],
    );
  }
}
