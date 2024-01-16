// import 'package:flutter/material.dart';
// import 'package:starting_block/constants/constants.dart';
// import 'package:starting_block/screen/roadmap_screen/tabscree/offcampus_biz/ofca_card.dart';
// import 'package:starting_block/screen/roadmap_screen/widget/roadmap_stepnotify.dart';

// class TabScreenOfCaBiz extends StatefulWidget {
//   final String thisKeyValue;

//   const TabScreenOfCaBiz({
//     super.key,
//     required this.thisKeyValue,
//   });

//   @override
//   State<TabScreenOfCaBiz> createState() => _TabScreenOfCaBizState();
// }

// class _TabScreenOfCaBizState extends State<TabScreenOfCaBiz> {
//   bool isRecommend = false;
//   bool isSaved = false;
//   String classifiCation = '교외사업';

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Gaps.v24,
//         isRecommend
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       children: <TextSpan>[
//                         TextSpan(
//                           text: '추천 사업',
//                           style:
//                               AppTextStyles.st2.copyWith(color: AppColors.blue),
//                         ),
//                         TextSpan(
//                           text: ' 이 도착했습니다',
//                           style:
//                               AppTextStyles.st2.copyWith(color: AppColors.g6),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Gaps.v16,
//                   SizedBox(
//                     height: 198, // RoadMapCard의 높이
//                     child: PageView.builder(
//                       itemCount: 3, // 카드의 개수
//                       controller: PageController(
//                         viewportFraction: 314 /
//                             MediaQuery.of(context)
//                                 .size
//                                 .width, // 페이지 뷰에서 한 번에 보여지는 카드의 비율
//                       ),
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 6), // 좌우 마진 (카드 간 간격)
//                           child:
//                               const OffCampusCard(), // 여기에 RoadMapCard 위젯을 넣습니다.
//                         );
//                       },
//                     ),
//                   ),
//                   Gaps.v36,
//                 ],
//               )
//             : const RoadMapStepNotify(),
//         Text(
//           '저장한 사업으로 도약하기',
//           style: AppTextStyles.st2.copyWith(color: AppColors.g6),
//         ),
//         Gaps.v4,
//         Text(
//           '신청 완료한 사업은 도약 완료 버튼으로 진행도 확인하기',
//           style: AppTextStyles.caption.copyWith(color: AppColors.g5),
//         ),
//         Gaps.v20,
//         isSaved
//             ? const OffCampusCard()
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Gaps.v40,
//                   Text(
//                     '저장한 지원 사업이 없어요',
//                     style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
//                   ),
//                   Gaps.v8,
//                   Container(
//                     width: 130,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       border: Border.all(
//                         width: 1,
//                         color: AppColors.g3,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         '지원사업 저장하러가기',
//                         style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//       ],
//     );
//   }
// }


            // title: Text(item['공고제목'] ?? '제목 없음'),
            //           subtitle: Text(item['기관'] ?? '기관 정보 없음'),