// ignore_for_file: use_build_context_synchronously

import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/healing/consultant/doctor_list.dart';
import 'package:aayu/view/new_deeplinks/book_freee_doctor.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/consultant/doctor_session_controller.dart';
import '../../../../theme/app_colors.dart';
import '../../../healing/consultant/sessions/doctor_sessions.dart';

class DoctorRoutineWidget extends StatelessWidget {
  const DoctorRoutineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (globalUserIdDetails?.userId == null) {
          userLoginDialog({"screenName": "BOOK_DOCTOR_CONSULT"});
          return;
        }
        HiveService().isFirstTimeDoctorConsultation().then((value) {
          if (value == true) {
            Get.bottomSheet(
              BookFreeDoctor(
                allowBack: true,
                bookFunction: () {
                  Navigator.of(context).pop();
                  handleClick(context);
                },
              ),
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: false,
            ).then((value) {
              HiveService().initFirstTimeDoctorConsultation();
            });
          } else {
            handleClick(context);
          }
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 180.h,
            width: 155.w,
            decoration: const BoxDecoration(
                color: AppColors.myRoutineBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.only(top: 42.0, left: 16.0, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Consult a Doctor",
                    style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Circular Std"),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  Text(
                    'Online health consultation with expert doctors for your personal care.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Schedule Now',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFF3E3A93),
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11.h,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 14.w,
            top: -25,
            child: Image.asset(
              Images.myRoutineDoctor,
              height: 60.h,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }

  handleClick(BuildContext context) {
    DoctorSessionController doctorSessionController = Get.find();

    if (doctorSessionController.upcomingSessionsList.value != null &&
        doctorSessionController.upcomingSessionsList.value!.upcomingSessions !=
            null &&
        doctorSessionController
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty) {
      CoachUpcomingSessionsModelUpcomingSessions? pendingSession =
          doctorSessionController.upcomingSessionsList.value!.upcomingSessions!
              .firstWhereOrNull((element) => element!.status == 'PENDING');
      if (pendingSession != null) {
        EventsService().sendClickNextEvent(
            "DoctorConsultationInfo", "Select Doctor", "DoctorSessions");
        Get.to(const DoctorSessions());
      } else {
        redirectToDoctorList(context);
      }
    } else {
      redirectToDoctorList(context);
    }
  }

  redirectToDoctorList(BuildContext context) async {
    bool isAllowed = await checkIsPaymentAllowed("DOCTOR_CONSULTATION");
    if (isAllowed == true) {
      buildShowDialog(context);
      Navigator.pop(context);
      EventsService().sendClickNextEvent(
          "DoctorConsultationInfo", "Select Doctor", "DoctorList");
      Get.to(const DoctorList(
        pageSource: "MY_ROUTINE",
        consultType: "GOT QUERY",
        bookType: "PAID",
      ));
    }
  }
}
