import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화

  // 네비게이션 바의 색상 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.white, // 네비게이션 바 색상
  ));

//kakao login
  KakaoSdk.init(
    nativeAppKey: '49b9cdd5c3366e805ef2180657040178',
    javaScriptAppKey: '5e1919efb19e574a2d9929e51b51c5a7',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RoadMapModel()),
        ChangeNotifierProvider(create: (context) => FilterModel()),
        ChangeNotifierProvider(create: (context) => OnCaFilterModel()),
        ChangeNotifierProvider(create: (context) => UserInfo()),
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
      home: const IntergrateScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // SplashScreen에서 시스템 네비게이션 바 색상 설정
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.blue, // 네비게이션 바 색상
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // 다른 화면의 네비게이션 바 색상
        ));
      },
    );
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
