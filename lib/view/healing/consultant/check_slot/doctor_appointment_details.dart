// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/healing/user_identification_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/healing/initialAssessment/widgets/assessment_intro.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DoctorAppointmentDetails extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final String doctorProfilePic;
  final CoachAvailableSlotsModelAvailableSlots selectedSlot;
  final String consultType;
  const DoctorAppointmentDetails({
    Key? key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorProfilePic,
    required this.selectedSlot,
    required this.consultType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0.w),
            bottomRight: Radius.circular(24.0.w),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 243.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(160.0.w),
                        bottomRight: Radius.circular(160.0.w),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80.h,
                    child: SizedBox(
                      width: 310.w,
                      child: Text(
                        'Your doctor session is booked. It’s a great step to start your healing journey!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 16.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.2.h,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: (243 - 62).h,
                    left: 0,
                    right: 0,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        circularConsultImage(
                            "DOCTOR", doctorProfilePic, 134, 134),
                        FractionalTranslation(
                          translation: const Offset(0, 0.5),
                          child: SvgPicture.asset(
                            AppIcons.completedSVG,
                            color: AppColors.primaryColor,
                            width: 22.w,
                            height: 22.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20.h,
                    right: 16.w,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80.h,
              ),
              Text(
                doctorName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 24.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1.2.h,
                  fontFamily: 'Baskerville',
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 16.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                  ),
                  text: "DATE".tr,
                  children: <TextSpan>[
                    TextSpan(
                      text: DateFormat.yMMMd()
                          .format(dateFromTimestamp(selectedSlot.fromTime!)),
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 16.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                  ),
                  text: "TIME".tr,
                  children: <TextSpan>[
                    TextSpan(
                      text: DateFormat.jm()
                          .format(dateFromTimestamp(selectedSlot.fromTime!)),
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 13.h,
              ),
              SizedBox(
                width: 279.w,
                child: Text(
                  "You will receive a message with a link to join your call 15 minutes before it starts.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Circular Std",
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: pagePadding(),
                width: 322.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(24.w),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "NOTE_FROM_YOUR_DOCTOR".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFFCAFAF),
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppIcons.tickSVG,
                          width: 14.w,
                          height: 9.5.h,
                          fit: BoxFit.contain,
                          color: AppColors.secondaryLabelColor,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Expanded(
                          child: Text(
                            "LATEST_REPORTS_CONSULTATION".tr,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 13.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppIcons.tickSVG,
                          width: 14.w,
                          height: 9.5.h,
                          fit: BoxFit.contain,
                          color: AppColors.secondaryLabelColor,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Expanded(
                          child: Text(
                            "RELIABLE_INTERNET_SERVICE".tr,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 13.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 36.h,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 160.h,
        padding: pagePadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            consultType == "ADD-ON"
                ? const Offstage()
                : SizedBox(
                    width: 250.w,
                    child: Text(
                      "ANSWER_QUESTIONS_APPOINTMENT".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
            SizedBox(
              height: 16.h,
            ),
            InkWell(
              onTap: () async {
                if (consultType == "ADD-ON") {
                  Navigator.pop(context);
                } else {
                  buildShowDialog(context);

                  UserDetailsResponse? userDetails =
                      await HiveService().getUserDetails();

                  UserIdentificationController userIdentificationController =
                      Get.put(UserIdentificationController());
                  bool isAvailable = await userIdentificationController
                      .getUserIdentificationId(
                          "Initial Assessment", DiseaseDetailsRequest(), "");

                  Navigator.pop(context);

                  if (isAvailable == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssessmentIntro(
                          pageSource: "BOOK_DOCTOR_SLOT",
                          userName: userDetails!.userDetails!.firstName!,
                          categoryName: "",
                        ),
                      ),
                    );
                  } else {
                    showCustomSnackBar(context, "SOMETHING_WENT_WRONG".tr);
                  }
                }
              },
              child: mainButton(
                  consultType == "ADD-ON" ? "Okay" : "TAKE_ASSESSMENT_NOW".tr),
            )
          ],
        ),
      ),
    );
  }
}
