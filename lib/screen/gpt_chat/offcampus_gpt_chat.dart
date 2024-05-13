// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/gpt_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

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
    _loadMessages().then((loadedMessages) {
      setState(() {
        _messages = loadedMessages;
        _scrollToBottom();
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

// 메시지 보내기 메소드
  Future<void> _postGptChat(String message) async {
    setState(() {
      _isLoading = true;
    });

    String thisMessage = '${widget.thisID}에서찾아. $message';

    try {
      if (_threadId != null) {
        String chatResponse = await GptApi.postGptChat(_threadId!, thisMessage);
        final currentTime = DateTime.now();
        final formattedTime = _formatCurrentTime(currentTime);
        print('보낸 메시지: $thisMessage, ID: $_threadId');

        setState(() {
          _messages.add(Message(
            isUser: false,
            message: chatResponse,
            time: formattedTime,
          ));
          _isLoading = false;
        });

        await _saveMessages(_messages);
        _scrollToBottom();
      }
    } catch (e) {
      // 에러 처리 및 사용자에게 에러 메시지 표시
      final currentTime = DateTime.now();
      final formattedTime = _formatCurrentTime(currentTime);

      setState(() {
        _messages.add(Message(
            isUser: false,
            message:
                "답변을 찾는 과정에서 오류가 발생했습니다.\n자세한 내용으로 물어보면 더 정확한 답변을 찾을 수 있습니다.",
            time: formattedTime));
        _isLoading = false;
      });

      await _saveMessages(_messages);
      await _deleteGptEnd();
      await _getGptStart();
      _scrollToBottom();
    }
  }

  int _formatCurrentTime(DateTime currentTime) {
    return int.parse(
        '${currentTime.year}${currentTime.month.toString().padLeft(2, '0')}${currentTime.day.toString().padLeft(2, '0')}${currentTime.hour.toString().padLeft(2, '0')}${currentTime.minute.toString().padLeft(2, '0')}');
  }

// 메시지 목록과 대화 제목을 SharedPreferences에 저장합니다.
  Future<void> _saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();

    // 메시지 데이터를 JSON 형식으로 인코딩합니다.
    String encodedData = jsonEncode({
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'title': widget.thisTitle // 제목 정보 추가
    });

    // SharedPreferences에 JSON 문자열을 저장합니다.
    await prefs.setString('chat_${widget.thisID}', encodedData);
  }

// SharedPreferences에서 메시지 목록을 불러옵니다.
  Future<List<Message>> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('chat_${widget.thisID}');
    if (encodedData == null) {
      return [];
    }

    // JSON 데이터를 Map<String, dynamic>으로 파싱합니다.
    Map<String, dynamic> jsonData = jsonDecode(encodedData);
    List<dynamic> messageData =
        jsonData['messages']; // 'messages' 키를 사용하여 메시지 배열을 추출

    // messageData를 List<Message>로 변환
    return messageData.map((data) => Message.fromJson(data)).toList();
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
            "AI로 공고 분석하기",
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bd3.copyWith(color: AppColors.g5),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            _messages.isEmpty
                ? Column(
                    children: [
                      Gaps.v16,
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
                              DateFormat('yyyy년 MM월 dd일')
                                  .format(DateTime.now()),
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
                      Gaps.v24,
                      Center(
                        child: Text(
                          '오늘은 어떤 도움이 필요하세요?\nAI와 공고의 첨푸파일 관련 대화를 시작해 보세요.',
                          style:
                              AppTextStyles.btn2.copyWith(color: AppColors.g4),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        // 마지막 아이템이 로딩 인디케이터
                        return Padding(
                          padding: const EdgeInsets.only(left: 24, bottom: 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.blue,
                                child: AppIcon.chatting_icon,
                              ),
                              Gaps.v8,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      height: 38,
                                      child: AppAnimation
                                          .chatting_progress_indicator),
                                  Gaps.h4,
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      final message = _messages[index];
                      final isFirstItem = index == 0;
                      final isLastItem = index == _messages.length - 1;

                      final messageDate = _parseMessageDateTime(message.time);
                      bool isFirstMessageOfDay = false;
                      if (index == 0 ||
                          _parseMessageDateTime(_messages[index - 1].time)
                                  .day !=
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
                                    DateFormat('yyyy년 MM월 dd일')
                                        .format(messageDate),
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
                              bottom: isLastItem && !_isLoading ? 10 : 0,
                              left: 24,
                              right: 24,
                            ),
                            child: Align(
                              alignment: message.isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: message.isUser
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 22),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _formatMessageTime(message.time),
                                            style: AppTextStyles.caption
                                                .copyWith(color: AppColors.g4),
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
                                                        color: AppColors.g1),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 22),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: AppColors.blue,
                                            child: AppIcon.chatting_icon,
                                          ),
                                          Gaps.v8,
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: 360 *
                                                      (252 /
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 9),
                                                  child: Text(
                                                    message.message,
                                                    style: AppTextStyles.bd4
                                                        .copyWith(
                                                            color: AppColors
                                                                .black),
                                                  ),
                                                ),
                                              ),
                                              Gaps.h4,
                                              Text(
                                                _formatMessageTime(
                                                    message.time),
                                                style: AppTextStyles.caption
                                                    .copyWith(
                                                        color: AppColors.g4),
                                              ),
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
