import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/oncampus_filter/model/onca_filter_model.dart';

const programList = [
  "전체",
  "창업 멘토링",
  "창업 동아리",
  "창업 특강",
  "창업 경진대회",
  "창업 캠프",
  "기타",
];

class ProgramChipsSheet extends StatefulWidget {
  const ProgramChipsSheet({super.key});

  @override
  State<ProgramChipsSheet> createState() => _ProgramChipsSheetState();
}

class _ProgramChipsSheetState extends State<ProgramChipsSheet> {
  void _saveSelectedProgram(String program) async {
    OnCaFilterModel().setSelectedProgram(program);
  }

  void _onProgramBottom(BuildContext context) async {
    final filterModel = Provider.of<OnCaFilterModel>(context, listen: false);
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateBottomSheet) {
            return Container(
              height: 400,
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v24,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '프로그램',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                  ),
                  Gaps.v8,
                  Expanded(
                    child: Scrollbar(
                      thickness: 4,
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: programList.length,
                        itemBuilder: (context, index) {
                          String program = programList[index];
                          return BottomSheetList(
                            thisText: program,
                            thisColor: AppColors.white,
                            thisTapAction: () {
                              setStateBottomSheet(() {
                                filterModel.setSelectedProgram(program);
                              });

                              _saveSelectedProgram(program);
                              Navigator.pop(context); // 모달 닫기
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Gaps.v24
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProgram =
        Provider.of<OnCaFilterModel>(context).selectedProgram;

    return GestureDetector(
      onTap: () => _onProgramBottom(context),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: selectedProgram == "전체" ? AppColors.g1 : AppColors.blue,
          borderRadius: BorderRadius.circular(46),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.h12,
            Text(
              selectedProgram == "전체" ? '프로그램' : selectedProgram,
              style: AppTextStyles.btn1.copyWith(
                color: selectedProgram == "전체" ? AppColors.g4 : AppColors.white,
              ),
            ),
            Gaps.h4,
            selectedProgram == "전체" ? AppIcon.down_g3 : AppIcon.down_g1,
            Gaps.h8,
          ],
        ),
      ),
    );
  }
}
