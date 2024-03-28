// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/gpt_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';

class OffCampusGptChat extends StatefulWidget {
  final String thisTitle;
  final String thisID;

  const OffCampusGptChat({
    super.key,
    required this.thisTitle,
    required this.thisID,
  });

  @override
  State<OffCampusGptChat> createState() => _OffCampusGptChatState();
}

class _OffCampusGptChatState extends State<OffCampusGptChat> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyped = false;
  String? _threadId;
  List<Message> _messages = [];
  bool _isLoading = false; // Changed variable name from _isLoaded to _isLoading

  @override
  void initState() {
    super.initState();
    initializeWidget();
    _ensureLocalFileExists().then((_) {
      _loadMessages().then((loadedMessages) {
        setState(() {
          _messages = loadedMessages;
        });
      });
    });
    _controller.addListener(_handleTextInputChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTextInputChange() {
    _controller.addListener(() {
      if (_controller.text.isNotEmpty && !_isTyped) {
        setState(() {
          _isTyped = true;
        });
      } else if (_controller.text.isEmpty && _isTyped) {
        setState(() {
          _isTyped = false;
        });
      }
    });
  }

  void initializeWidget() async {
    await _getThreadId();
    if (_threadId == null) {
      await _getGptStart();
    } else {
      await _deleteGptEnd();
      await _getGptStart();
    }
  }

  //Userinfo에 저장된 threadId를 가져옵니다.
  Future<void> _getThreadId() async {
    String threadId = await UserInfo.getGptThreadID();
    _threadId = threadId;
  }

  //대화 시작을 위한 쓰레드 생성 메소드
  Future<void> _getGptStart() async {
    if (_threadId == null) {
      String threadId = await GptApi.getGptStart();
      UserInfo().setGptThreadID(threadId);
      _threadId = threadId;
    }
  }

  //쓰레드 삭제 메소드
  Future<void> _deleteGptEnd() async {
    if (_threadId != null) {
      await GptApi.deleteGptEnd(_threadId!);
      UserInfo().setGptThreadID('');
      _threadId = null;
    }
  }

  Future<void> _postGptChat(String message) async {
    setState(() {
      _isLoading = true; // Changed _isLoaded to _isLoading
    });
    String thisMessage = '${widget.thisID}에서 찾아줘, $message';
    if (_threadId != null) {
      String chatResponse =
          await GptApi.postGptChat(_threadId!, widget.thisID, thisMessage);
      final currentTime = DateTime.now();
      final formattedTime = int.parse(
          '${currentTime.year}${currentTime.month.toString().padLeft(2, '0')}${currentTime.day.toString().padLeft(2, '0')}${currentTime.hour.toString().padLeft(2, '0')}${currentTime.minute.toString().padLeft(2, '0')}');

      setState(() {
        // 응답 메시지를 리스트에 추가
        _messages.add(
            Message(isUser: false, message: chatResponse, time: formattedTime));
        _isLoading = false; // Changed _isLoaded to _isLoading
      });

      // 변경된 대화 내용을 파일에 저장
      await _saveMessages(_messages);
    }
  }

  /* 파일 저장 관련 메소드 */
  Future<void> _ensureLocalFileExists() async {
    final file = await _getLocalFile();
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode([])); // 초기 빈 JSON 배열을 파일에 쓰기
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/chat_data/${widget.thisID}.json');
  }

  Future<void> _saveMessages(List<Message> messages) async {
    final file = await _getLocalFile();
    // 메시지 리스트를 JSON으로 변환하여 저장
    final String encodedData =
        json.encode(messages.map((msg) => msg.toJson()).toList());
    await file.writeAsString(encodedData);
  }

  Future<List<Message>> _loadMessages() async {
    try {
      final file = await _getLocalFile();
      // 파일의 내용을 읽기
      final String encodedData = await file.readAsString();
      // JSON 데이터를 Dart 객체로 변환
      final List<dynamic> jsonData = json.decode(encodedData);
      return jsonData.map((data) => Message.fromJson(data)).toList();
    } catch (e) {
      // 파일이 존재하지 않거나 읽을 수 없는 경우 빈 리스트 반환
      return [];
    }
  }

  // _buildSendMessageButton 메소드를 만들어서 '보내기' 버튼을 구성합니다.
  Widget _buildSendMessageButton() {
    return GestureDetector(
      onTap: _isTyped
          ? () async {
              final messageText = _controller.text;
              final currentTime = DateTime.now();
              final formattedTime = int.parse(
                  '${currentTime.year}${currentTime.month.toString().padLeft(2, '0')}${currentTime.day.toString().padLeft(2, '0')}${currentTime.hour.toString().padLeft(2, '0')}${currentTime.minute.toString().padLeft(2, '0')}');

              // 사용자 메시지를 _messages 리스트에 추가
              setState(() {
                _messages.add(Message(
                    isUser: true, message: messageText, time: formattedTime));
              });
              // 메시지 전송
              await _postGptChat(messageText);
              // 입력 필드 초기화
              _controller.clear();
              setState(() {
                _isTyped = false;
              });
              // 대화 내용을 파일에 저장
              await _saveMessages(_messages);
            }
          : null,
      child: SizedBox(
        width: 24,
        height: 24,
        child: _isTyped ? AppIcon.send_actived : AppIcon.send_inactived,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.g1,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _deleteGptEnd();
              Navigator.pop(context);
            },
            child: AppIcon.back,
          ),
          titleSpacing: 4,
          title: Text(
            "AI와 첨부 파일 대화",
            style: AppTextStyles.st2.copyWith(color: AppColors.g6),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '청년 취창업 멘토링 시범운영 개시 및 멘티 모집',
                  style: AppTextStyles.bd3.copyWith(color: AppColors.g5),
                ),
              ),
            ),
          ),
        ),
        body: StatefulBuilder(
          builder: (context, setState) {
            return ListView.builder(
              itemCount: _messages.length +
                  (_isLoading ? 1 : 0), // Changed _isLoaded to _isLoading

              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  // 마지막 아이템이 로딩 인디케이터
                  return const Center(child: CircularProgressIndicator());
                }
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: message.isUser ? AppColors.blue : AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      message.message,
                      style: message.isUser
                          ? AppTextStyles.bd4.copyWith(color: AppColors.white)
                          : AppTextStyles.bd4.copyWith(color: AppColors.black),
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: BottomAppBar(
            height: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: AppColors.g2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _controller,
                        cursorColor: AppColors.g6,
                        minLines: 1,
                        maxLines: null,
                        style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                            bottom: 9,
                            top: -9,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gaps.h8,
                  _buildSendMessageButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
