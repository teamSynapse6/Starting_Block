import 'package:flutter/widgets.dart';
import 'package:starting_block/manage/firebase/firebase_analytics_manage.dart';
import 'package:starting_block/manage/firebase/firebase_screen.dart';

final RouteObserver<PageRoute<dynamic>> firebaseRouteObserver =
    RouteObserver<PageRoute<dynamic>>();

class FirebaseScreenObserver extends NavigatorObserver {
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _endNamedRoute(route, previousRoute);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      _endNamedRoute(oldRoute, newRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _endNamedRoute(Route<dynamic> route, Route<dynamic>? nextRoute) {
    final screen = FirebaseScreens.byId(route.settings.name);
    if (screen == null) {
      return;
    }
    FirebaseAnalyticsManage.instance.endCurrentScreen(
      nextScreen: FirebaseScreens.byId(nextRoute?.settings.name),
    );
  }
}

class FirebaseRouteScreenTracker extends StatefulWidget {
  final FirebaseScreenInfo screen;
  final Widget child;

  const FirebaseRouteScreenTracker({
    super.key,
    required this.screen,
    required this.child,
  });

  @override
  State<FirebaseRouteScreenTracker> createState() =>
      _FirebaseRouteScreenTrackerState();
}

class _FirebaseRouteScreenTrackerState extends State<FirebaseRouteScreenTracker>
    with RouteAware {
  PageRoute<dynamic>? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic> && route != _route) {
      if (_route != null) {
        firebaseRouteObserver.unsubscribe(this);
      }
      _route = route;
      firebaseRouteObserver.subscribe(this, route);
      FirebaseAnalyticsManage.instance.enterScreen(widget.screen);
    }
  }

  @override
  void didPopNext() {
    FirebaseAnalyticsManage.instance.enterScreen(widget.screen);
  }

  @override
  void didPush() {
    FirebaseAnalyticsManage.instance.enterScreen(widget.screen);
  }

  @override
  void didPop() {
    FirebaseAnalyticsManage.instance.endCurrentScreen();
  }

  @override
  void dispose() {
    firebaseRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
