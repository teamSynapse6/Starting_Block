import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class IntergrateFilter extends StatelessWidget {
  const IntergrateFilter({super.key});

  @override
  Widget build(BuildContext context) {
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
