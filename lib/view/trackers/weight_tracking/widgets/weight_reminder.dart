// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/weight_tracking/widgets/change_weight_reminder_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeightReminder extends StatelessWidget {
  final bool showSaveButton;
  const WeightReminder({Key? key, required this.showSaveButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pagePadding(),
      width: 322.w,
      margin: EdgeInsets.only(left: 26.w, right: 26.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19.w),
        color: const Color(0xFFFFEEEE),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WEIGHT TRACKING REMINDER",
            style: TextStyle(
              color: const Color(0xFFFF8B8B),
              fontSize: 18.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          SizedBox(
            width: 220.w,
            child: Text(
              "Get reminded to log your weight",
              style: TextStyle(
                color: const Color(0xFF768897),
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Weight tracking Reminder",
                style: TextStyle(
                  color: const Color(0xFF768897),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Transform.scale(
                scale: 0.6,
                transformHitTests: false,
                child: GetBuilder<WeightDetailsController>(
                  id: "WeightReminderSwitch",
                  builder: (controller) {
                    return CupertinoSwitch(
                      value: controller.enableReminder,
                      activeColor: const Color(0xFF94E79F),
                      trackColor: const Color(0xFF090B0F).withOpacity(0.5),
                      thumbColor: AppColors.whiteColor,
                      onChanged: (value) {
                        controller.reminderDetailsChanged = true;
                        controller.enableReminder = !controller.enableReminder;
                        controller.update(
                            ["WeightReminderSwitch", "WeightReminderValues"]);
                      },
                    );
                  },
                ),
              )
            ],
          ),
          GetBuilder<WeightDetailsController>(
              id: "WeightReminderValues",
              builder: (controller) {
                if (controller.enableReminder == false) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                          visible: showSaveButton &&
                              controller.reminderDetailsChanged,
                          child: SizedBox(height: 26.h)),
                      Visibility(
                        visible:
                            showSaveButton && controller.reminderDetailsChanged,
                        child: InkWell(
                          onTap: () async {
                            WeightDetailsController weightDetailsController =
                                Get.find();
                            buildShowDialog(context);
                            bool isUpdated =
                                await weightDetailsController.saveReminder();
                            Navigator.pop(context);
                            if (isUpdated == true) {
                              showGetSnackBar("Reminder saved successfully!",
                                  SnackBarMessageTypes.Success);
                            }
                          },
                          child: SizedBox(
                            width: 322.w,
                            child: mainButton("SAVE"),
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Repeat",
                      style: TextStyle(
                        color: const Color(0xFF768897),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    SizedBox(
                      height: 30.h,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.reminderDaysList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller.reminderDetailsChanged = true;
                              if (controller.reminderDaysList[index]
                                      ["selected"] ==
                                  true) {
                                controller.reminderDaysList[index]["selected"] =
                                    false;
                              } else {
                                controller.reminderDaysList[index]["selected"] =
                                    true;
                              }
                              controller.update(["WeightReminderValues"]);
                            },
                            child: Container(
                              width: 30.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.reminderDaysList[index]
                                            ["selected"] ==
                                        true
                                    ? const Color(0xFFF39D9D)
                                    : AppColors.whiteColor,
                              ),
                              child: Center(
                                child: Text(
                                  controller.reminderDaysList[index]["text"]
                                      .toString(),
                                  style: TextStyle(
                                    color: controller.reminderDaysList[index]
                                                ["selected"] ==
                                            true
                                        ? AppColors.secondaryLabelColor
                                        : const Color(0xFFF39D9D),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 8.w,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Text(
                      "We'll remind you to check in at",
                      style: TextStyle(
                        color: const Color(0xFF768897),
                        fontSize: 14.sp,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Circular Std",
                      ),
                    ),
                    SizedBox(height: 8.h),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          builder: (context) {
                            return const ChangeWeightReminderTime();
                          },
                        );
                      },
                      child: GetBuilder<WeightDetailsController>(
                          id: "WeightReminderTime",
                          builder: (controller) {
                            return Text(
                              DateFormat('hh:mm a')
                                  .format(controller.reminderTime),
                              style: TextStyle(
                                color: const Color(0xFFFF8B8B),
                                fontSize: 16.sp,
                                fontFamily: 'Circular Std',
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            );
                          }),
                    ),
                    Visibility(
                        visible:
                            showSaveButton && controller.reminderDetailsChanged,
                        child: SizedBox(height: 26.h)),
                    Visibility(
                      visible:
                          showSaveButton && controller.reminderDetailsChanged,
                      child: InkWell(
                        onTap: () async {
                          WeightDetailsController weightDetailsController =
                              Get.find();
                          buildShowDialog(context);
                          bool isUpdated =
                              await weightDetailsController.saveReminder();
                          Navigator.pop(context);
                          if (isUpdated == true) {
                            showGetSnackBar("Reminder saved successfully!",
                                SnackBarMessageTypes.Success);
                          }
                        },
                        child: SizedBox(
                          width: 322.w,
                          child: mainButton("SAVE"),
                        ),
                      ),
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }
}
