import 'package:aayu/controller/consultant/nutrition/nutrition_session_controller.dart';
import 'package:aayu/controller/consultant/psychologist/psychology_session_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:marquee/marquee.dart';
import '../../../../controller/consultant/doctor_session_controller.dart';
import '../../../../controller/consultant/trainer_session_controller.dart';
import '../../../../theme/app_colors.dart';

class JoinRoutineCall extends StatelessWidget {
  final String coachId;
  final String coachName;
  final String profilePic;
  final String sessionId;
  final String profession;
  const JoinRoutineCall(
      {Key? key,
      required this.coachId,
      required this.coachName,
      required this.profilePic,
      required this.profession,
      required this.sessionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (profession.toUpperCase()) {
          case "DOCTOR":
            DoctorSessionController controller =
                Get.put(DoctorSessionController());
            controller.handleCallJoin(context, coachId, sessionId);
            break;
          case "TRAINER":
            TrainerSessionController controller =
                Get.put(TrainerSessionController());
            controller.handleCallJoin(context, coachId, sessionId);
            break;
          case "NUTRITIONIST":
            NutritionSessionController controller =
                Get.put(NutritionSessionController());
            controller.handleCallJoin(context, coachId, sessionId);
            break;
          case "PSYCHOLOGIST":
            PsychologySessionController controller =
                Get.put(PsychologySessionController());
            controller.handleCallJoin(context, coachId, sessionId);
            break;
        }
        if (profession == "") {
        } else {}
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 180.h,
            width: 155.w,
            decoration: BoxDecoration(
                color: profession.toUpperCase() == "DOCTOR"
                    ? AppColors.myRoutineBackgroundColor
                    : AppColors.shareAayuBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.only(top: 42.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      "Join your call with",
                      style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Circular Std"),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                    child: Marquee(
                      text: "    $coachName",
                      velocity: 50,
                      blankSpace: 20.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      scrollAxis: Axis.horizontal,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                      style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Circular Std"),
                    ),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      "Your ${profession.toLowerCase()} session has started",
                      style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Circular Std"),
                    ),
                  ),
                  const Spacer(),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.zero,
                        height: 34.0,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                        ),
                        child: Center(
                            child: Text(
                          "Join Now",
                          style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Circular Std"),
                        )),
                      ))
                ],
              ),
            ),
          ),
          profilePic.trim().isEmpty
              ? Positioned(
                  top: -20,
                  right: 34.w,
                  child: Image.asset(
                    profession.toUpperCase() == "DOCTOR"
                        ? Images.doctorConsultant3Image
                        : Images.personalTraining2Image,
                    height: 48.h,
                    fit: BoxFit.fitHeight,
                  ),
                )
              : Positioned(
                  right: 30,
                  top: -23.h,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 23.h,
                        backgroundImage: NetworkImage(
                          profilePic,
                        ),
                      ),
                      Positioned(
                          top: -3,
                          right: 5,
                          child: Container(
                            height: 11.0,
                            width: 11.0,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                backgroundColor: AppColors.playIconColor,
                                radius: 4,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
