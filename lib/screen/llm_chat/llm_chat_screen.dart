// ignore_for_file: annotate_overrides

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/llm_api_manage.dart';
import 'package:starting_block/manage/llm/apple_intelligence_llm_manage.dart';
import 'package:starting_block/manage/llm/llm_background_stream_watcher.dart';
import 'package:starting_block/manage/llm/llm_chat_message_manager.dart';
import 'package:starting_block/manage/llm/llm_chat_scroll_manager.dart';
import 'package:starting_block/manage/llm/llm_chat_stage_text.dart';
import 'package:starting_block/manage/llm/llm_chat_time_formatter.dart';
import 'package:starting_block/manage/llm/on_device_llm_generation_tracker.dart';
import 'package:starting_block/manage/llm/on_device_llm_manage.dart';
import 'package:starting_block/manage/llm/llm_text_parser.dart';
import 'package:starting_block/manage/model_manage.dart';

part '../../manage/llm/llm_chat_method.dart';
part '../../manage/llm/llm_chat_widgets.dart';

class LlmChatScreen extends StatefulWidget {
  final String thisTitle;
  final String thisID;
  final String threadId;

  const LlmChatScreen({
    super.key,
    required this.thisTitle,
    required this.thisID,
    this.threadId = '',
  });

  @override
  State<LlmChatScreen> createState() => _LlmChatScreenState();
}

class _LlmChatScreenState extends State<LlmChatScreen>
    with TickerProviderStateMixin, LlmChatMethods {
  static const bool _debugForceThinkingAvatar = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final LlmChatScrollManager _scrollManager = LlmChatScrollManager();
  final ValueNotifier<String> _queueTextNotifier =
      ValueNotifier<String>('AI 답변 순서를 기다리고 있어요.');

  late final AnimationController _glowController;
  late final AnimationController _thinkingAvatarController;
  StreamSubscription<LlmStreamEvent>? _streamSubscription;
  StreamSubscription<LlmStreamEvent>? _retrievalSubscription;
  StreamSubscription<String>? _replyGenerationSubscription;
  StreamSubscription<OnDeviceLlmGenerationSnapshot>?
      _onDeviceGenerationSubscription;

  bool _isTyped = false;
  bool _isInitializing = true;
  bool _isSending = false;
  bool _isStreaming = false;
  bool _isOnDeviceGeneration = false;
  bool _hasRunningGeneration = false;
  bool _isQueueModalVisible = false;
  bool _didPrepareToLeave = false;
  int _reconnectAttempts = 0;

  String? _threadId;
  String _statusText = '';
  String _thinkingText = '';
  LlmResponseEngine _selectedEngine = LlmResponseEngine.server;
  String? _selectedModelName;
  List<String> _installedModelNames = [];
  bool _canShowAppleIntelligence = false;
  List<Message> _messages = [];

  int get _announcementId => int.tryParse(widget.thisID) ?? 0;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _thinkingAvatarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _controller.addListener(_handleTextInputChange);
    initializeWidget();
  }

  @override
  void dispose() {
    _prepareToLeave();
    _streamSubscription?.cancel();
    _retrievalSubscription?.cancel();
    _replyGenerationSubscription?.cancel();
    _onDeviceGenerationSubscription?.cancel();

    _controller.removeListener(_handleTextInputChange);
    _queueTextNotifier.dispose();
    _controller.dispose();
    _scrollController.dispose();
    _thinkingAvatarController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope<Object?>(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            _prepareToLeave();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.g1,
          appBar: AppBar(
            centerTitle: false,
            leading: GestureDetector(
              onTap: () {
                _prepareToLeave();
                Navigator.pop(context, true);
              },
              child: AppIcon.back,
            ),
            titleSpacing: 4,
            title: Text(
              'AI로 공고 분석하기',
              style: AppTextStyles.st2.copyWith(color: AppColors.g6),
            ),
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: AppColors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text(
                      widget.thisTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bd3.copyWith(color: AppColors.g5),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  _buildMessageList(),
                ],
              ),
              const Positioned(
                bottom: 0,
                child: BottomGradient(),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: AppColors.white,
            padding: MediaQuery.of(context).viewInsets,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: AppColors.g2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              enabled: _chatAvailable,
                              controller: _controller,
                              cursorColor: AppColors.g6,
                              minLines: 1,
                              maxLines: 3,
                              style: AppTextStyles.bd2
                                  .copyWith(color: AppColors.g6),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                disabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: _chatAvailable
                                    ? '공고에서 궁금한 점을 입력하세요'
                                    : '잠시만 기다려 주세요',
                                hintStyle: AppTextStyles.bd4
                                    .copyWith(color: AppColors.g4),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildModelSelector(),
                                Gaps.h2,
                                _buildSendMessageButton(),
                              ],
                            ),
                            Gaps.v6,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
