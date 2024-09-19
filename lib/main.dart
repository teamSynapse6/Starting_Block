import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  initializeDateFormatting('ko_KR', null); // GPT 채팅에서 시간 표시를 위한 초기화

  // 네비게이션 바의 색상 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.white, // 네비게이션 바 색상
  ));

  // Kakao 로그인 초기화
  KakaoSdk.init(
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
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(
                  1.0)), //전역적으로 시스템 폰트의 크기의 영향을 받지 않겠다고 선언.
          child: child!,
        );
      },
      home: const SplashScreen(),
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

    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                _isLogIned ? const IntergrateScreen() : const LoginScreen(),
          ),
        );
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.white, // 원래 색상으로 설정
        ));
      },
    );
  }

  void loadLogInStatus() async {
    bool isLogIned = await UserInfo.getLoginStatus();
    if (isLogIned) {
      await SaveUserData.fetchAndSaveUserData();
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
