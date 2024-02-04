import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/offcampus_filter/model/filter_model.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RoadMapModel()),
        ChangeNotifierProvider(
            create: (context) => FilterModel()), // FilterModel 추가
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
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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
