import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:intl/intl.dart';

class BirthdayEdit extends StatefulWidget {
  const BirthdayEdit({super.key});

  @override
  State<BirthdayEdit> createState() => _BirthdayEditState();
}

class _BirthdayEditState extends State<BirthdayEdit> {
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
    // SaveUserData의 loadFromLocalAndFetchToServer 메서드를 호출하고 inputUserBirthday 매개변수로 넘깁니다.
    await SaveUserData.loadFromLocalAndFetchToServer(
        inputUserBirthday: _birthday.replaceAll('.', ''));
  }

  void _onNextTap() {
    if (!_isInputValid) return;
    _saveBirthday();
    Navigator.of(context).pop();
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
              Gaps.v20,
              Text(
                "생년월일을 입력해주세요",
                style: AppTextStyles.h5.copyWith(color: AppColors.g6),
              ),
              Gaps.v10,
              Text(
                "지원공고 맞춤 추천을 위해 사용됩니다",
                style: AppTextStyles.bd6.copyWith(color: AppColors.g6),
              ),
              Gaps.v31,
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
                    text: "저장",
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

class BirthdayInputFormatterEdit extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('.', '');

    // 8자리 입력 완료 시, 연도월일 체킹 로직 적용
    if (newText.length == 8) {
      String year = newText.substring(0, 4);
      String month = newText.substring(4, 6);
      String day = newText.substring(6);

      // 월이 1~12 범위를 벗어나면 조정
      int monthInt = int.parse(month);
      if (monthInt < 1 || monthInt > 12) month = '01';

      // 일이 1~31 범위를 벗어나면 조정 (실제 달의 일수는 체크하지 않음)
      int dayInt = int.parse(day);
      if (dayInt < 1 || dayInt > 31) day = '01';

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
