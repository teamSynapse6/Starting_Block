import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _onNextTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NickNameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.v234,
            Text(
              "단계별 지원으로 한 단계 도약하기",
              style: AppTextStyles.bd2.copyWith(
                color: AppColors.g6,
              ),
            ),
            const Text(
              "대학생 창업 헬퍼 서비스는",
              style: TextStyle(
                color: AppColors.g6,
                fontFamily: "pretendard",
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v40,
            const Text(
              "스타팅블록",
              style: TextStyle(
                color: AppColors.blue,
                fontFamily: "score",
                fontSize: 50,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                bottom: Sizes.size140,
              ),
              child: GestureDetector(
                  onTap: _onNextTap,
                  child: FractionallySizedBox(
                    child: Container(
                      padding: const EdgeInsets.all(Sizes.size14),
                      decoration: const BoxDecoration(
                        color: Color(0XFFFEE500),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image(
                              image: AppImages.kako_icon,
                              height: 18,
                              width: 18,
                            ),
                          ),
                          Text(
                            "카카오로 로그인",
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.bd3.copyWith(color: AppColors.g6),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
