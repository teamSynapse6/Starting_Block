import 'package:flutter/material.dart';
import 'package:starting_block/manage/firebase/firebase_screen.dart';
import 'package:starting_block/manage/firebase/firebase_screen_observer.dart';

MaterialPageRoute<T> trackedRoute<T>({
  required WidgetBuilder builder,
  FirebaseScreenInfo? screen,
  RouteSettings? settings,
  bool maintainState = true,
  bool fullscreenDialog = false,
  bool allowSnapshotting = true,
  bool barrierDismissible = false,
}) {
  return MaterialPageRoute<T>(
    builder: (context) {
      final child = builder(context);
      final resolvedScreen = screen ?? FirebaseScreens.fromWidget(child);
      if (resolvedScreen == null) {
        return child;
      }
      return FirebaseRouteScreenTracker(
        screen: resolvedScreen,
        child: child,
      );
    },
    settings: settings ??
        (screen == null
            ? null
            : RouteSettings(
                name: screen.id,
              )),
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
    allowSnapshotting: allowSnapshotting,
    barrierDismissible: barrierDismissible,
  );
}
