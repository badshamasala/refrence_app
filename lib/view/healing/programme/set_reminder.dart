import 'package:aayu/controller/program/program_reminder_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../shared/ui_helper/new_cupertino_date_picker.dart';

class SetReminder extends StatelessWidget {
  final bool? popPage;
  const SetReminder({Key? key, this.popPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProgramReminderController reminderController =
        Get.put(ProgramReminderController());

    Future.delayed(Duration.zero, () {
      reminderController.getReminderDetails();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pageBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.blackLabelColor,
            ),
          )
        ],
      ),
      body: Obx(() {
        if (reminderController.isLoading.value == true) {
          return showLoading();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 136.w,
              height: 76.h,
              image: const AssetImage(Images.yogaClockImage),
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 17.h,
            ),
            Image(
              width: 86.w,
              height: 9.h,
              image: const AssetImage(Images.ellipseImage),
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 28.h,
            ),
            Text(
              "SET_YOUR_DAILY_PRACTICE_TIME".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackLabelColor,
                fontFamily: 'Baskerville',
                fontSize: 24.sp,
                fontWeight: FontWeight.normal,
                height: 1.16.h,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 55.w),
              child: SizedBox(
                width: 266.w,
                child: Text(
                  "15_MINUTES_BEFORE_YOU_START_MSG".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    height: 1.5.h,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 29.h,
            ),
            SizedBox(
              height: 200.h,
              width: 322.w,
              child: NewCupertinoDatePicker(
                mode: NewCupertinoDatePickerMode.time,
                overlayColor: AppColors.primaryColor.withOpacity(0.2),
                textColor: AppColors.blackLabelColor,
                initialDateTime: reminderController.reminderTime,
                onDateTimeChanged: (DateTime changedTime) {
                  reminderController.setReminderTime(changedTime);
                },
              ),
            ),
            SizedBox(
              height: 27.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 35.w,
                ),
                Text(
                  "REPEAT".tr,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    height: 1.5.h,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: GetBuilder<ProgramReminderController>(
                  builder: (dayController) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(
                    dayController.weekDays!.length,
                    (index) => Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          dayController.selectWeekDays(index);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              boxShadow: dayController
                                          .weekDays![index]!.selected ==
                                      true
                                  ? [
                                      const BoxShadow(
                                        offset: Offset(-4, 2),
                                        blurRadius: 5,
                                        color: Color.fromRGBO(0, 0, 0, 0.04),
                                      )
                                    ]
                                  : null,
                              color: dayController.weekDays![index]!.selected ==
                                      true
                                  ? const Color(0xFFFFEEEE)
                                  : const Color(0xFFF4F4F4),
                              shape: BoxShape.circle),
                          child: Text(
                            dayController.weekDays![index]!.day.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight:
                                  dayController.weekDays![index]!.selected ==
                                          true
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                              color: dayController.weekDays![index]!.selected ==
                                      true
                                  ? AppColors.blackLabelColor
                                  : const Color.fromRGBO(118, 136, 151, 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: pagePadding(),
        child: InkWell(
          onTap: () async {
            bool isUpdated =
                await reminderController.updateProgramReminderTime();

            if (isUpdated == true) {
              EventsService().sendEvent("Program_Reminder_Set", {
                "program_id":
                    subscriptionCheckResponse!.subscriptionDetails!.programId,
                "program_name":
                    subscriptionCheckResponse!.subscriptionDetails!.programName,
                "disease_name":
                    subscriptionCheckResponse!.subscriptionDetails!.diseaseName,
                "duration":
                    subscriptionCheckResponse!.subscriptionDetails!.duration,
                "period":
                    subscriptionCheckResponse!.subscriptionDetails!.period,
                "reminder_time": DateFormat.jm().format(
                  reminderController.reminderTime,
                )
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  duration: const Duration(seconds: 2),
                  content: GetBuilder<ProgramReminderController>(
                    builder: (controller) => SizedBox(
                      height: 54.h,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 8),
                                  blurRadius: 29,
                                  color: AppColors.secondaryLabelColor
                                      .withOpacity(0.7),
                                )
                              ],
                            ),
                            width: double.infinity,
                            height: 54.h,
                            child: Image.asset(
                              Images.greenToast,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            'Your daily practice time is set for ${DateFormat("h:mm a").format(controller.reminderTime)}',
                            style: TextStyle(
                              fontFamily: 'Circular Std',
                              color: AppColors.blackLabelColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              if (popPage != null && popPage == true) {
                Navigator.of(context).pop("Updated");
              } else {
                /* Get.to(
                  const MainPage(
                    selectedTab: 1,
                  ),
                ); */
                Navigator.of(context).pop("Updated");
              }
            } else {
              showGetSnackBar(
                  "FAILED_TO_SAVE_DETAILS".tr, SnackBarMessageTypes.Info);
            }
          },
          child: mainButton("SAVE".tr),
        ),
      ),
    );
  }
}
