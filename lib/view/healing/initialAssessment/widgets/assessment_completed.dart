import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/healing/initialAssessment/initial_health_card.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AssessmentCompleted extends StatelessWidget {
  final String pageSource;
  const AssessmentCompleted({Key? key, required this.pageSource})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            Images.assessmentBGImage,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage(
              Images.thankYouFlowerImage,
            ),
            width: 74.w,
            height: 121.21.h,
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            "CONGRATULATIONS".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Baskerville',
              fontSize: 24.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.5.h,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          SizedBox(
            width: 293.w,
            child: Text(
              (pageSource.toUpperCase() == "BOOK_DOCTOR_SLOT")
                  ? "BASIC_HEALTH_ASSESMENT_MSG".tr
                  : "COMPLETED_YOUR_ASSESMENT".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 16.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.5.h,
              ),
            ),
          ),
          SizedBox(
            height: 54.h,
          ),
          InkWell(
            onTap: () {
              if (pageSource.toUpperCase() == "BOOK_DOCTOR_SLOT") {
                // Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pop(context);
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
                EventsService().sendClickNextEvent("AssessmentCompleted",
                    "Check Your Aayu Score", "InitialHealthCard");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const InitialHealthCard(action: "Assessment Completed"),
                  ),
                ).then((value) {
                  EventsService()
                      .sendClickBackEvent("InitialHealthCard", "Back", "Home");
                });
              }
            },
            child: SizedBox(
              width: 242.w,
              child: mainButton((pageSource.toUpperCase() == "BOOK_DOCTOR_SLOT")
                  ? "OKAY".tr
                  : "CHECK_YOUR_AAYU_SCORE".tr),
            ),
          ),
        ],
      ),
    );
  }
}
