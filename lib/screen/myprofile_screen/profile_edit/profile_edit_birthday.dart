import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class BirthdayEdit extends StatefulWidget {
  const BirthdayEdit({super.key});

  @override
  State<BirthdayEdit> createState() => _BirthdayEditState();
}

class _BirthdayEditState extends State<BirthdayEdit> {
  final TextEditingController _birthdayController = TextEditingController();
  String _birthday = "";
  bool _isInputValid = false;
  String _birthAvailabilityMessage = "";
  bool _isCheacking = false;

  @override
  void initState() {
    super.initState();
    _birthdayController.addListener(_updateBirthday);
  }

  Future<void> _saveBirthday() async {
    await SaveUserData.loadFromLocalAndFetchToServer(
        inputUserBirthday: _birthday.replaceAll('.', ''));
  }

  void _onNextTap() async {
    if (!_isInputValid) return;
    _saveBirthday();
    await Future.delayed(const Duration(milliseconds: 200)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _updateBirthday() {
    final input = _birthdayController.text.replaceAll('.', '');
    if (input.length == 8) {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        _isCheacking = true;
      });
      // 연, 월, 일로 분리
      final int year = int.parse(input.substring(0, 4));
      final int month = int.parse(input.substring(4, 6));
      final int day = int.parse(input.substring(6, 8));

      // 월과 일의 유효성 검사를 위해 DateTime 객체 생성
      DateTime? birthday;
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
        Future.delayed(const Duration(milliseconds: 500), () {
          _onNextTap();
          _isCheacking = false;
        });
      } else {
        setState(() {
          _isInputValid = false;
          _birthAvailabilityMessage = "생년월일을 한번 더 확인해주세요";
          _isCheacking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePopWrapper(
      ignoring: _isCheacking,
      canPop: !_isCheacking,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: const BackAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v20,
                    Text(
                      "생년월일을 입력해 주세요",
                      style: AppTextStyles.h5.copyWith(color: AppColors.g6),
                    ),
                    Gaps.v32,
                    TextField(
                      controller: _birthdayController,
                      decoration: InputDecoration(
                        hintText: "YYYY.MM.DD",
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
      ),
    );
  }
}
