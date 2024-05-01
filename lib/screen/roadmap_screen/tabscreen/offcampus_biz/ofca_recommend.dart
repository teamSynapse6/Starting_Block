import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OfCaRecommend extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;

  const OfCaRecommend({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
  });

  @override
  State<OfCaRecommend> createState() => _OfCaRecommendState();
}

class _OfCaRecommendState extends State<OfCaRecommend> {
  List<OffCampusModel> offCampusData = [];
  bool isEntrepreneur = false;
  String residence = '';
  String userBirthday = '';
  final bool _isLoading = false;

  // thisSelectedText에 따른 supporttype 매핑 정보 업데이트
  final Map<String, List<String>> textToSupportType = {
    '창업 교육': ['창업교육'],
    '아이디어 창출': ['창업교육'],
    '공간 마련': ['시설/공간/보육'],
    '사업 계획서': ['경영/사업화/창업'],
    'R&D / 시제품 제작': ['경영/사업화/창업'],
    '사업 검증': ['경영/사업화/창업'],
    'IR Deck 작성': ['경영/사업화/창업, 행사 네트워크'],
    '자금 확보': ['융자/금융', '경영/사업화/창업', '행사 네트워크'],
    '사업화': ['판로/해외진출/수출', '경영/사업화/창업', '행사 네트워크'],
  };

  @override
  void initState() {
    super.initState();
    _loadOffCampusData();
  }

  @override
  void didUpdateWidget(OfCaRecommend oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 이전 위젯의 thisSelectedText와 현재 위젯의 thisSelectedText를 비교
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      // thisSelectedText가 변경되었으므로 데이터를 다시 로드
      _loadOffCampusData();
    }
  }

  void _loadOffCampusData() async {
    // isEntrepreneur = await UserInfo.getEntrepreneurCheck();
    // residence = await UserInfo.getResidence();
    // userBirthday = await UserInfo.getUserBirthday();
    // int age = calculateAge(userBirthday); // 만 나이 계산

    // List<String>? supportTypes = textToSupportType[widget.thisSelectedText];
    // offCampusData = await OffCampusApi.getOffCampusRoadmapRec(
    //   posttarget: isEntrepreneur,
    //   region: residence,
    //   age: age,
    //   supporttypes: supportTypes,
    // );
    // setState(() {}); // 상태 업데이트
  }

  int calculateAge(String birthday) {
    if (birthday.length != 8) return 0; // 잘못된 입력 처리

    DateTime birthDate = DateTime(
      int.parse(birthday.substring(0, 4)),
      int.parse(birthday.substring(4, 6)),
      int.parse(birthday.substring(6, 8)),
    );
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Column(
        children: [
          Row(
            children: [
              Gaps.h24,
              Text('추천 사업',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.blue)),
              Text('이 도착했습니다',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.g6)),
            ],
          ),
          Gaps.v12,
          const RoadMapOfcaTapCarousel(),
          Gaps.v54,
        ],
      );
    }

    // offCampusData 리스트에 데이터가 없으면 아무것도 표시하지 않음
    if (offCampusData.isEmpty) {
      return Container();
    }

    // 데이터가 있는 경우, 기존 UI 렌더링
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text('추천 사업',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.blue)),
              Text('이 도착했습니다',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.g6)),
            ],
          ),
        ),
        Gaps.v16,
        Stack(
          children: [
            SizedBox(
              height: 130, // 카드의 높이
              child: PageView.builder(
                controller: PageController(
                  viewportFraction: 312 / (360 - 16), // 카드가 차지하는 화면의 비율 조정
                  initialPage: 0,
                ),
                itemCount: offCampusData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8), // 카드 간 여백 조정
                    child: OfCaCard(
                      thisOrganize: offCampusData[index].organize,
                      thisID: offCampusData[index].id,
                      thisClassification: offCampusData[index].classification,
                      thisTitle: offCampusData[index].title,
                      thisEnddate: offCampusData[index].endDate,
                    ),
                  );
                },
              ),
            ),
            if (!widget.thisCurrentStage)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 140,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            if (!widget.thisCurrentStage)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 140,
                child: Center(
                  child: RoadMapStepNotify(),
                ),
              ),
          ],
        ),
        Gaps.v54,
      ],
    );
  }
}
