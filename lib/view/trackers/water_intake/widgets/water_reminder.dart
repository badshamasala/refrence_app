// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/water_intake/widgets/water_reminder_duration.dart';
import 'package:aayu/view/trackers/water_intake/widgets/water_reminder_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WaterReminder extends StatelessWidget {
  final bool showSaveButton;
  const WaterReminder({Key? key, required this.showSaveButton})
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
            "WATER INTAKE REMINDER",
            style: TextStyle(
              color: const Color(0xFFFF8B8B),
              fontSize: 18.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          SizedBox(
            width: 250.w,
            child: Text(
              "It is recommended that you drink at least 3 ltr of water every day",
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
                "Drink Water Reminder",
                style: TextStyle(
                  color: const Color(0xFF768897),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Transform.scale(
                scale: 0.6,
                transformHitTests: false,
                child: GetBuilder<WaterIntakesController>(
                  id: "WaterReminderSwitch",
                  builder: (controller) {
                    return CupertinoSwitch(
                        value: controller.enableWaterReminder.value,
                        activeColor: const Color(0xFF94E79F),
                        trackColor: const Color(0xFF090B0F).withOpacity(0.5),
                        thumbColor: AppColors.whiteColor,
                        onChanged: (value) {
                          controller.enableWaterReminder.value =
                              !controller.enableWaterReminder.value;
                          controller.update(
                              ["WaterReminderSwitch", "WaterReminderValues"]);
                        });
                  },
                ),
              )
            ],
          ),
          GetBuilder<WaterIntakesController>(
            id: "WaterReminderValues",
            builder: (controller) {
              if (controller.enableWaterReminder.value == false) {
                return const Offstage();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildFromTime(controller, context),
                      const Spacer(),
                      buildToTime(controller, context),
                    ],
                  ),
                  SizedBox(height: 26.h),
                  buildDrinkInterval(controller, context),
                ],
              );
            },
          ),
          Visibility(visible: showSaveButton, child: SizedBox(height: 26.h)),
          Visibility(
            visible: showSaveButton,
            child: InkWell(
              onTap: () async {
                WaterIntakesController waterIntakesController = Get.find();
                int compare = waterIntakesController.fromTime.value
                    .compareTo(waterIntakesController.toTime.value);
                if (compare <= 0) {
                  buildShowDialog(context);
                  bool isUpdated = await waterIntakesController.saveReminder();
                  Navigator.pop(context);
                  if (isUpdated == true) {
                    showGetSnackBar("Reminder saved successfully!",
                        SnackBarMessageTypes.Success);
                  }
                } else {
                  showGreenSnackBar(
                      context, "From time needs to be less than to time");
                }
              },
              child: SizedBox(
                width: 322.w,
                child: mainButton("SAVE"),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildFromTime(
      WaterIntakesController waterIntakesController, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "From",
          style: TextStyle(
            color: const Color(0xFF768897),
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              builder: (context) {
                return const WaterReminderTime(
                  timeType: "FROM TIME",
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              color: AppColors.whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat('hh:mm a')
                      .format(waterIntakesController.fromTime.value),
                  style: TextStyle(
                    color: const Color(0xFFFF8B8B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF768897),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  buildToTime(
      WaterIntakesController waterIntakesController, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "To",
          style: TextStyle(
            color: const Color(0xFF768897),
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
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
                return const WaterReminderTime(
                  timeType: "TO TIME",
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              color: AppColors.whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat('hh:mm a')
                      .format(waterIntakesController.toTime.value),
                  style: TextStyle(
                    color: const Color(0xFFFF8B8B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF768897),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  buildDrinkInterval(
      WaterIntakesController waterIntakesController, BuildContext context) {
    int selectedIndex = 0;
    for (var element in waterIntakesController.waterIntervalDurationList) {
      if (element["selected"] == true) {
        break;
      } else {
        selectedIndex = selectedIndex + 1;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Drink Water Interval",
          style: TextStyle(
            color: const Color(0xFF768897),
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    return const WaterReminderDuration();
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.w),
                  color: AppColors.whiteColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      waterIntakesController
                          .waterIntervalDurationList[selectedIndex]["text"]
                          .toString(),
                      style: TextStyle(
                        color: const Color(0xFFFF8B8B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF768897),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Text(
                "* will remind you every ${waterIntakesController.waterIntervalDurationList[selectedIndex]["text"].toString()}",
                style: TextStyle(
                  color: const Color(0xFF768897),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
