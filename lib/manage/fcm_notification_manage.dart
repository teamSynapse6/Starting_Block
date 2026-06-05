import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:starting_block/manage/api/fcm_api_manage.dart';
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
      debugPrint('Foreground FCM: ${message.notification?.title}');
      if (_shouldShowLocalNotificationInForeground(message)) {
        await showRemoteMessageAsLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM notification opened: ${message.messageId}');
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('FCM initial notification: ${initialMessage.messageId}');
    }

    _messaging.onTokenRefresh.listen((token) async {
      debugPrint('FCM token refreshed: $token');
      await registerCurrentToken();
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
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> _logCurrentToken() async {
    try {
      final token = await getToken();
      debugPrint('FCM token: $token');
    } catch (error) {
      debugPrint('FCM token load failed: $error');
    }
  }

  static Future<String?> getToken() {
    return _messaging.getToken();
  }

  static Future<String?> registerCurrentToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return token;
    }
    final success = await FcmApiManage.registerToken(token);
    debugPrint(
        'FCM token register ${success ? 'succeeded' : 'skipped/failed'}');
    return token;
  }

  static Future<bool> deleteCurrentToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return false;
    }
    return FcmApiManage.deleteToken(token);
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

  static bool _shouldShowLocalNotificationInForeground(RemoteMessage message) {
    final isApplePlatform = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    if (!isApplePlatform) {
      return true;
    }

    // iOS/macOS는 foreground presentation 옵션으로 notification payload를
    // 시스템 배너로 표시합니다. data-only 메시지는 로컬 알림으로 fallback합니다.
    return message.notification == null;
  }
}
