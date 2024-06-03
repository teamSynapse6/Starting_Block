// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';

class Recommendation extends StatelessWidget {
  final Future<List<OffCampusListModel>> futureRecommendations;
  final String thisID;

  const Recommendation({
    Key? key,
    required this.futureRecommendations,
    required this.thisID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v36,
          Text(
            '이런 공고는 어떠세요?',
            style: AppTextStyles.st2.copyWith(color: AppColors.g6),
          ),
          FutureBuilder<List<OffCampusListModel>>(
            future: futureRecommendations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // thisID를 제외한 데이터만 필터링
                  var filteredData = snapshot.data!
                      .where((item) => item.announcementId != int.parse(thisID))
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var item = filteredData[index];
                      return Column(
                        children: [
                          ItemListForRecommend(
                            thisID: item.announcementId.toString(),
                            thisOrganize: item.departmentName,
                            thisTitle: item.title,
                            thisStartDate: item.startDate,
                            thisEndDate: item.endDate,
                            thisClassification: '교외사업',
                            isSaved: item.isBookmarked,
                            isContactExist: item.isContactExist,
                            isFileUploaded: item.isFileUploaded,
                          ),
                          Gaps.v16,
                          if (index != filteredData.length - 1)
                            const CustomDividerH2G1()
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Text('No data available.');
                }
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
