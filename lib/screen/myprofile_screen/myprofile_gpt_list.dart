import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/manage/userdata/gpt_list_manage.dart';

class MyProfileGptList extends StatefulWidget {
  const MyProfileGptList({super.key});

  @override
  State<MyProfileGptList> createState() => _MyProfileGptListState();
}

class _MyProfileGptListState extends State<MyProfileGptList> {
  Color topColor = const Color(0xff5E8BFF);
  Color bottomColor = const Color(0xff00288F);
  List<GptListModel> chatList = [];

  @override
  void initState() {
    super.initState();
    loadChatData();
  }

  void loadChatData() async {
    List<GptListModel> tempList = await GptListManage.loadChatData();
    setState(() {
      chatList = tempList;
    });
  }

  void thisGptListTap(String id, String title) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GptChatScreen(thisTitle: title, thisID: id),
        ));
    if (result == true) {
      loadChatData();
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
        appBar: const BackTitleAppBarForGptList(
          title: 'AI로 공고 분석하기',
        ),
        body: Column(
          children: [
            Gaps.v16,
            Row(
              children: [
                Gaps.h24,
                AppIcon.gpt_robot_icon,
                Gaps.h14,
                Column(
                  children: [Gaps.v25, AppIcon.gpt_listpage_tail],
                ),
                Container(
                  width: 220,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  color: AppColors.bluebg.withOpacity(0.8),
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
                child: chatList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          final chat = chatList[index];
                          return Column(
                            children: [
                              MyProfileGptListWidget(
                                thisTitle: chat.title,
                                thisLastContent: chat.lastMessage,
                                thisLastDate: chat.lastDate.toString(),
                                thisTap: () => thisGptListTap(
                                    chat.id.toString(), chat.title),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: CustomDividerH1G1(),
                              ),
                            ],
                          );
                        },
                      )
                    : Column(
                        children: [
                          Gaps.v124,
                          Text(
                            '공고 분석을 시작해 보세요',
                            style:
                                AppTextStyles.bd1.copyWith(color: AppColors.g5),
                          ),
                          Gaps.v6,
                          Text(
                            '원하는 공고의 상세 페이지에서\n공고 분석하기를 시작해 보세요',
                            style:
                                AppTextStyles.bd6.copyWith(color: AppColors.g5),
                            textAlign: TextAlign.center,
                          ),
                          Gaps.v36,
                          Material(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(2),
                              highlightColor: AppColors.g2,
                              onTap: () {
                                thisEmptyListTap();
                              },
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: AppColors.g3,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '교외 지원 사업 확인하러 가기',
                                  style: AppTextStyles.bd6
                                      .copyWith(color: AppColors.g4),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
