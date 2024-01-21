// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:starting_block/constants/constants.dart';
// import 'package:starting_block/screen/manage/screen_manage.dart';

// class RoadMapEdit extends StatefulWidget {
//   const RoadMapEdit({super.key});

//   @override
//   RoadMapEditState createState() => RoadMapEditState();
// }

// class RoadMapEditState extends State<RoadMapEdit> {
//   bool _isOrderChanged = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const BackAppBar(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               children: [
//                 Gaps.v22,
//                 Text(
//                   '로드맵 단계 수정',
//                   style: AppTextStyles.h5.copyWith(color: AppColors.black),
//                 ),
//                 Gaps.v10,
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const RoadMapAdd()),
//                   );
//                 },
//                 child: SizedBox(
//                   height: 32,
//                   width: 49,
//                   child: Text(
//                     '추가',
//                     style: AppTextStyles.btn1.copyWith(color: AppColors.g6),
//                   ),
//                 ),
//               ),
//               Gaps.h4,
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const RoadMapDelete()),
//                   );
//                 },
//                 child: SizedBox(
//                   height: 32,
//                   width: 49,
//                   child: Text(
//                     '삭제',
//                     style: AppTextStyles.btn1.copyWith(color: AppColors.g6),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: Consumer<RoadMapModel>(
//               builder: (context, roadmapModel, child) {
//                 return ReorderableListView(
//                   children: <Widget>[
//                     for (final item in roadmapModel.roadmapList)
//                       SizedBox(
//                         key: Key(item),
//                         height: 48,
//                         child: ListTile(
//                           contentPadding:
//                               const EdgeInsets.symmetric(horizontal: 24),
//                           title: Text(
//                             item,
//                             style:
//                                 AppTextStyles.bd2.copyWith(color: AppColors.g6),
//                           ),
//                           trailing: Image(image: AppImages.sort_actived),
//                         ),
//                       ),
//                   ],
//                   // RoadMapEditState 클래스 내의 onReorder 콜백
//                   onReorder: (int oldIndex, int newIndex) {
//                     setState(() {
//                       _isOrderChanged = true;
//                       // RoadMapModel 인스턴스를 가져옵니다.
//                       final roadmapModel =
//                           Provider.of<RoadMapModel>(context, listen: false);
//                       // reorderRoadmapList 메소드를 사용하여 순서 변경을 처리합니다.
//                       roadmapModel.reorderRoadmapList(oldIndex, newIndex);
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               right: 24,
//               left: 24,
//               bottom: 24,
//             ),
//             child: GestureDetector(
//               onTap: _isOrderChanged
//                   ? () {
//                       // 불필요한 updateRoadmapList 호출 제거
//                       Navigator.pop(context);
//                     }
//                   : null,
//               child: NextContained(
//                 text: "완료",
//                 disabled: !_isOrderChanged,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
