// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/services/tracker.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DailyTarget extends StatelessWidget {
  final bool callApi;
  final bool showToggle;
  const DailyTarget({Key? key, required this.callApi, required this.showToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WaterIntakesController waterIntakesController = Get.find();
    return Container(
      padding: pageVerticalPadding(),
      width: 322.w,
      margin: pageHorizontalPadding(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.w),
        color: const Color(0xffF7F7F7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                "SET DAILY TARGET",
                style: TextStyle(
                  color: const Color(0xffFF8B8B),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Visibility(
                visible: showToggle,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Transform.scale(
                    scale: 0.6,
                    transformHitTests: false,
                    child: GetBuilder<WaterIntakesController>(
                        id: "DailyTargetSwitch",
                        builder: (controller) {
                          return CupertinoSwitch(
                              value: controller.enableDailyTarget.value,
                              activeColor: const Color(0xFF94E79F),
                              trackColor:
                                  const Color(0xFF090B0F).withOpacity(0.5),
                              thumbColor: AppColors.whiteColor,
                              onChanged: (value) async {
                                await TrackerService().updateWaterDailyTarget({
                                  "isActive":
                                      !controller.enableDailyTarget.value,
                                  "maxLimit": controller.dailyTarget.value,
                                });
                                controller.enableDailyTarget.value =
                                    !controller.enableDailyTarget.value;
                                controller.update([
                                  "DailyTargetSwitch",
                                  "DailyTarget",
                                  "WaterIntakeTargetDetails"
                                ]);
                              });
                        }),
                  ),
                ),
              )
            ],
          ),
          GetBuilder<WaterIntakesController>(
              id: "DailyTarget",
              builder: (controller) {
                if (controller.enableDailyTarget.value == false) {
                  return const Offstage();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        buildShowDialog(context);
                        await waterIntakesController.setDailyTarget(
                            "SUBSTRACT", callApi);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 29.w,
                        height: 29.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: const Color(0xFFFCAFAF),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Water Intake",
                          style: TextStyle(
                              color: const Color(0xFF768897),
                              fontFamily: "Circular Std",
                              fontSize: 15.sp),
                        ),
                        Text(
                          "${(controller.dailyTarget.value / 1000).toStringAsFixed(3)} Ltr",
                          style: TextStyle(
                            color: const Color(0xFFF39D9D),
                            fontFamily: "Circular Std",
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        buildShowDialog(context);
                        await waterIntakesController.setDailyTarget(
                            "ADD", callApi);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 29.w,
                        height: 29.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: const Color(0xFFFCAFAF),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
