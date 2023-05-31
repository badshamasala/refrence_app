// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/healing/consultant/sessions/doctor_sessions.dart';
import 'package:aayu/view/home/widgets/my_routine/join_routine_call.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import '../../../../controller/consultant/doctor_session_controller.dart';
import '../../../../theme/app_colors.dart';

class DoctorCallReminder extends StatefulWidget {
  const DoctorCallReminder({Key? key}) : super(key: key);

  @override
  State<DoctorCallReminder> createState() => _DoctorCallReminderState();
}

class _DoctorCallReminderState extends State<DoctorCallReminder> {
  int hours = 0;
  String date = '';
  int secondsRemaining = 0;
  int days = 0;
  Timer? timer;
  String formatDate = '';
  DateTime? dateTime;
  DoctorSessionController? doctorSessionController;
  bool showWidget = false;
  TimeFormat timeFormat = TimeFormat.showDate;
  bool showJoinCall = false;
  CoachUpcomingSessionsModelUpcomingSessions? doctorSession;

  String returnTimeFormat(int seconds) {
    String hours = ((seconds / 3600).floor() % 24).toString().padLeft(2, '0');
    String minutes = ((seconds / 60).floor() % 60).toString().padLeft(2, '0');
    String sec = (seconds % 60).floor().toString().padLeft(2, '0');
    return '$hours hr $minutes mins $sec sec';
  }

  @override
  void initState() {
    super.initState();
    doctorSessionController = Get.put(DoctorSessionController());

    doctorSessionController!.getUpcomingSessions().then((value) {
      if (doctorSessionController!
              .upcomingSessionsList.value!.upcomingSessions !=
          null) {
        doctorSession = doctorSessionController!
            .upcomingSessionsList.value!.upcomingSessions!
            .firstWhere((element) => element!.sessionId != null);
        if (doctorSessionController!
                .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty &&
            doctorSession != null) {
          DateTime dateTime = dateFromTimestamp(doctorSession!.fromTime!);
          String meridiem = DateFormat("A").format(dateTime);
          if (meridiem == 'PM') {
            dateTime = dateTime.add(const Duration(hours: 12));
          }
          if (doctorSession!.secondsRemaining != null) {
            secondsRemaining = doctorSession!.secondsRemaining!;
          } else {
            secondsRemaining = dateTime.difference(DateTime.now()).inSeconds;
          }
          calculateTimeRemaining();
          if (secondsRemaining <= 86400) {
            timer = Timer.periodic(const Duration(seconds: 1), (ti) {
              setState(() {
                calculateTimeRemaining();
              });
            });
          } else {
            days = (secondsRemaining / 86400).floor();
            formatDate = DateFormat('EEE, MMM dd,\n hh:mm aa').format(dateTime);
          }
          setState(() {
            showWidget = true;
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

  calculateTimeRemaining() {
    if (secondsRemaining < 86400 && secondsRemaining > 3600) {
      timeFormat = TimeFormat.showHours;
    }
    if (secondsRemaining <= 3600) {
      timeFormat = TimeFormat.showMinutes;
    }
    secondsRemaining = secondsRemaining - 1;
    if (secondsRemaining <= 0) {
      showJoinCall = true;
      if (timer != null) {
        timer!.cancel();
      }
    }
    if (timeFormat == TimeFormat.showHours) {
      formatDate = '\n' +
          (secondsRemaining / 3600).floor().toString() +
          " hours " +
          (((secondsRemaining / 60).floor()) % 60).toString() +
          " min";
    }
    if (timeFormat == TimeFormat.showMinutes) {
      formatDate = '\n' +
          (secondsRemaining / 60).floor().toString() +
          " : " +
          (secondsRemaining % 60).toString() +
          " min";
    }
  }

  @override
  Widget build(BuildContext context) {
    return showJoinCall
        ? JoinRoutineCall(
            profession: "Doctor",
            sessionId: doctorSession!.sessionId!,
            coachId: doctorSession!.coach!.coachId ?? "",
            profilePic: doctorSession!.coach!.profilePic ?? "",
            coachName: doctorSession!.coach!.coachName ?? "",
          )
        : InkWell(
            onTap: () {
              EventsService().sendClickNextEvent(
                  "DoctorCallReminder", "My Routine", "DoctorSessions");
              Get.to(const DoctorSessions())!.then((value) {
                EventsService().sendClickBackEvent(
                    "DoctorSessions", "Back", "DoctorCallReminder");
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
                    padding: const EdgeInsets.only(top: 42.0, left: 16.0),
                    child: showWidget
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your meeting with ",
                                style: TextStyle(
                                    color: AppColors.secondaryLabelColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Circular Std"),
                              ),
                              SizedBox(
                                height: 20,
                                width: double.infinity,
                                child: Marquee(
                                  text: doctorSession!.coach!.coachName ?? "",
                                  velocity: 50,
                                  blankSpace: 20.0,
                                  pauseAfterRound: const Duration(seconds: 1),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  scrollAxis: Axis.horizontal,
                                  accelerationDuration:
                                      const Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      const Duration(milliseconds: 500),
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
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  style: TextStyle(
                                      color: AppColors.blueGreyAssessmentColor,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400),
                                  children: [
                                    TextSpan(
                                      text: timeFormat == TimeFormat.showDate
                                          ? 'is on '
                                          : 'starts in ',
                                    ),
                                    TextSpan(
                                      text: formatDate,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                            ],
                          )
                        : const Offstage(),
                  ),
                ),
                Positioned(
                  bottom: 18,
                  left: 18,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: timeFormat == TimeFormat.showDate
                        ? Text(
                            "$days " "${days == 1 ? "Day" : "Days"} " "to go",
                            style: TextStyle(
                                color: AppColors.doctorTextColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Circular Std"),
                          )
                        : const Icon(
                            Icons.timer_sharp,
                            color: Color(0xFF6CA2E9),
                            size: 25,
                          ),
                  ),
                ),
                Positioned(
                  top: -25,
                  right: 14.w,
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
}
