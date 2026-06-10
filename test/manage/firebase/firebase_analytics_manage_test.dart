import 'package:flutter_test/flutter_test.dart';
import 'package:starting_block/manage/firebase/firebase_analytics_manage.dart';
import 'package:starting_block/manage/firebase/firebase_screen.dart';

class _RecordedEvent {
  final String name;
  final Map<String, Object> parameters;

  const _RecordedEvent(this.name, this.parameters);
}

class _FakeSink implements AnalyticsEventSink {
  final List<_RecordedEvent> events = [];
  String? userId;

  @override
  Future<void> setUserId(String? userId) async {
    this.userId = userId;
  }

  @override
  Future<void> logEvent({
    required String name,
    required Map<String, Object> parameters,
  }) async {
    events.add(_RecordedEvent(name, parameters));
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
    required Map<String, Object> parameters,
  }) async {
    events.add(_RecordedEvent('screen_view', {
      'screen_name': screenName,
      'screen_class': screenClass,
      ...parameters,
    }));
  }
}

void main() {
  test('first screen enter logs only screen_view', () async {
    final sink = _FakeSink();
    var now = DateTime(2026);
    final manager = FirebaseAnalyticsManage(
      sink: sink,
      now: () => now,
    );

    await manager.enterScreen(FirebaseScreens.homeMain);

    expect(sink.events.map((event) => event.name), [
      'screen_view',
      'screen_enter',
    ]);
    expect(sink.events.first.parameters['screen_name'], 'home_main');
    expect(sink.events.first.parameters['previous_screen_name'], 'none');
    expect(sink.events.last.parameters['screen_id'], 'home_main');
    expect(sink.events.last.parameters['previous_screen_id'], 'none');
  });

  test('screen transition logs duration then next screen_view', () async {
    final sink = _FakeSink();
    var now = DateTime(2026);
    final manager = FirebaseAnalyticsManage(
      sink: sink,
      now: () => now,
    );

    await manager.enterScreen(FirebaseScreens.homeMain);
    now = now.add(const Duration(seconds: 12, milliseconds: 300));
    await manager.enterScreen(FirebaseScreens.offcampusHome);

    expect(sink.events.map((event) => event.name), [
      'screen_view',
      'screen_enter',
      'screen_duration',
      'screen_view',
      'screen_enter',
    ]);
    expect(sink.events[2].parameters['screen_id'], 'home_main');
    expect(sink.events[2].parameters['next_screen_id'], 'offcampus_home');
    expect(sink.events[2].parameters['duration_seconds'], 12);
    expect(sink.events[2].parameters['duration_milliseconds'], 12300);
    expect(sink.events[3].parameters['previous_screen_name'], 'home_main');
  });

  test('guest user id is safe when no user_id is provided', () async {
    final sink = _FakeSink();
    final manager = FirebaseAnalyticsManage(
      sink: sink,
      now: () => DateTime(2026),
    );

    await manager.setAnalyticsUserId(null);
    await manager.enterScreen(FirebaseScreens.myprofileHome);

    expect(sink.userId, isNull);
    expect(sink.events.first.parameters['app_user_id'], 'guest');
  });

  test('endCurrentScreen logs duration with next screen', () async {
    final sink = _FakeSink();
    var now = DateTime(2026);
    final manager = FirebaseAnalyticsManage(
      sink: sink,
      now: () => now,
    );

    await manager.enterScreen(FirebaseScreens.roadmapHome);
    now = now.add(const Duration(seconds: 4));
    await manager.endCurrentScreen(nextScreen: FirebaseScreens.homeMain);

    expect(sink.events.map((event) => event.name), [
      'screen_view',
      'screen_enter',
      'screen_duration',
    ]);
    expect(sink.events[2].parameters['screen_id'], 'roadmap_home');
    expect(sink.events[2].parameters['next_screen_id'], 'home_main');
    expect(manager.currentScreen, isNull);
  });
}
