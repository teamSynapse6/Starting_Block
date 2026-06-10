import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:starting_block/manage/firebase_options.dart';
import 'package:starting_block/manage/firebase/firebase_fcm_manage.dart';
import 'package:starting_block/manage/firebase/firebase_analytics_manage.dart';
import 'package:starting_block/manage/firebase/firebase_screen_observer.dart';
import 'package:starting_block/manage/llm/llm_notification_manage.dart';

final FirebaseAnalyticsLifecycleObserver _analyticsLifecycleObserver =
    FirebaseAnalyticsLifecycleObserver();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  await FlutterGemma.initialize();
  await initializeDateFormatting('ko_KR', null); // LLM 채팅에서 시간 표시를 위한 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAnalyticsManage.instance.initialize();
  WidgetsBinding.instance.addObserver(_analyticsLifecycleObserver);
  await LlmNotificationManage.initialize();
  await FcmNotificationManage.initialize();

  // 네비게이션 바의 색상 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.white, // 네비게이션 바 색상
  ));

  // Kakao 로그인 초기화
  await KakaoSdk.init(
    nativeAppKey: '49b9cdd5c3366e805ef2180657040178',
    javaScriptAppKey: '5e1919efb19e574a2d9929e51b51c5a7',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FilterModel()),
        ChangeNotifierProvider(create: (context) => OnCaFilterModel()),
        ChangeNotifierProvider(create: (context) => UserInfo()),
        ChangeNotifierProvider(create: (context) => BookMarkNotifier()),
        ChangeNotifierProvider(create: (context) => UserTokenManage()),
      ],
      child: const StartingBlock(),
    ),
  );
}

class StartingBlock extends StatelessWidget {
  const StartingBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeManage.theme,
      navigatorObservers: [
        firebaseRouteObserver,
        FirebaseScreenObserver(),
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(
                  1.0)), //전역적으로 시스템 폰트의 크기의 영향을 받지 않겠다고 선언.
          child: child!,
        );
      },
      home: const FirebaseRouteScreenTracker(
        screen: FirebaseScreens.splash,
        child: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool _isLogIned = false;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    loadLogInStatus();

    // SplashScreen에서 시스템 네비게이션 바 색상 설정
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.blue, // 네비게이션 바 색상
      ),
    );

    _navigationTimer = Timer(
      const Duration(milliseconds: 1000),
      () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            trackedRoute(
              screen: _isLogIned
                  ? FirebaseScreens.intergrate
                  : FirebaseScreens.onboardingLogin,
              builder: (context) =>
                  _isLogIned ? const IntergrateScreen() : const LoginScreen(),
            ),
          );
        }
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.white, // 원래 색상으로 설정
        ));
      },
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void loadLogInStatus() async {
    bool isLogIned = await UserInfo.getLoginStatus();
    if (isLogIned) {
      try {
        await SaveUserData.fetchAndSaveUserData();
        await FcmNotificationManage.registerCurrentToken();
      } catch (error) {
        debugPrint('로그인 상태 확인 중 오류 발생: $error');
        isLogIned = false;
        await UserInfo().setLoginStatus(false);
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _isLogIned = isLogIned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: Stack(
        children: <Widget>[
          Center(
            child: Image(
              image: AppIcon.logo_512,
              width: 180.0,
              height: 180.0,
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              "스타팅블록",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "score",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
