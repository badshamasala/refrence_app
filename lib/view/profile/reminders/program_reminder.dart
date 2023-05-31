import 'package:aayu/controller/program/program_reminder_controller.dart';
import 'package:aayu/controller/program/programme_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/programme/set_reminder.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProgramReminder extends StatelessWidget {
  const ProgramReminder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProgramReminderController reminderController =
        Get.put(ProgramReminderController());

    reminderController.getReminderDetails();

    return GetBuilder<ProgramReminderController>(
        builder: (programReminderController) {
      if (programReminderController.isLoading.value == true) {
        return showLoading();
      } else if (subscriptionCheckResponse == null) {
        return const Offstage();
      } else if (subscriptionCheckResponse!.subscriptionDetails == null) {
        return const Offstage();
      }
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
                  subscriptionCheckResponse!.subscriptionDetails!.diseaseName!,
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
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32))),
                      builder: (context) {
                        return const SetReminder();
                      },
                    ).then((value) {
                      if (value == "Updated") {
                        programReminderController.getReminderDetails();
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFEFF1F2), width: 1)),
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
                                  text: (programReminderController
                                                  .programReminderDetails
                                                  .value !=
                                              null &&
                                          programReminderController
                                                  .programReminderDetails
                                                  .value!
                                                  .reminderTime !=
                                              null &&
                                          programReminderController
                                              .programReminderDetails
                                              .value!
                                              .reminderTime!
                                              .isNotEmpty)
                                      ? "YOUR_DAILY_PRACTICE_TIME_IS_SET_FOR".tr
                                      : "SET_A_TIME_FOR_YOUR_DAILY_PRACTICE".tr,
                                ),
                                if (programReminderController
                                            .programReminderDetails.value !=
                                        null &&
                                    programReminderController
                                            .programReminderDetails
                                            .value!
                                            .reminderTime !=
                                        null &&
                                    programReminderController
                                        .programReminderDetails
                                        .value!
                                        .reminderTime!
                                        .isNotEmpty)
                                  TextSpan(
                                    text: DateFormat('hh:mm a').format(
                                        programReminderController.reminderTime),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(32),
                                                  topRight:
                                                      Radius.circular(32))),
                                          builder: (context) {
                                            return const SetReminder();
                                          },
                                        ).then((value) {
                                          if (value == "Updated") {
                                            programReminderController
                                                .getReminderDetails();
                                          }
                                        });
                                      },
                                    style: TextStyle(
                                        color: const Color(0xFF5B6381),
                                        fontSize: 16.sp,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w700),
                                  )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 11.w,
                        ),
                        CupertinoSwitch(
                          activeColor: const Color(0xFFFCAFAF),
                          value: (programReminderController
                                          .programReminderDetails.value !=
                                      null &&
                                  programReminderController
                                          .programReminderDetails
                                          .value!
                                          .sendNotification !=
                                      null)
                              ? programReminderController.programReminderDetails
                                  .value!.sendNotification!
                              : false,
                          onChanged: (val) async {
                            if ((programReminderController
                                        .programReminderDetails.value !=
                                    null &&
                                programReminderController.programReminderDetails
                                        .value!.sendNotification !=
                                    null)) {
                              programReminderController.programReminderDetails
                                  .value!.sendNotification = val;
                              programReminderController.update();
                              programReminderController
                                  .updateProgramReminderTime();
                            } else {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        topRight: Radius.circular(32))),
                                builder: (context) {
                                  return const SetReminder();
                                },
                              ).then((value) {
                                if (value == "Updated") {
                                  programReminderController
                                      .getReminderDetails();
                                }
                              });
                            }
                          },
                        )
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
                  Images.yogaClockImage,
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
    });
  }
}
