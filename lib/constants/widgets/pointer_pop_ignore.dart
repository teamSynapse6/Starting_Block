import 'package:flutter/material.dart';

class IgnorePopWrapper extends StatelessWidget {
  final bool ignoring;
  final bool canPop;
  final Widget child;

  const IgnorePopWrapper({
    super.key,
    required this.ignoring,
    required this.canPop,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoring,
      child: PopScope(
        canPop: canPop,
        child: child,
      ),
    );
  }
}
