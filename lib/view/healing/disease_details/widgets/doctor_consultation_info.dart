import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/doctor_list.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DoctorConsultationInfo extends StatelessWidget {
  final bool fromThankYou;

  const DoctorConsultationInfo({Key? key, required this.fromThankYou})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 60.h),
          decoration: BoxDecoration(
            color: AppColors.pageBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.w),
              topRight: Radius.circular(30.w),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 81.h,
                ),
                Text(
                  "FREE_DOCTOR_CONSULT".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Baskerville',
                    fontSize: 24.sp,
                    letterSpacing: 1.5.w,
                    fontWeight: FontWeight.normal,
                    height: 1.16.h,
                  ),
                ),
                SizedBox(
                  height: 13.2.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  margin: pageHorizontalPadding(),
                  padding: EdgeInsets.all(13.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildHealingTabRow(
                        "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/correct.png",
                        "Choose from our panel of clinical experts in Intergrated Yoga Therapy",
                      ),
                      buildHealingTabRow(
                        "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/correct.png",
                        "Get assessed by a specialist, all it takes is 15 minutes ",
                      ),
                      buildHealingTabRow(
                        "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/correct.png",
                        "Just keep your latest reports handy for the consult",
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 13.2.h,
                ),
                SizedBox(
                  width: 295.w,
                  child: Text(
                    "NOTE_MSG".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor.withOpacity(0.8),
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp,
                      fontFamily: "Circular Std",
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (fromThankYou) {
                      Navigator.pop(context);
                    }
                    Navigator.pop(context);
                    EventsService().sendClickNextEvent("DoctorConsultationInfo",
                        "Select Your Doctor", "BookDoctorSession");

                    Get.to(
                      DoctorList(
                        pageSource: "PROGRAM_DETAILS",
                        consultType: "PERSONALIZED CARE",
                        bookType: "FREE",
                      ),
                    )!
                        .then((value) {
                      EventsService().sendClickBackEvent("BookDoctorSession",
                          "Back", "DoctorConsultationInfo");
                    });
                  },
                  child: Padding(
                    padding: pagePadding(),
                    child: mainButton("SELECT_YOUR_DOCTOR".tr),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 0.h,
          left: 0.w,
          right: 0,
          child: Image(
            width: 90.41.w,
            height: 126.h,
            image: const AssetImage(Images.doctorConsultant2Image),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
