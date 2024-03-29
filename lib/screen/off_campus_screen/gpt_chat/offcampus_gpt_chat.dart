// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final ScrollController _scrollController = ScrollController();
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
          _scrollToBottom();
          print('메시지 리스트: $_messages');
        });
      });
    });
    _controller.addListener(_handleTextInputChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
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

  //메시지 보내기 메소드
  Future<void> _postGptChat(String message) async {
    setState(() {
      _isLoading = true; // Changed _isLoaded to _isLoading
    });
    // String thisMessage = '${widget.thisID}에서 찾아줘, $message';
    String thisMessage = '1003에서 찾아줘, $message';

    if (_threadId != null) {
      String chatResponse =
          // await GptApi.postGptChat(_threadId!, widget.thisID, thisMessage);
          await GptApi.postGptChat(_threadId!, '1003', thisMessage);
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

// 메시지 목록을 SharedPreferences에 저장합니다.
  Future<void> _saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedData =
        jsonEncode(messages.map((msg) => msg.toJson()).toList());
    await prefs.setString('chat_${widget.thisID}', encodedData);
  }

// SharedPreferences에서 메시지 목록을 불러옵니다.
  Future<List<Message>> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('chat_${widget.thisID}');
    if (encodedData == null) {
      return [];
    }
    List<dynamic> jsonData = jsonDecode(encodedData);
    return jsonData.map((data) => Message.fromJson(data)).toList();
  }

  // _buildSendMessageButton 메소드를 만들어서 '보내기' 버튼을 구성합니다.
  Widget _buildSendMessageButton() {
    return GestureDetector(
      onTap: _isTyped && !_isLoading
          ? () async {
              FocusScope.of(context).unfocus();
              _scrollToBottom();
              final messageText = _controller.text;
              final currentTime = DateTime.now();
              final formattedTime = int.parse(
                  '${currentTime.year}${currentTime.month.toString().padLeft(2, '0')}${currentTime.day.toString().padLeft(2, '0')}${currentTime.hour.toString().padLeft(2, '0')}${currentTime.minute.toString().padLeft(2, '0')}');

              // 사용자 메시지를 _messages 리스트에 추가
              setState(() {
                _messages.add(Message(
                    isUser: true, message: messageText, time: formattedTime));
              });
              _controller.clear();
              // 메시지 전송
              await _postGptChat(messageText);
              // 입력 필드 초기화
              setState(() {
                _isTyped = false;
              });
              // 대화 내용을 파일에 저장
              await _saveMessages(_messages);
              _scrollToBottom();
            }
          : null,
      child: SizedBox(
        width: 24,
        height: 24,
        child: _isTyped ? AppIcon.send_actived : AppIcon.send_inactived,
      ),
    );
  }

  /*스크롤 메소드*/
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

// 메시지의 시간을 형식화하는 함수
  String _formatMessageTime(int messageTime) {
    String dateTimeString = messageTime.toString();
    String formattedString =
        "${dateTimeString.substring(0, 4)}-${dateTimeString.substring(4, 6)}-${dateTimeString.substring(6, 8)} ${dateTimeString.substring(8, 10)}:${dateTimeString.substring(10, 12)}";
    DateTime dateTime = DateTime.parse(formattedString);
    String formattedTime = DateFormat('a h:mm', 'ko_KR').format(dateTime);
    formattedTime = formattedTime.replaceAll('AM', '오전').replaceAll('PM', '오후');
    return formattedTime;
  }

  //해당일의 첫 대화에 중앙 날짜 표시 메소드
  DateTime _parseMessageDateTime(int messageTime) {
    String dateTimeString = messageTime.toString();
    String formattedString =
        "${dateTimeString.substring(0, 4)}-${dateTimeString.substring(4, 6)}-${dateTimeString.substring(6, 8)} ${dateTimeString.substring(8, 10)}:${dateTimeString.substring(10, 12)}";
    return DateTime.parse(formattedString);
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
                  widget.thisTitle,
                  style: AppTextStyles.bd3.copyWith(color: AppColors.g5),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  // 마지막 아이템이 로딩 인디케이터
                  return const Center(child: CircularProgressIndicator());
                }
                final message = _messages[index];
                final isFirstItem = index == 0;
                final isLastItem = index == _messages.length - 1;

                final messageDate = _parseMessageDateTime(message.time);
                bool isFirstMessageOfDay = false;
                if (index == 0 ||
                    _parseMessageDateTime(_messages[index - 1].time).day !=
                        messageDate.day) {
                  isFirstMessageOfDay = true;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isFirstMessageOfDay)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.g3,
                              ),
                            ),
                            Gaps.h18,
                            Text(
                              DateFormat('yyyy년 MM월 dd일').format(messageDate),
                              style: AppTextStyles.bd6
                                  .copyWith(color: AppColors.g4),
                            ),
                            Gaps.h18,
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.g3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: isFirstItem ? 10 : 0,
                        bottom: isLastItem ? 10 : 0,
                        left: 16,
                        right: 16,
                      ),
                      child: Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: message.isUser
                            ? Padding(
                                padding: !message.isUser
                                    ? const EdgeInsets.only(bottom: 22)
                                    : const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _formatMessageTime(message.time),
                                      style: AppTextStyles.caption
                                          .copyWith(color: AppColors.g3),
                                    ),
                                    Gaps.h4,
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 360 *
                                            (232 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .width),
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.blue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 9),
                                        child: Text(
                                          message.message,
                                          style: AppTextStyles.bd4
                                              .copyWith(color: AppColors.g1),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Padding(
                                padding: message.isUser
                                    ? const EdgeInsets.only(bottom: 22)
                                    : const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.blue,
                                      child: AppIcon.starting_block_icon,
                                    ),
                                    Gaps.h4,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '스타팅블록',
                                          style: AppTextStyles.bd6
                                              .copyWith(color: AppColors.g5),
                                        ),
                                        Gaps.v4,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: 360 *
                                                    (232 /
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width),
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 9),
                                                child: Text(
                                                  message.message,
                                                  style: AppTextStyles.bd4
                                                      .copyWith(
                                                          color:
                                                              AppColors.black),
                                                ),
                                              ),
                                            ),
                                            Gaps.h4,
                                            Text(
                                              _formatMessageTime(message.time),
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                      color: AppColors.g3),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const Positioned(
              bottom: 0,
              child: BottomGradient(),
            ),
          ],
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
                        enabled: !_isLoading,
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
