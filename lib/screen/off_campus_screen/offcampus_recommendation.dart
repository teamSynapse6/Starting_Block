import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/models/offcampus_recommend_model.dart';

class Recommendation extends StatelessWidget {
  final Future<List<OffCampusRecommendModel>> futureRecommendations;
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
          FutureBuilder<List<OffCampusRecommendModel>>(
            future: futureRecommendations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // thisID를 제외한 데이터만 필터링
                  var filteredData = snapshot.data!
                      .where((item) => item.id != thisID)
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var item = filteredData[index];
                      return ItemList(
                        thisID: item.id,
                        thisOrganize: item.organize,
                        thisTitle: item.title,
                        thisStartDate: item.startDate,
                        thisEndDate: item.endDate,
                        thisClassification: item.classification,
                        bookMarkTap: null,
                        isSaved: false,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Text('No data available.');
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
