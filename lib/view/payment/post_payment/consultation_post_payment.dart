import 'dart:async';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/coach.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/doctor_list.dart';
import 'package:aayu/view/healing/consultant/trainer_list.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../services/consultant.service.dart';

class ConsultationAddOnPostPayment extends StatefulWidget {
  final String consultationType;
  final int sessions;
  const ConsultationAddOnPostPayment(
      {Key? key, required this.consultationType, required this.sessions})
      : super(key: key);

  @override
  _ConsultationAddOnPostPaymentState createState() =>
      _ConsultationAddOnPostPaymentState();
}

class _ConsultationAddOnPostPaymentState
    extends State<ConsultationAddOnPostPayment> {
  @override
  initState() {
    Timer(const Duration(seconds: 3), () async {
      Navigator.pop(context);
      Future.delayed(const Duration(seconds: 1), () {
        showScheduleSlotPopUp();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 180.w,
              height: 360.h,
              image: const AssetImage(Images.ballGirlAnimationImage),
            ),
            SizedBox(height: 26.h),
            SizedBox(
              width: 265.w,
              child: Text(
                "Confirming your ${widget.consultationType.toUpperCase() == "DOCTOR" ? "doctor consultation" : "yoga therapist's"} ${widget.sessions > 1 ? "session" : "sessions"}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Baskerville',
                  fontSize: 22.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1.18.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showScheduleSlotPopUp() {
    String message = "";
    if (widget.consultationType == "Doctor") {
      message = (widget.sessions > 1)
          ? "Your purchase is complete for ${widget.sessions} doctor consultation sessions."
          : "Your purchase is complete for your doctor consultation session.";
    } else {
      message = (widget.sessions > 1)
          ? "Your purchase is complete for ${widget.sessions} yoga therapist sessions."
          : "Your purchase is complete for your yoga therapist session.";
    }

    Get.defaultDialog(
        title: "",
        backgroundColor: Colors.transparent,
        radius: 0,
        content: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: (widget.consultationType == "Doctor") ? 17.h : 31.h),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16.w),
              ),
              width: 328.w,
              height: 200.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 77.h,
                  ),
                  SizedBox(
                    width: 194.w,
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Circular Std"),
                    ),
                  ),
                  SizedBox(
                    height: 17.46.h,
                  ),
                  Padding(
                    padding: pageHorizontalPadding(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color.fromRGBO(86, 103, 137, 0.26),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 9.h,
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Do it Later',
                              style: TextStyle(
                                color: AppColors.secondaryLabelColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Circular Std",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 9.h,
                              ),
                            ),
                            onPressed: () async {
                              Get.back();

                              if (widget.consultationType == "Doctor") {
                                bool isAlreadyBooked = await CoachService()
                                    .checkIsBooked(
                                        globalUserIdDetails!.userId!, "Doctor");
                                if (isAlreadyBooked == false) {
                                  DiseaseDetailsRequest diseaseDetailsRequest =
                                      DiseaseDetailsRequest();
                                  diseaseDetailsRequest.disease = [];
                                  for (var element in subscriptionCheckResponse!
                                      .subscriptionDetails!.disease!) {
                                    diseaseDetailsRequest.disease!.add(
                                      DiseaseDetailsRequestDisease(
                                        diseaseId: element!.diseaseId!,
                                      ),
                                    );
                                  }
                                  Get.to(
                                    DoctorList(
                                      pageSource: "DAY_WISE_PROGRAM",
                                      consultType: "ADD-ON",
                                      bookType: "PAID",
                                    ),
                                  );
                                } else {
                                  showCustomSnackBar(context,
                                      "COMPLETE_DOCTOR_CALL_BOOKED".tr);
                                }
                              } else {
                                bool isAlreadyBooked = await CoachService()
                                    .checkIsBooked(globalUserIdDetails!.userId!,
                                        "Trainer");

                                if (isAlreadyBooked == false) {
                                  DiseaseDetailsRequest diseaseDetailsRequest =
                                      DiseaseDetailsRequest();
                                  diseaseDetailsRequest.disease = [];
                                  if (subscriptionCheckResponse != null &&
                                      subscriptionCheckResponse!
                                              .subscriptionDetails !=
                                          null &&
                                      subscriptionCheckResponse!
                                              .subscriptionDetails!.disease !=
                                          null) {
                                    for (var element
                                        in subscriptionCheckResponse!
                                            .subscriptionDetails!.disease!) {
                                      diseaseDetailsRequest.disease!.add(
                                        DiseaseDetailsRequestDisease(
                                          diseaseId: element!.diseaseId!,
                                        ),
                                      );
                                    }
                                  }
                                  Get.to(
                                    TrainerList(
                                      pageSource: "DAY_WISE_PROGRAM",
                                      consultType: "ADD-ON",
                                      bookType: "PAID",
                                    ),
                                  );
                                } else {
                                  showCustomSnackBar(context,
                                      "COMPLETE_THERAPIST_CALL_BOOKED".tr);
                                }
                              }
                            },
                            child: Text(
                              "Schedule Slot",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Circular Std",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 0.h,
              left: 0.w,
              right: 0,
              child: Image(
                width: widget.consultationType == "Doctor" ? 68.82.w : 119.w,
                height: widget.consultationType == "Doctor" ? 78.h : 83.h,
                image: widget.consultationType == "Doctor"
                    ? const AssetImage(Images.doctorConsultant3Image)
                    : const AssetImage(Images.personalTrainingImageBlue),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ));
  }
}
