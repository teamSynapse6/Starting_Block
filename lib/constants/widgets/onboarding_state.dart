import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnBoardingState extends StatelessWidget {
  final int thisState;
  const OnBoardingState({super.key, required this.thisState});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Distribute space evenly
      children: List.generate(6, (index) {
        return Expanded(
          child: Container(
            height: 4.0, // Set the height to 4
            color: thisState > index
                ? AppColors.blue
                : AppColors.g1, // Adjust color based on the index
          ),
        );
      }),
    );
  }
}
