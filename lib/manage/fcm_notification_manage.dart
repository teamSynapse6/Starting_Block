import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:starting_block/manage/firebase_options.dart';
import 'package:starting_block/manage/llm_notification_manage.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LlmNotificationManage.initialize();
  await FcmNotificationManage.showRemoteMessageAsLocalNotification(message);
}

class FcmNotificationManage {
  FcmNotificationManage._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _configureForegroundPresentation();
    await _logCurrentToken();

    FirebaseMessaging.onMessage.listen((message) async {
      await showRemoteMessageAsLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM notification opened: ${message.messageId}');
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('FCM initial notification: ${initialMessage.messageId}');
    }

    _messaging.onTokenRefresh.listen((token) {
      debugPrint('FCM token refreshed: $token');
      // TODO: 서버 FCM 토큰 등록 API가 준비되면 여기에서 갱신 토큰을 전송합니다.
    });

    _initialized = true;
  }

  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('FCM authorization status: ${settings.authorizationStatus}');
  }

  static Future<void> _configureForegroundPresentation() {
    return _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
  }

  static Future<void> _logCurrentToken() async {
    try {
      final token = await getToken();
      debugPrint('FCM token: $token');
      // TODO: 서버 FCM 토큰 등록 API가 준비되면 여기에서 최초 토큰을 전송합니다.
    } catch (error) {
      debugPrint('FCM token load failed: $error');
    }
  }

  static Future<String?> getToken() {
    return _messaging.getToken();
  }

  static Future<void> showRemoteMessageAsLocalNotification(
      RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ??
        message.data['title']?.toString() ??
        'AI 공고 분석이 완료됐어요';
    final body = notification?.body ??
        message.data['body']?.toString() ??
        message.data['preview']?.toString() ??
        '';

    await LlmNotificationManage.showRemoteNotification(
      id: message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }
}
