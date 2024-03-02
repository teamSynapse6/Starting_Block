// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/system_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';

class NickNameEdit extends StatefulWidget {
  const NickNameEdit({super.key});

  @override
  State<NickNameEdit> createState() => _NickNameEditState();
}

class _NickNameEditState extends State<NickNameEdit> {
  final TextEditingController _nicknameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _nickname = "";
  bool _isNicknameAvailable = false;
  String _nicknameAvailabilityMessage = "";
  bool _isNicknameChecked = false;
  bool _isInputStarted = false;
  String _uuid = "";

  @override
  void initState() {
    super.initState();
    _initNickname();
    _loadUUID();
    _nicknameController.addListener(() {
      final currentText = _nicknameController.text;
      if (!_isInputStarted && currentText.isNotEmpty) {
        setState(() {
          _isInputStarted = true;
        });
      }
      if (_isNicknameChecked && _nickname != currentText) {
        setState(() {
          _isNicknameChecked = false; // 중복 확인 상태를 비활성화
        });
      }
      setState(() {
        _nickname = currentText;
        _updateNicknameValidation();
      });
    });
  }

  void _updateNicknameValidation() {
    final isValidLength = _nickname.length >= 2 && _nickname.length <= 10;
    final hasNoSpaces = !_nickname.contains(' ');
    final isValidCharacters = RegExp(r'^[가-힣a-zA-Z0-9]+$').hasMatch(_nickname);

    setState(() {
      _isNicknameAvailable = isValidLength && hasNoSpaces && isValidCharacters;
      _nicknameAvailabilityMessage =
          isValidLength && hasNoSpaces && isValidCharacters
              ? ""
              : "닉네임은 한글, 영문, 숫자만 사용 가능하며, 2자에서 10자 사이로 입력해주세요";
    });
  }

  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요';
    }
    if (value.contains(' ')) {
      return '띄어쓰기 없이 입력해주세요';
    }
    if (!RegExp(r'^[가-힣a-zA-Z0-9]+$').hasMatch(value)) {
      return '닉네임은 한글, 영문, 숫자만 사용 가능합니다';
    }
    if (value.length < 2 || value.length > 10) {
      return '닉네임은 2자에서 10자 사이로 입력해주세요';
    }
    // 중복 확인은 여기서 하지 않음
    return null;
  }

  void _onCheckNickname() async {
    if (_nickname.isEmpty) {
      return;
    }

    // 서버에 닉네임 중복 검사 요청
    try {
      final isAvailable = await SystemApiManage.getNickNameCheck(_nickname);
      setState(() {
        _isNicknameChecked = true; // 중복 확인 완료
        _isNicknameAvailable = isAvailable;
        _nicknameAvailabilityMessage =
            isAvailable ? "사용 가능한 닉네임입니다" : "이미 사용 중인 닉네임입니다";
      });
    } catch (e) {
      // 에러 처리
      setState(() {
        _nicknameAvailabilityMessage = "닉네임 중복 검사 중 오류가 발생했습니다";
        _isNicknameAvailable = false;
      });
    }
  }

  Future<void> _initNickname() async {
    // UserInfo에서 현재 닉네임을 가져와서 TextField에 설정
    String currentNickname = await UserInfo.getNickName();
    _nicknameController.text = currentNickname;
  }

  Future<void> _loadUUID() async {
    String uuid = await UserInfo.getUserUUID();
    setState(() {
      _uuid = uuid;
    });
  }

  void _onNextTap() async {
    final userInfo = Provider.of<UserInfo>(context, listen: false);

    bool changeSuccess = await SystemApiManage.getChangeNickName(
        _uuid, _nicknameController.text);
    if (changeSuccess) {
      await userInfo.setNickName(_nicknameController.text);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _nicknameAvailabilityMessage = "닉네임 변경에 실패했습니다. 다른 닉네임을 시도해주세요.";
        _isNicknameAvailable = false;
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
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v20,
                Text(
                  "닉네임을 설정해 주세요",
                  style: AppTextStyles.h5.copyWith(color: AppColors.g6),
                ),
                Gaps.v10,
                Text(
                  "닉네임은 다른 사용자들에게 공개됩니다",
                  style: AppTextStyles.bd6.copyWith(color: AppColors.g6),
                ),
                Gaps.v32,
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    hintText: "닉네임을 입력해주세요",
                    hintStyle: AppTextStyles.bd2.copyWith(color: AppColors.g3),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _isInputStarted && !_isNicknameAvailable
                            ? AppColors.activered
                            : AppColors.g2,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _isInputStarted && !_isNicknameAvailable
                            ? AppColors.activered
                            : AppColors.g2,
                      ),
                    ),
                    suffixIcon: Align(
                      alignment: Alignment.centerRight,
                      widthFactor: 1.0,
                      child: GestureDetector(
                        onTap: _isNicknameAvailable &&
                                _formKey.currentState?.validate() == true
                            ? _onCheckNickname
                            : null,
                        child: Container(
                          width: Sizes.size72,
                          height: Sizes.size35,
                          decoration: ShapeDecoration(
                            color: _isNicknameAvailable &&
                                    _formKey.currentState?.validate() == true
                                ? AppColors.bluedark
                                : AppColors.g2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '중복 확인',
                              style: AppTextStyles.btn1
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  validator: _validateNickname,
                ),
                if (_nickname.isNotEmpty) // 닉네임 입력 중 메시지 표시
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _nicknameAvailabilityMessage,
                      style: AppTextStyles.caption.copyWith(
                        color: _isNicknameAvailable
                            ? AppColors.blue
                            : AppColors.activered,
                      ),
                    ),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: Sizes.size24,
                  ),
                  child: GestureDetector(
                    onTap: _isNicknameAvailable &&
                            _isNicknameChecked &&
                            _formKey.currentState?.validate() == true
                        ? _onNextTap
                        : null,
                    child: NextContained(
                      text: "저장",
                      disabled: !_isNicknameAvailable || !_isNicknameChecked,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
