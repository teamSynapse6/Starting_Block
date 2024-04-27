import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  String _birthday = "";
  bool _isInputValid = false;
  String _birthAvailabilityMessage = "";

  @override
  void initState() {
    super.initState();
    _birthdayController.addListener(_updateBirthday);
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

  void _updateBirthday() {
    final input = _birthdayController.text.replaceAll('.', '');
    if (input.length == 8) {
      // 연, 월, 일로 분리
      final int year = int.parse(input.substring(0, 4));
      final int month = int.parse(input.substring(4, 6));
      final int day = int.parse(input.substring(6, 8));

      // 월과 일의 유효성 검사를 위해 DateTime 객체 생성
      DateTime? birthday;
      // 유효하지 않은 날짜를 처리하기 위해 예외 처리 로직이 필요하지 않음. DateTime은 자동으로 조정하지만, 유효하지 않은 월/일에 대해서는 별도로 검증
      birthday = DateTime(year, month, day);

      final DateTime currentDate = DateTime.now();
      final bool isDateValid = birthday.year == year &&
          birthday.month == month &&
          birthday.day == day;
      final bool isDateBeforeCurrent = birthday.isBefore(currentDate);

      setState(() {
        _birthday = input;
        _isInputValid = isDateValid && isDateBeforeCurrent;
      });
      // _isInputValid가 true로 업데이트된 후, _onNextTap() 자동 호출
      if (_isInputValid) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _onNextTap();
        });
      } else {
        setState(() {
          _isInputValid = false;
          _birthAvailabilityMessage = "생년월일을 한번 더 확인해주세요";
        });
      }
    } else {
      setState(() {
        _isInputValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const BackAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OnBoardingState(thisState: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v52,
                  Text(
                    "생년월일을 입력해주세요",
                    style: AppTextStyles.h5.copyWith(color: AppColors.g6),
                  ),
                  Gaps.v42,
                  TextField(
                    controller: _birthdayController,
                    decoration: InputDecoration(
                      hintText: "연도월일 8자리로 입력해주세요",
                      hintStyle:
                          AppTextStyles.bd2.copyWith(color: AppColors.g3),
                      counterText: "",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _birthdayController.text.length == 10
                              ? _isInputValid
                                  ? AppColors.blue
                                  : AppColors.activered
                              : AppColors.g3,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      BirthdayInputFormatter(),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  Gaps.v4,
                  if (_birthdayController.text.length == 10 && !_isInputValid)
                    Text(
                      _birthAvailabilityMessage,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.activered),
                    )
                ],
              ),
            ),
          ],
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

    // 8자리 입력 완료 시, 연도월일 체킹 로직 적용
    if (newText.length == 8) {
      String year = newText.substring(0, 4);
      String month = newText.substring(4, 6);
      String day = newText.substring(6);

      newText = '$year$month$day';
    }

    // 날짜 형식에 맞게 점 추가
    String formattedText = _formatText(newText);

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatText(String text) {
    String formattedText = text;
    if (text.length > 4) {
      formattedText = text.substring(0, 4);
      if (text.length > 6) {
        formattedText += '.${text.substring(4, 6)}.${text.substring(6)}';
      } else {
        formattedText += '.${text.substring(4)}';
      }
    }
    return formattedText;
  }
}
