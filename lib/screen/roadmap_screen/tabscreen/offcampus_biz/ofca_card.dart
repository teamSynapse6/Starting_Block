import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OfCaCardOne extends StatelessWidget {
  final String thisOrganize, thisID, thisTitle;
  final int index;

  const OfCaCardOne({
    super.key,
    required this.thisOrganize,
    required this.thisID,
    required this.thisTitle,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OffCampusDetail(thisID: thisID),
            fullscreenDialog: false,
          ),
        );
      },
      child: Container(
        width: 152,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: index == 0
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff5E8BFF), Color(0xff8FAEFF)],
                )
              : index == 1
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffCB98FF), Color(0xffD8B2FF)],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffB1C5F6), Color(0xffC8D6F9)],
                    ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppColors.white.withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  thisOrganize,
                  style: AppTextStyles.caption.copyWith(color: AppColors.white),
                ),
              ),
            ),
            Gaps.v10,
            Text(
              thisTitle,
              style: AppTextStyles.bd1.copyWith(color: AppColors.white),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
