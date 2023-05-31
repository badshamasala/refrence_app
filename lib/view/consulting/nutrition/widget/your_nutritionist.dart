import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YourNutritionist extends StatelessWidget {
  final String coachId;
  final String coachName;
  final String gender;
  final String profilePic;
  const YourNutritionist({
    Key? key,
    required this.coachId,
    required this.coachName,
    required this.gender,
    required this.profilePic,
  }) : super(key: key);

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
            "Your Nutritionist",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                circularConsultImage("DOCTOR", profilePic, 64, 64),
                SizedBox(
                  width: 14.w,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        coachName,
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
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "View Profile",
                          style: TextStyle(
                            color: const Color.fromRGBO(241, 99, 102, 1),
                            fontFamily: 'Circular Std',
                            fontSize: 12.sp,
                            letterSpacing: 0,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "View Plan",
                          style: TextStyle(
                            color: const Color.fromRGBO(241, 99, 102, 1),
                            fontFamily: 'Circular Std',
                            fontSize: 12.sp,
                            letterSpacing: 0,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    )
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
