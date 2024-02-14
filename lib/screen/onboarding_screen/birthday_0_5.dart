import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:intl/intl.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  String _birthday = "";
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _birthdayController.addListener(_updateBirthday);
  }

  void _updateBirthday() {
    final input = _birthdayController.text.replaceAll('.', '');
    if (input.length == 8) {
      final currentDate = DateTime.now();
      final formattedDate = DateFormat('yyyyMMdd').format(currentDate);
      setState(() {
        _birthday = input;
        _isInputValid = input.compareTo(formattedDate) < 0 && input.length == 8;
      });
    } else {
      setState(() {
        _isInputValid = false;
      });
    }
  }

  Future<void> _saveBirthday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userBirthday', _birthday);
  }

  void _onNextTap() {
    if (!_isInputValid) return;
    _saveBirthday();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EnterprenutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const BackAppBar(),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v12,
              const OnBoardingState(thisState: 2),
              Gaps.v36,
              Text(
                "생년월일을 입력해주세요",
                style: AppTextStyles.h5.copyWith(color: AppColors.g6),
              ),
              Gaps.v10,
              Text(
                "지원공고 맞춤 추천을 위해 사용됩니다",
                style: AppTextStyles.bd6.copyWith(color: AppColors.g6),
              ),
              TextField(
                controller: _birthdayController,
                decoration: InputDecoration(
                  hintText: "연도월일 8자리로 입력해주세요",
                  hintStyle: AppTextStyles.bd2.copyWith(color: AppColors.g3),
                  counterText: "",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  BirthdayInputFormatter(),
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: Sizes.size24),
                child: GestureDetector(
                  onTap: _isInputValid ? _onNextTap : null,
                  child: NextContained(
                    text: "다음",
                    disabled: !_isInputValid,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BirthdayInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('.', '');
    if (newText.length > 8) {
      newText = newText.substring(0, 8);
    }
    if (newText.length > 4) {
      newText =
          '${newText.substring(0, 4)}.${newText.substring(4, 6)}${newText.length > 6 ? '.${newText.substring(6)}' : ''}';
    }
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
