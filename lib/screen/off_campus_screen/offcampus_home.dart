import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/offcampus_filter/model/filter_model.dart';
import 'package:starting_block/screen/manage/api/offcampus_api_manage.dart';
import 'package:starting_block/screen/manage/models/offcampus_model.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class OffCampusHome extends StatefulWidget {
  const OffCampusHome({super.key});

  @override
  State<OffCampusHome> createState() => _OffCampusHomeState();
}

class _OffCampusHomeState extends State<OffCampusHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(
        searchTapScreen: OffCampusSearch(),
      ),
      body: Consumer<FilterModel>(
        // Consumer를 사용하여 FilterModel의 변화를 감지
        builder: (context, filterModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v12,
                    Text('교외 지원 사업',
                        style: AppTextStyles.st1.copyWith(color: AppColors.g6)),
                    Gaps.v24,
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: IntergrateFilter(),
                    ),
                    Gaps.v12,
                    Container(
                      height: 32,
                      decoration: const BoxDecoration(
                        border: BorderDirectional(
                          top: BorderSide(width: 2, color: AppColors.g1),
                          bottom: BorderSide(width: 2, color: AppColors.g1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '24개의 공고',
                            style:
                                AppTextStyles.bd6.copyWith(color: AppColors.g4),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: null,
                            child: Row(
                              children: [
                                const Text(
                                  '최신순',
                                  style: TextStyle(
                                      fontFamily: 'pretendard',
                                      fontSize: 14,
                                      color: AppColors.g4),
                                ),
                                AppIcon.down,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<OffCampusModel>>(
                  future: OffCampusApiService.getOffCampusDataFiltered(
                    supporttype: filterModel.selectedSupportType,
                    region: filterModel.selectedResidence,
                    posttarget: filterModel.selectedEntrepreneur,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      List<OffCampusModel> data = snapshot.data ?? [];
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          OffCampusModel offCampusData = data[index];
                          return ItemList(
                            thisID: offCampusData.id,
                            thisOrganize: offCampusData.organize,
                            thisTitle: offCampusData.title,
                            thisStartDate: offCampusData.startDate,
                            thisEndDate: offCampusData.endDate,
                            thisClassification: '교외사업',
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
