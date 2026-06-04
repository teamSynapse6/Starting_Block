import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LlmNotificationManage {
  LlmNotificationManage._();

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static const AndroidNotificationChannel _fcmChannel =
      AndroidNotificationChannel(
    'fcm_default',
    '앱 알림',
    description: '서버에서 발송한 앱 알림을 표시합니다.',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const macSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macSettings,
    );

    await _notifications.initialize(settings);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_fcmChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _notifications
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  static Future<void> showLlmComplete({
    required int announcementId,
    required String title,
    required String preview,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'llm_chat_complete',
      'AI 공고 분석 완료',
      channelDescription: 'AI 공고 분석 답변이 완료되었을 때 알림을 보냅니다.',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _notifications.show(
      announcementId,
      'AI 공고 분석이 완료됐어요',
      preview.isNotEmpty ? preview : title,
      details,
    );
  }

  static Future<void> showRemoteNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'fcm_default',
      '앱 알림',
      channelDescription: '서버에서 발송한 앱 알림을 표시합니다.',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
