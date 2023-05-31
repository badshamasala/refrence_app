import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RecentlyConsultedCard extends StatelessWidget {
  final String consultType;
  final String profilePic;
  final String consultName;
  final int slotsAvailable;
  final int epochTime;
  final Function checkSlotFuntion;
  const RecentlyConsultedCard({
    Key? key,
    required this.consultType,
    required this.profilePic,
    required this.consultName,
    required this.slotsAvailable,
    required this.checkSlotFuntion,
    required this.epochTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        checkSlotFuntion();
      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        width: 230.w,
        decoration: BoxDecoration(
          color: Color(0xFFF8F5F5),
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  circularConsultImage(consultType, profilePic, 64, 64),
                  SizedBox(
                    width: 14.w,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          consultName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontFamily: 'Circular Std',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5.h,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        DateFormat('dd MMM, yyyy hh:mm aa').format(
                            DateTime.fromMillisecondsSinceEpoch(epochTime)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.primaryLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 12.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                          height: 1.h,
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        "${slotsAvailable > 0 ? slotsAvailable : 'No'} ${slotsAvailable == 1 ? 'slot' : 'slots'} available",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.primaryLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 11.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                          height: 1.h,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
