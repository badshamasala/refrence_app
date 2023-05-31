import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedHealthCoach extends StatelessWidget {
  final CoachListModelCoachList coachDetails;
  final String displayText;
  const SelectedHealthCoach(
      {Key? key, required this.coachDetails, required this.displayText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF3F3),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your $displayText",
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 14.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.h),
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
                color: AppColors.whiteColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circularConsultImage("DOCTOR", coachDetails.profilePic, 64, 64),
                SizedBox(
                  width: 14.w,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        coachDetails.coachName!,
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        "Speciality : ${coachDetails.speciality!.join(", ")}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor.withOpacity(0.7),
                          fontFamily: 'Circular Std',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5.h,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        "Speaks : ${coachDetails.speaks!.join(", ")}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor.withOpacity(0.7),
                          fontFamily: 'Circular Std',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5.h,
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
