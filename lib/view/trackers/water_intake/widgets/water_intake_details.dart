// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WaterIntakeDetails extends StatelessWidget {
  const WaterIntakeDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WaterIntakesController waterIntakesController = Get.find();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      margin: pageHorizontalPadding(),
      width: 322.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19.w),
        color: const Color(0xffF7F7F7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "WATER INTAKE",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xff768897),
              fontSize: 18.sp,
            ),
          ),
          buildIntakeDateSelection(),
          Text(
            "Drink Water \nLive Better",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Baskerville",
              color: const Color(0xFFFF8B8B),
              fontSize: 32.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
          /* Text(
            "Almost there... Stay hydrated",
            style: TextStyle(
              color: const Color(0xff768897),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(
            height: 30.h,
          ), */
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                Images.waterDropSVGImage,
                width: 141.w,
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                top: 87.h,
                child: GetBuilder<WaterIntakesController>(
                  id: "WaterIntakeIndicator",
                  builder: (controller) {
                    return Text(
                      "${(controller.waterIntake.value / 1000).toStringAsFixed(3)}\nLtr",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF768897),
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          GetBuilder<WaterIntakesController>(
              id: "WaterIntakeTargetDetails",
              builder: (controller) {
                if (controller.enableDailyTarget.value == false) {
                  return const Offstage();
                }
                return Column(
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      "${(waterIntakesController.dailyTarget.value / 1000).toStringAsFixed(3)} Ltr",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF768897),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "(Target)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFC4C4C4),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }),
          SizedBox(
            height: 36.h,
          ),
          Text(
            "Add Drink",
            style: TextStyle(
              color: const Color(0xffFF8B8B),
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 18.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  // buildShowDialog(context);
                  await waterIntakesController
                      .addUpdateWaterIntake("SUBSTRACT");
                  // Navigator.pop(context);
                },
                child: Container(
                  width: 29.w,
                  height: 29.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w),
                    color: const Color(0xffC4C4C4),
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 18.w,
              ),
              Image.asset(
                Images.waterGlassImage,
                width: 83.w,
                height: 83.h,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                width: 18.w,
              ),
              InkWell(
                onTap: () async {
                  // buildShowDialog(context);
                  await waterIntakesController.addUpdateWaterIntake("ADD");
                  // Navigator.pop(context);
                },
                child: Container(
                  width: 29.w,
                  height: 29.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w),
                    color: const Color(0xffC4C4C4),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6.h,
          ),
          Text(
            "1 Glass = 250ml",
            style: TextStyle(
              color: const Color(0xff768897),
              fontFamily: "Circular Std",
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  buildIntakeDateSelection() {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFFBEBA)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: GetBuilder<WaterIntakesController>(
          id: "WaterIntakeDate",
          builder: (controller) {
            int daysDifference =
                controller.intakeDate.value.difference(DateTime.now()).inDays;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (daysDifference > -3)
                      ? () {
                          controller.setIntakeDate("BACK");
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: (daysDifference > -3)
                          ? const Color(0xffFF8B8B)
                          : const Color(0xFF768897),
                      size: 24,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_month,
                  color: Color(0xFFFFBEBA),
                  size: 20,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  formatSelectedDate(controller.intakeDate.value),
                  style: TextStyle(
                    color: const Color(0xFF768897),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: (daysDifference < 0)
                      ? () {
                          controller.setIntakeDate("NEXT");
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: (daysDifference < 0)
                          ? const Color(0xffFF8B8B)
                          : const Color(0xFF768897),
                      size: 24,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  formatSelectedDate(DateTime date) {
    String tempDate = DateFormat('dd MMM').format(date);
    if (tempDate == DateFormat('dd MMM').format(DateTime.now())) {
      return "Today";
    } else if (tempDate ==
        DateFormat('dd MMM')
            .format(DateTime.now().subtract(const Duration(days: 1)))) {
      return "Yesterday";
    }
    return tempDate;
  }
}
