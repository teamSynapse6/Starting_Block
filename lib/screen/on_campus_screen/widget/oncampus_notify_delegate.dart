import 'package:flutter/material.dart';

class OnCampusNotifyDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  OnCampusNotifyDelegate({required this.child});

  @override
  double get minExtent => 76; // 최소 높이
  @override
  double get maxExtent => 76; // 최대 높이

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(OnCampusNotifyDelegate oldDelegate) {
    return true;
  }
}
