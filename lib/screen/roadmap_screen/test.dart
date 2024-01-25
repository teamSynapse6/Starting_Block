// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:starting_block/constants/constants.dart';
// import 'package:starting_block/screen/manage/screen_manage.dart';

// class RoadMapEdit extends StatefulWidget {
//   const RoadMapEdit({
//     super.key,
//   });

//   @override
//   RoadMapEditState createState() => RoadMapEditState();
// }

// class RoadMapEditState extends State<RoadMapEdit> {
//   bool _isOrderChanged = false;
//   late List<String> _tempRoadmapList; // 임시 로드맵 순서
//   late List<String?> _tempRoadmapListCheck; // 임시 체크 상태
//   bool isDragged = false;
//   int? oldIndex; // oldIndex를 선언합니다.

//   @override
//   void initState() {
//     super.initState();
//     final roadmapModel = Provider.of<RoadMapModel>(context, listen: false);
//     _tempRoadmapList = List<String>.from(roadmapModel.roadmapList);
//     _tempRoadmapListCheck = List<String?>.from(roadmapModel.roadmapListCheck);
//   }

//   void _updateRoadmapOrder() {
//     // RoadMapModel 인스턴스를 가져옵니다.
//     final roadmapModel = Provider.of<RoadMapModel>(context, listen: false);
//     // 모델을 업데이트합니다.
//     roadmapModel.reorderRoadmapList(_tempRoadmapList, _tempRoadmapListCheck);
//   }

//   void _reloadRoadmapModel() {
//     setState(() {
//       final roadmapModel = Provider.of<RoadMapModel>(context, listen: false);
//       _tempRoadmapList = List<String>.from(roadmapModel.roadmapList);
//       _tempRoadmapListCheck = List<String?>.from(roadmapModel.roadmapListCheck);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const BackAppBar(
//         state: false,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Gaps.v22,
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 24,
//               right: 12,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '로드맵 단계 수정',
//                   style: AppTextStyles.h5.copyWith(color: AppColors.black),
//                 ),
//                 Gaps.v10,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         bool result = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const RoadMapAdd()),
//                         );
//                         if (result) {
//                           _reloadRoadmapModel();
//                         }
//                       },
//                       child: SizedBox(
//                         height: 32,
//                         width: 49,
//                         child: Center(
//                           child: Text(
//                             '추가',
//                             style: AppTextStyles.btn1
//                                 .copyWith(color: AppColors.g6),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Gaps.h4,
//                     GestureDetector(
//                       onTap: () async {
//                         bool result = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const RoadMapDelete()),
//                         );
//                         if (result) {
//                           _reloadRoadmapModel();
//                         }
//                       },
//                       child: SizedBox(
//                         height: 32,
//                         width: 49,
//                         child: Center(
//                           child: Text(
//                             '삭제',
//                             style: AppTextStyles.btn1
//                                 .copyWith(color: AppColors.g6),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Consumer<RoadMapModel>(
//               builder: (context, roadmapModel, child) {
//                 return ReorderableListView(
//                   onReorderStart: (int oldIndex) {
//                     // 드래그가 시작될 때 isDragged와 oldIndex를 설정
//                     setState(() {
//                       isDragged = true;
//                       this.oldIndex = oldIndex;
//                     });
//                   },
//                   onReorderEnd: (int newIndex) {
//                     setState(() {
//                       isDragged = false;
//                       oldIndex = null; // 드래그 종료 시 oldIndex를 초기화
//                     });
//                   },
//                   onReorder: (int oldIndex, int newIndex) {
//                     // oldIndex를 사용하여 드래그 중인 아이템을 확인합니다.
//                     if (this.oldIndex != null && this.oldIndex == oldIndex) {
//                       // 이제 oldIndex를 사용하여 스타일을 적용할 수 있습니다.
//                       setState(() {
//                         _isOrderChanged = true;
//                         if (newIndex > oldIndex) {
//                           newIndex -= 1;
//                         }
//                         final item = _tempRoadmapList.removeAt(oldIndex);
//                         final checkItem =
//                             _tempRoadmapListCheck.removeAt(oldIndex);
//                         _tempRoadmapList.insert(newIndex, item);
//                         _tempRoadmapListCheck.insert(newIndex, checkItem);
//                         isDragged = false;
//                         oldIndex = null; // 드래그 종료 시 oldIndex를 초기화
//                       });
//                     }
//                   },
//                   children: <Widget>[
//                     for (int index = 0;
//                         index < _tempRoadmapList.length;
//                         index++)
//                       IgnorePointer(
//                         ignoring: _tempRoadmapListCheck[index] == '도약완료',
//                         key: ValueKey(_tempRoadmapList[index]),
//                         child: ReorderCustomTile(
//                           thisText: _tempRoadmapList[index],
//                           // 드래그 중일 때와 아닐 때의 스타일을 조건부로 설정
//                           thisTextStyle: isDragged && index == oldIndex
//                               ? AppTextStyles.bd1.copyWith(color: AppColors.g6)
//                               : (_tempRoadmapListCheck[index] == '도약완료'
//                                   ? AppTextStyles.bd2
//                                       .copyWith(color: AppColors.g4)
//                                   : AppTextStyles.bd2
//                                       .copyWith(color: AppColors.g6)),
//                         ),
//                       ),
//                   ],
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
//                       _updateRoadmapOrder();
//                       Navigator.pop(context, true);
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
