import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/manage/firebase/firebase_screen.dart';
import 'package:starting_block/manage/model_manage.dart';

abstract class AnalyticsEventSink {
  Future<void> setUserId(String? userId);

  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
    required Map<String, Object> parameters,
  });

  Future<void> logEvent({
    required String name,
    required Map<String, Object> parameters,
  });
}

class FirebaseAnalyticsEventSink implements AnalyticsEventSink {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsEventSink({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  @override
  Future<void> setUserId(String? userId) {
    return _analytics.setUserId(id: userId);
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
    required Map<String, Object> parameters,
  }) {
    return _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
      parameters: parameters,
    );
  }

  @override
  Future<void> logEvent({
    required String name,
    required Map<String, Object> parameters,
  }) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }
}

typedef NowProvider = DateTime Function();

class FirebaseAnalyticsManage {
  FirebaseAnalyticsManage({
    required AnalyticsEventSink sink,
    NowProvider? now,
  })  : _sink = sink,
        _now = now ?? DateTime.now;

  static final FirebaseAnalyticsManage instance = FirebaseAnalyticsManage(
    sink: FirebaseAnalyticsEventSink(),
  );

  final AnalyticsEventSink _sink;
  final NowProvider _now;

  FirebaseScreenInfo? _currentScreen;
  FirebaseScreenInfo? _previousScreen;
  DateTime? _screenStartedAt;
  String _userId = 'guest';
  bool _isPaused = false;

  FirebaseScreenInfo? get currentScreen => _currentScreen;

  Future<void> initialize() async {
    final userId = await UserInfo.getUserId();
    await setAnalyticsUserId(userId);
  }

  Future<void> setAnalyticsUserId(String? userId) async {
    final normalized = userId == null || userId.isEmpty ? 'guest' : userId;
    _userId = normalized;
    try {
      await _sink.setUserId(normalized == 'guest' ? null : normalized);
    } catch (error) {
      debugPrint('Firebase Analytics setUserId failed: $error');
    }
  }

  Future<void> enterScreen(
    FirebaseScreenInfo? screen, {
    FirebaseScreenInfo? previousScreen,
  }) async {
    if (screen == null || !screen.trackEnabled) {
      return;
    }
    if (_currentScreen?.id == screen.id && !_isPaused) {
      return;
    }

    final endedScreen = _currentScreen;
    if (endedScreen != null && _screenStartedAt != null && !_isPaused) {
      await _logDuration(endedScreen, nextScreen: screen);
    }

    _previousScreen = previousScreen ?? endedScreen ?? _previousScreen;
    _currentScreen = screen;
    _screenStartedAt = _now();
    _isPaused = false;

    await _logScreenView(screen);
  }

  Future<void> endCurrentScreen({FirebaseScreenInfo? nextScreen}) async {
    final screen = _currentScreen;
    if (screen == null || _screenStartedAt == null || _isPaused) {
      return;
    }
    await _logDuration(screen, nextScreen: nextScreen);
    _previousScreen = screen;
    _currentScreen = null;
    _screenStartedAt = null;
  }

  Future<void> pauseCurrentScreen() async {
    if (_currentScreen == null || _screenStartedAt == null || _isPaused) {
      return;
    }
    await _logDuration(_currentScreen!);
    _screenStartedAt = null;
    _isPaused = true;
  }

  Future<void> resumeCurrentScreen() async {
    final screen = _currentScreen;
    if (screen == null || !_isPaused) {
      return;
    }
    _screenStartedAt = _now();
    _isPaused = false;
    await _logScreenView(screen);
  }

  Future<void> _logScreenView(FirebaseScreenInfo screen) async {
    try {
      await _sink.logScreenView(
        screenName: screen.id,
        screenClass: screen.className,
        parameters: {
          'previous_screen_name': _previousScreen?.id ?? 'none',
          'screen_label': screen.koreanName,
          'app_user_id': _userId,
        },
      );
      await _sink.logEvent(
        name: 'screen_enter',
        parameters: {
          'screen_id': screen.id,
          'screen_label': screen.koreanName,
          'screen_class': screen.className,
          'previous_screen_id': _previousScreen?.id ?? 'none',
          'app_user_id': _userId,
        },
      );
    } catch (error) {
      debugPrint('Firebase Analytics screen_view failed: $error');
    }
  }

  Future<void> _logDuration(
    FirebaseScreenInfo screen, {
    FirebaseScreenInfo? nextScreen,
  }) async {
    final startedAt = _screenStartedAt;
    if (startedAt == null) {
      return;
    }
    final duration = _now().difference(startedAt);
    try {
      await _sink.logEvent(
        name: 'screen_duration',
        parameters: {
          'screen_id': screen.id,
          'screen_label': screen.koreanName,
          'screen_class': screen.className,
          'previous_screen_id': _previousScreen?.id ?? 'none',
          'next_screen_id': nextScreen?.id ?? 'none',
          'duration_seconds': duration.inSeconds,
          'duration_milliseconds': duration.inMilliseconds,
          'app_user_id': _userId,
        },
      );
    } catch (error) {
      debugPrint('Firebase Analytics screen_duration failed: $error');
    }
  }
}

class FirebaseAnalyticsLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        FirebaseAnalyticsManage.instance.pauseCurrentScreen();
        break;
      case AppLifecycleState.resumed:
        FirebaseAnalyticsManage.instance.resumeCurrentScreen();
        break;
    }
  }
}
