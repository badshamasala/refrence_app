import 'package:aayu/controller/program/programme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../services/third-party/events.service.dart';
import '../../../theme/app_colors.dart';
import '../../shared/ui_helper/images.dart';
import '../../shared/ui_helper/ui_helper.dart';
import '../initialAssessment/initial_health_card.dart';

class CompleteAssessment extends StatelessWidget {
  final ProgrammeController programmeController;
  const CompleteAssessment({Key? key, required this.programmeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (programmeController.initialAssessmentCompleted.value == false)
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 30.h),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 322.w,
                  margin: EdgeInsets.only(top: 28.h),
                  padding: EdgeInsets.only(top: 20.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F3F7).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16.w),
                    boxShadow: const [
                      BoxShadow(
                          color:
                              Color.fromRGBO(91, 112, 129, 0.07999999821186066),
                          offset: Offset(1, -8),
                          blurRadius: 16),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 46.h,
                      ),
                      Text(
                        'ASSESS_YOURSELF'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 16.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                          height: 1.75.h,
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      SizedBox(
                        width: 266.w,
                        child: Text(
                          "YOUR_HEALTH_HONESTLY_MSG".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF8C98A5),
                            fontFamily: 'Circular Std',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.5.h,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 23.h,
                      ),
                      Padding(
                        padding: pageHorizontalPadding(),
                        child: InkWell(
                          onTap: () {
                            EventsService().sendClickNextEvent(
                                "DayZero",
                                "Take a 15-Minute Assessment",
                                "InitialHealthCard");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InitialHealthCard(
                                  action: "Initial Assessment",
                                ),
                              ),
                            ).then((value) {
                              EventsService().sendClickBackEvent(
                                  "Assessment", "Back", "DayZero");
                            });
                          },
                          child: mainButton("TAKE_A_15_MINUTE_ASSESSMENT".tr),
                        ),
                      ),
                      SizedBox(
                        height: 44.h,
                      )
                    ],
                  ),
                ),
                Image(
                  image: const AssetImage(Images.healthCardImage),
                  width: 122.w,
                  height: 80.h,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          )
        : SizedBox(height: 30.h);
  }
}
