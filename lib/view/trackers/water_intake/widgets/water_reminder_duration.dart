import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WaterReminderDuration extends StatelessWidget {
  const WaterReminderDuration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WaterIntakesController waterIntakesController = Get.find();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                "Drink Water Interval",
                style: TextStyle(
                  fontFamily: "Baskerville",
                  color: AppColors.blackLabelColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackLabelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: pageHorizontalPadding(),
          child: GetBuilder<WaterIntakesController>(
              id: "WaterReminderDurationList",
              builder: (controller) {
                return Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: List.generate(
                      waterIntakesController.waterIntervalDurationList.length,
                      (index) {
                    return InkWell(
                      onTap: () {
                        for (var element in waterIntakesController
                            .waterIntervalDurationList) {
                          element["selected"] = false;
                        }
                        waterIntakesController.waterIntervalDurationList[index]
                            ["selected"] = true;

                        controller.update(["WaterReminderDurationList"]);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 30.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.w),
                          color: (waterIntakesController
                                          .waterIntervalDurationList[index]
                                      ["selected"] ==
                                  true)
                              ? AppColors.primaryColor
                              : AppColors.lightSecondaryColor,
                        ),
                        child: Text(
                          waterIntakesController
                              .waterIntervalDurationList[index]["text"]
                              .toString(),
                          textAlign: TextAlign.center,
                          style: (waterIntakesController
                                          .waterIntervalDurationList[index]
                                      ["selected"] ==
                                  true)
                              ? TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "Circular Std",
                                )
                              : TextStyle(
                                  color: AppColors.primaryLabelColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "Circular Std",
                                ),
                        ),
                      ),
                    );
                  }),
                );
              }),
        ),
        Padding(
          padding: pagePadding(),
          child: InkWell(
            onTap: () {
              for (var element
                  in waterIntakesController.waterIntervalDurationList) {
                if (element["selected"] == true) {
                  waterIntakesController.waterIntervalDuration.value =
                      int.parse(element["value"].toString());
                  break;
                }
              }
              waterIntakesController.update(["WaterReminderValues"]);
              Navigator.of(context).pop();
            },
            child: mainButton("Done"),
          ),
        )
      ],
    );
  }
}
