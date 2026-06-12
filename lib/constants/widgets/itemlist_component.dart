// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

String formatedStartDate(String startDate) {
  // 정규 표현식을 사용하여 날짜 형식 (예: 2024-01-01 00:00:00)인지 확인합니다.
  RegExp startDatePattern = RegExp(r'^\d{4}-\d{2}-\d{2}');

  // 문자열이 정규 표현식 패턴에 매치되는 경우
  if (startDatePattern.hasMatch(startDate)) {
    // '2024-01-02 00:00:00.000000'와 같은 문자열을 '2024-01-02' 형식으로 변환
    return startDate.substring(0, 10);
  } else {
    // 패턴에 매치되지 않는 경우, "날짜 정보 없음" 반환
    return startDate;
  }
}

String formatedEndDate(String endDate) {
  // 정규 표현식을 사용하여 날짜 형식 (예: 2024-01-01 00:00:00)인지 확인합니다.
  RegExp endDatePattern = RegExp(r'^\d{4}-\d{2}-\d{2}');

  // 문자열이 정규 표현식 패턴에 매치되는 경우
  if (endDatePattern.hasMatch(endDate)) {
    // '2024-01-02 00:00:00.000000'와 같은 문자열을 '2024-01-02' 형식으로 변환
    return endDate.substring(0, 10);
  } else {
    // 패턴에 매치되지 않는 경우, "날짜 정보 없음" 반환
    return endDate;
  }
}

class ItemList extends StatelessWidget {
  final String thisID,
      thisOrganize,
      thisTitle,
      thisStartDate,
      thisEndDate,
      thisClassification;
  final bool isSaved, isContactExist, isFileUploaded;

  const ItemList({
    super.key,
    required this.thisID,
    required this.thisOrganize,
    required this.thisTitle,
    required this.thisStartDate,
    required this.thisEndDate,
    required this.thisClassification,
    required this.isSaved,
    required this.isContactExist,
    required this.isFileUploaded,
  });

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = formatedStartDate(thisStartDate);
    String formattedEndDate = formatedEndDate(thisEndDate);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          trackedRoute(
            builder: (context) => OffCampusDetail(thisID: thisID),
            fullscreenDialog: false,
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v16,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OrganizeChipForOfca(text: thisOrganize),
                if (isContactExist)
                  const Row(
                    children: [
                      Gaps.h4,
                      ConatactChip(),
                    ],
                  ),
                if (isFileUploaded)
                  const Row(
                    children: [
                      Gaps.h4,
                      AIChip(),
                    ],
                  ),
                const Spacer(),
                BookMarkButton(
                  isSaved: isSaved,
                  thisID: thisID,
                )
              ],
            ),
            Gaps.v12,
            Text(
              thisTitle,
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
            ),
            Gaps.v10,
            Text(
              '등록일 $formattedStartDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
            Gaps.v4,
            Text(
              '마감일 $formattedEndDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListForRecommend extends StatelessWidget {
  final String thisID,
      thisOrganize,
      thisTitle,
      thisStartDate,
      thisEndDate,
      thisClassification;
  final bool isSaved, isContactExist, isFileUploaded;

  const ItemListForRecommend({
    super.key,
    required this.thisID,
    required this.thisOrganize,
    required this.thisTitle,
    required this.thisStartDate,
    required this.thisEndDate,
    required this.thisClassification,
    required this.isSaved,
    required this.isContactExist,
    required this.isFileUploaded,
  });

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = formatedStartDate(thisStartDate);
    String formattedEndDate = formatedEndDate(thisEndDate);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          trackedRoute(
            builder: (context) => OffCampusDetail(thisID: thisID),
            fullscreenDialog: false,
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v16,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OrganizeChipForOfca(text: thisOrganize),
                if (isContactExist)
                  const Row(
                    children: [
                      Gaps.h4,
                      ConatactChip(),
                    ],
                  ),
                if (isFileUploaded)
                  const Row(
                    children: [
                      Gaps.h4,
                      AIChip(),
                    ],
                  ),
              ],
            ),
            Gaps.v12,
            Text(
              thisTitle,
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
            ),
            Gaps.v10,
            Text(
              '등록일 $formattedStartDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
            Gaps.v4,
            Text(
              '마감일 $formattedEndDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListForModel extends StatelessWidget {
  final String modelName;
  final int size;
  final bool isInstalled;
  final bool isDownloading;
  final bool isDeleting;
  final int progress;
  final int downloadedChunks;
  final int totalChunks;
  final String configStatus;
  final VoidCallback onDownloadTap;
  final VoidCallback onDeleteTap;

  const ItemListForModel({
    super.key,
    required this.modelName,
    required this.size,
    required this.isInstalled,
    required this.isDownloading,
    required this.isDeleting,
    required this.progress,
    required this.downloadedChunks,
    required this.totalChunks,
    required this.configStatus,
    required this.onDownloadTap,
    required this.onDeleteTap,
  });

  String _formatSize(int size) {
    if (size <= 0) {
      return '용량 정보 없음';
    }

    const gb = 1024 * 1024 * 1024;
    const mb = 1024 * 1024;
    if (size >= gb) {
      return '${(size / gb).toStringAsFixed(2)}GB';
    }
    return '${(size / mb).toStringAsFixed(0)}MB';
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = isDownloading || isDeleting;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      modelName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                    ),
                    Gaps.v6,
                    Text(
                      '${_formatSize(size)} · ${isInstalled ? '다운로드됨' : '미다운로드'} · $configStatus',
                      style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                    ),
                    if (isDownloading) ...[
                      Gaps.v8,
                      LinearProgressIndicator(
                        minHeight: 4,
                        value: progress <= 0 ? null : progress / 100,
                        color: AppColors.blue,
                        backgroundColor: AppColors.g2,
                      ),
                      Gaps.v6,
                      Text(
                        '$progress% · $downloadedChunks/$totalChunks',
                        style:
                            AppTextStyles.caption.copyWith(color: AppColors.g4),
                      ),
                    ],
                  ],
                ),
              ),
              Gaps.h16,
              _ModelActionButton(
                label: isInstalled ? '삭제' : '다운로드',
                isBusy: isBusy,
                onTap: isInstalled ? onDeleteTap : onDownloadTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModelActionButton extends StatelessWidget {
  final String label;
  final bool isBusy;
  final VoidCallback onTap;

  const _ModelActionButton({
    required this.label,
    required this.isBusy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isBusy ? null : onTap,
      child: Container(
        width: 76,
        height: 36,
        decoration: BoxDecoration(
          color: isBusy ? AppColors.g2 : AppColors.blue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: isBusy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.g4,
                  ),
                )
              : Text(
                  label,
                  style: AppTextStyles.btn2.copyWith(color: AppColors.white),
                ),
        ),
      ),
    );
  }
}
