import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class RoadMapPersistantTabBar extends SliverPersistentHeaderDelegate {
  final Widget child;

  RoadMapPersistantTabBar({
    required this.child,
  });

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
