part of '../../screen/llm_chat/llm_chat_screen.dart';

extension _LlmChatWidgets on _LlmChatScreenState {
  Widget _buildSendMessageButton() {
    final canStopGeneration =
        _isSending || _isStreaming || _hasRunningGeneration;

    if (canStopGeneration) {
      return GestureDetector(
        onTap: _stopCurrentGeneration,
        child: SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _isTyped && _chatAvailable ? _sendMessage : null,
      child: SizedBox(
        width: 24,
        height: 24,
        child: _isTyped ? AppIcon.send_actived : AppIcon.send_inactived,
      ),
    );
  }

  Widget _buildModelSelector() {
    String displayName(String value) {
      if (value == _serverModelValue) return '서버 AI';
      if (value == _appleIntelligenceModelValue) {
        return AppleIntelligenceLlmManage.displayName;
      }
      return OnDeviceLlmManage.serverModelName(value);
    }

    final allValues = [
      _serverModelValue,
      if (_canShowAppleIntelligence) _appleIntelligenceModelValue,
      ..._installedModelNames,
    ];
    final isEnabled = _chatAvailable;

    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: isEnabled
              ? () async {
                  final renderBox = context.findRenderObject() as RenderBox;
                  final offset = renderBox.localToGlobal(Offset.zero);
                  final size = renderBox.size;

                  final result = await showMenu<String>(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      offset.dx,
                      offset.dy + size.height + 4,
                      offset.dx + size.width,
                      0,
                    ),
                    items: allValues
                        .map(
                          (value) => PopupMenuItem<String>(
                            value: value,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                displayName(value),
                                style: AppTextStyles.btn1.copyWith(
                                  color: value == _selectedModelValue
                                      ? AppColors.blue
                                      : AppColors.g4,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    color: AppColors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );

                  if (result != null) {
                    _handleModelSelectionChanged(result);
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName(_selectedModelValue),
                  style: AppTextStyles.btn2.copyWith(color: AppColors.blue),
                ),
                Gaps.h4,
                AppIcon.arrow_down_16,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveStatus() {
    if (_statusText.isEmpty || !_isStreaming) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glow = 0.35 + (_glowController.value * 0.65);
        return Opacity(
          opacity: glow,
          child: Text(
            _statusText,
            style: AppTextStyles.bd6.copyWith(
              color: AppColors.g4,
              shadows: [
                Shadow(
                  color: AppColors.blue.withValues(alpha: glow * 0.45),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThinkingText() {
    if (_thinkingText.trim().isEmpty || !_isStreaming) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        _thinkingText,
        style: AppTextStyles.caption.copyWith(color: AppColors.g4),
      ),
    );
  }

  Widget _buildAssistantAvatar({required bool isThinking}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: isThinking ? 1 : 0),
      duration: Duration(milliseconds: isThinking ? 250 : 450),
      curve: Curves.easeInOutQuint,
      builder: (context, thinkingProgress, child) {
        final characterLeft = 8 * thinkingProgress;
        final characterTop = 8 * thinkingProgress;
        final characterSize = 36 - (9 * thinkingProgress);
        final characterScale = characterSize / 36;

        return AnimatedBuilder(
          animation: _thinkingAvatarController,
          builder: (context, child) {
            final eyeOffset =
                _thinkingEyeOffset(_thinkingAvatarController.value) *
                    characterScale *
                    thinkingProgress;
            final thinkingLeftEyeX = characterLeft + (18 * characterScale);
            final thinkingRightEyeX = characterLeft + (21.6 * characterScale);
            final thinkingEyeY = characterTop + (21 * characterScale);
            final thinkingEyeSize = 2.6 * characterScale;
            final leftEyeX = 18 + ((thinkingLeftEyeX - 18) * thinkingProgress);
            final rightEyeX =
                22.8 + ((thinkingRightEyeX - 22.8) * thinkingProgress);
            final eyeY = 22 + ((thinkingEyeY - 22) * thinkingProgress);
            final eyeSize = 2.6 + ((thinkingEyeSize - 2.6) * thinkingProgress);

            return CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.blue,
              child: ClipOval(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Stack(
                    children: [
                      if (thinkingProgress > 0)
                        Positioned.fill(
                          left: -15,
                          child: Opacity(
                            opacity: thinkingProgress,
                            child: AppAnimation.llm_thinking_background,
                          ),
                        ),
                      Opacity(
                        opacity: 1 - thinkingProgress,
                        child: AppIcon.chatting_icon,
                      ),
                      if (thinkingProgress > 0)
                        Positioned(
                          left: characterLeft,
                          top: characterTop,
                          child: Opacity(
                            opacity: thinkingProgress,
                            child: SizedBox(
                              width: characterSize,
                              height: characterSize,
                              child: AppIcon.chatting_character_thinking,
                            ),
                          ),
                        ),
                      if (thinkingProgress > 0)
                        Positioned(
                          left: leftEyeX + eyeOffset.dx,
                          top: eyeY + eyeOffset.dy,
                          child: _buildThinkingEye(size: eyeSize),
                        ),
                      if (thinkingProgress > 0)
                        Positioned(
                          left: rightEyeX + eyeOffset.dx,
                          top: eyeY + eyeOffset.dy,
                          child: _buildThinkingEye(size: eyeSize),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThinkingEye({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF213049),
        borderRadius: BorderRadius.circular(0.3),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Gaps.v8,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(child: Container(height: 1, color: AppColors.g3)),
              Gaps.h18,
              Text(
                DateFormat('yyyy년 MM월 dd일').format(DateTime.now()),
                style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
              ),
              Gaps.h18,
              Expanded(child: Container(height: 1, color: AppColors.g3)),
            ],
          ),
        ),
        Gaps.v24,
        Center(
          child: Text(
            '오늘은 어떤 도움이 필요하세요?\nAI와 공고의 첨부파일 관련 대화를 시작해 보세요.',
            style: AppTextStyles.btn2.copyWith(color: AppColors.g4),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Offset _thinkingEyeOffset(double value) {
    const points = [
      Offset(-0.9, -1.0),
      Offset(0.9, -1.0),
      Offset(-0.9, 1.0),
      Offset(0.9, 1.0),
      Offset(-0.9, -1.0),
    ];
    const holdPortion = 1.5 / 1.75;
    final scaledValue = value * (points.length - 1);
    final index = scaledValue.floor().clamp(0, points.length - 2);
    final segmentProgress = scaledValue - index;

    if (segmentProgress <= holdPortion) {
      return points[index];
    }

    final moveProgress =
        ((segmentProgress - holdPortion) / (1 - holdPortion)).clamp(0.0, 1.0);
    final easedProgress = Curves.easeInOutQuint.transform(moveProgress);
    return Offset.lerp(points[index], points[index + 1], easedProgress)!;
  }

  Widget _buildMessageList() {
    if (_isInitializing) {
      return Expanded(
        child: Center(
          child: SizedBox(
            height: 38,
            child: AppAnimation.chatting_progress_indicator,
          ),
        ),
      );
    }

    if (_messages.isEmpty) {
      return _buildEmptyState();
    }

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isFirstItem = index == 0;
          final isLastItem = index == _messages.length - 1;
          final messageDate =
              LlmChatTimeFormatter.parseMessageDateTime(message.time);
          final isFirstMessageOfDay = index == 0 ||
              LlmChatTimeFormatter.parseMessageDateTime(
                    _messages[index - 1].time,
                  ).day !=
                  messageDate.day;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isFirstMessageOfDay)
                _buildDateDivider(messageDate, isFirstItem),
              Padding(
                padding: EdgeInsets.only(
                  top: isFirstMessageOfDay ? 16 : 0,
                  bottom: isLastItem ? 10 : 0,
                ),
                child: Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: message.isUser
                      ? _buildUserMessage(message)
                      : _buildAssistantMessage(message, isLastItem),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateDivider(DateTime date, bool isFirstItem) {
    return Padding(
      padding: EdgeInsets.only(top: isFirstItem ? 8 : 0),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: AppColors.g3)),
          Gaps.h18,
          Text(
            DateFormat('yyyy년 MM월 dd일').format(date),
            style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
          ),
          Gaps.h18,
          Expanded(child: Container(height: 1, color: AppColors.g3)),
        ],
      ),
    );
  }

  Widget _buildUserMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Gaps.h12,
          Text(
            LlmChatTimeFormatter.formatMessageTime(message.time),
            style: AppTextStyles.caption.copyWith(color: AppColors.g4),
          ),
          Gaps.h4,
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                child: SelectableText(
                  message.message,
                  style: AppTextStyles.bd4.copyWith(color: AppColors.g1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantMessage(Message message, bool isLastItem) {
    final showLiveInfo = isLastItem && _isStreaming;
    final isWaitingForFirstToken =
        showLiveInfo && _statusText.isNotEmpty && message.message.isEmpty;
    final showStatusBesideAvatar = showLiveInfo && _statusText.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildAssistantAvatar(
                isThinking: _LlmChatScreenState._debugForceThinkingAvatar ||
                    isWaitingForFirstToken,
              ),
              if (showStatusBesideAvatar) ...[
                Gaps.h8,
                Flexible(child: _buildLiveStatus()),
              ],
            ],
          ),
          Gaps.v8,
          if (showLiveInfo) _buildThinkingText(),
          if (showStatusBesideAvatar) Gaps.v8,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.message.isNotEmpty)
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      child: SelectableText.rich(
                        LlmTextParser.parse(
                          message.message,
                          color: AppColors.black,
                          baseStyle: AppTextStyles.bd4,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 38,
                  child: AppAnimation.chatting_progress_indicator,
                ),
              Gaps.h4,
              Text(
                LlmChatTimeFormatter.formatMessageTime(message.time),
                style: AppTextStyles.caption.copyWith(color: AppColors.g4),
              ),
              Gaps.h12,
            ],
          ),
        ],
      ),
    );
  }
}
