import 'dart:async';

import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controller/consultant/doctor_session_controller.dart';
import '../../../../theme/app_colors.dart';
import '../../../shared/ui_helper/images.dart';

class JoinCallWidget extends StatefulWidget {
  const JoinCallWidget({Key? key}) : super(key: key);

  @override
  State<JoinCallWidget> createState() => _JoinCallWidgetState();
}

class _JoinCallWidgetState extends State<JoinCallWidget> {
  bool sessionBooked = false;
  String date = '';
  int secondsRemaining = 0;
  Timer? timer;
  String formatDate = '';
  DoctorSessionController? doctorSessionController;

  String returnTimeFormat(int seconds) {
    String hours = ((seconds / 3600).floor() % 24).toString().padLeft(2, '0');
    String minutes = ((seconds / 60).floor() % 60).toString().padLeft(2, '0');
    String sec = (seconds % 60).floor().toString().padLeft(2, '0');
    return hours + ' hr ' + minutes + ' mins ' + sec + ' sec';
  }

  @override
  void initState() {
    super.initState();
    doctorSessionController = Get.put(DoctorSessionController());
    doctorSessionController!.getUpcomingSessions().then((value) {
      if (doctorSessionController!
              .upcomingSessionsList.value!.upcomingSessions !=
          null) {
        if (doctorSessionController!
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty) {
          if (doctorSessionController!.upcomingSessionsList.value!
                  .upcomingSessions![0]!.secondsRemaining !=
              null) {
            secondsRemaining = doctorSessionController!.upcomingSessionsList
                .value!.upcomingSessions![0]!.secondsRemaining!;
          } else {
            DateTime dateTime = dateFromTimestamp(doctorSessionController!
                .upcomingSessionsList.value!.upcomingSessions![0]!.fromTime!);
            String meridiem = DateFormat("A").format(dateTime);
            if (meridiem == 'PM') {
              dateTime = dateTime.add(const Duration(hours: 12));
            }
            secondsRemaining = dateTime.difference(DateTime.now()).inSeconds;
          }
          if (secondsRemaining <= 900) {
            timer = Timer.periodic(const Duration(seconds: 1), (ti) {
              setState(() {
                secondsRemaining = secondsRemaining - 1;
              });
            });
          }

          setState(() {
            sessionBooked = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (doctorSessionController!
                    .upcomingSessionsList.value!.upcomingSessions ==
                null ||
            doctorSessionController!
                .upcomingSessionsList.value!.upcomingSessions!.isEmpty)
        ? const SizedBox()
        : Container(
            margin: EdgeInsets.only(right: 24.w),
            width: 274.w,
            height: 154.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFBF7E7),
              borderRadius: BorderRadius.circular(16),
            ),
            padding:
                EdgeInsets.only(top: 26.h, bottom: 0, left: 23.h, right: 23.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'FREE_DOCTOR_CONSULTATION_MSG'.tr,
                  style: TextStyle(
                      fontFamily: 'Baskerville',
                      color: const Color(0xFF374957),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'FREE_DOCTOR_CONSULTATION_SCHEDULE_FOR'.tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.blueGreyAssessmentColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          formatDate,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.blueGreyAssessmentColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        CircleAvatar(
                          radius: 16.h,
                          backgroundColor: AppColors.primaryColor,
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )),
                    Image.asset(
                      Images.doctorConsultant2Image,
                      width: 60.w,
                      fit: BoxFit.fitWidth,
                    )
                  ],
                )
              ],
            ));
  }
}
