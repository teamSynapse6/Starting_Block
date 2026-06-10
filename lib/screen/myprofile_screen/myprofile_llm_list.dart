import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/llm_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class MyProfileLlmList extends StatefulWidget {
  const MyProfileLlmList({super.key});

  @override
  State<MyProfileLlmList> createState() => _MyProfileLlmListState();
}

class _MyProfileLlmListState extends State<MyProfileLlmList> {
  Color topColor = const Color(0xff5E8BFF);
  Color bottomColor = const Color(0xff00288F);
  List<LlmConversationSummary> chatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChatData();
  }

  Future<void> loadChatData() async {
    try {
      final tempList = await LlmApi.getLlmList();
      if (!mounted) {
        return;
      }
      setState(() {
        chatList = tempList;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        chatList = [];
        isLoading = false;
      });
    }
  }

  void thisLlmListTap(LlmConversationSummary chat) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LlmChatScreen(
            thisTitle: chat.title,
            thisID: chat.announcementId.toString(),
            threadId: chat.threadId,
          ),
        ));
    if (result == true) {
      loadChatData();
    }
  }

  Future<void> deleteLlmChat(LlmConversationSummary chat) async {
    try {
      final success = await LlmApi.deleteLlmEnd(chat.threadId);
      if (!mounted) {
        return;
      }
      if (success) {
        setState(() {
          chatList.removeWhere((item) => item.threadId == chat.threadId);
        });
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('대화 삭제에 실패했습니다.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('대화 삭제 중 오류가 발생했습니다.')),
      );
    }
  }

  void thisEmptyListTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const IntergrateScreen(
                switchIndex: SwitchIndex.toZero,
              )),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            topColor,
            bottomColor,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const BackTitleAppBarForLlmList(
          title: 'AI로 공고 분석하기',
        ),
        body: Column(
          children: [
            Gaps.v16,
            Row(
              children: [
                Gaps.h24,
                AppIcon.llm_robot_icon,
                Gaps.h14,
                Column(
                  children: [Gaps.v25, AppIcon.llm_listpage_tail],
                ),
                Container(
                  width: 220,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  color: AppColors.bluebg.withValues(alpha: 204),
                  child: const Text(
                    '공고의 첨부파일을 학습하여\n창업자님의 질문에 답변을 드려요!',
                    style: TextStyle(
                        color: AppColors.g6,
                        fontFamily: 'pretendard',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12),
                  ),
                )
              ],
            ),
            Gaps.v24,
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: RefreshIndicator(
                  color: AppColors.blue,
                  onRefresh: loadChatData,
                  child: isLoading
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
                              child: Center(
                                child: SizedBox(
                                  height: 38,
                                  child:
                                      AppAnimation.chatting_progress_indicator,
                                ),
                              ),
                            ),
                          ],
                        )
                      : chatList.isNotEmpty
                          ? ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: chatList.length,
                              itemBuilder: (context, index) {
                                final chat = chatList[index];
                                return Column(
                                  children: [
                                    Slidable(
                                      key: ValueKey(chat.threadId),
                                      endActionPane: ActionPane(
                                        motion: const DrawerMotion(),
                                        extentRatio: 0.22,
                                        children: [
                                          SlidableAction(
                                            onPressed: (_) =>
                                                deleteLlmChat(chat),
                                            backgroundColor:
                                                AppColors.activered,
                                            foregroundColor: AppColors.white,
                                            icon: Icons.delete_outline,
                                            label: '삭제',
                                          ),
                                        ],
                                      ),
                                      child: MyProfileLlmListWidget(
                                        thisTitle: chat.title,
                                        thisLastContent: chat.lastMessage,
                                        thisLastDate: chat.lastDate.toString(),
                                        thisTap: () => thisLlmListTap(chat),
                                        actionTap: () {},
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 24),
                                      child: CustomDividerH1G1(),
                                    ),
                                  ],
                                );
                              },
                            )
                          : ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                Gaps.v124,
                                Text(
                                  '공고 분석을 시작해 보세요',
                                  style: AppTextStyles.bd1
                                      .copyWith(color: AppColors.g5),
                                  textAlign: TextAlign.center,
                                ),
                                Gaps.v6,
                                Text(
                                  '원하는 공고의 상세 페이지에서\n공고 분석하기를 시작해 보세요',
                                  style: AppTextStyles.bd6
                                      .copyWith(color: AppColors.g5),
                                  textAlign: TextAlign.center,
                                ),
                                Gaps.v36,
                                Center(
                                  child: Material(
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(2),
                                      highlightColor: AppColors.g2,
                                      onTap: () {
                                        thisEmptyListTap();
                                      },
                                      child: Ink(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(
                                            color: AppColors.g3,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          '교외지원사업 확인하러 가기',
                                          style: AppTextStyles.bd6
                                              .copyWith(color: AppColors.g4),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
