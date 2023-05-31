import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MoodReminder extends StatelessWidget {
  const MoodReminder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 48.h),
          width: double.infinity,
          padding: EdgeInsets.all(18.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50.h,
              ),
              Text(
                "MOOD_TRACKER".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Baskerville',
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              InkWell(
                onTap: () {
                  /* if (data.time == null || data.time!.isEmpty) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32))),
                      builder: (context) {
                        if (data.title == "Anxiety Care Program") {
                          return const ChangeAnxietyReminderTime();
                        } else {
                          return ChangeReminderTime(data: data);
                        }
                      },
                    );
                  } */
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: const Color(0xFFEFF1F2), width: 1)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: AppColors.blueGreyAssessmentColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: "TRACK_YOUR_MOOD_CONSISTENTLY".tr,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 11.w,
                      ),
                      CupertinoSwitch(
                          activeColor: const Color(0xFFFDDD7E),
                          value: false,
                          onChanged: (val) {
                            /* if (data.time == null || data.time!.isEmpty) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        topRight: Radius.circular(32))),
                                builder: (context) {
                                  if (data.title == "Anxiety Care Program") {
                                    return const ChangeAnxietyReminderTime();
                                  } else {
                                    return ChangeReminderTime(data: data);
                                  }
                                },
                              );
                            }
                            controller.changeSwitch(data); */
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 22.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.moodClockImage,
                height: 58.h,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: 11.h,
              ),
              Image.asset(
                Images.ellipseImage,
                height: 7.h,
                fit: BoxFit.fitHeight,
              ),
            ],
          ),
        )
      ],
    );
  }
}
