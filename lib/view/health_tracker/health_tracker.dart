// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/nutrition/health_tracker_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widget/health_tracker_unit_options.dart';

class HealthTracker extends StatelessWidget {
  final String parameter;
  final DateTime startDate;
  final int daysCount;
  const HealthTracker({
    Key? key,
    required this.parameter,
    required this.daysCount,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthTrackerController controller = Get.put(HealthTrackerController());
    Future.delayed(Duration.zero, () async {
      controller.setMinimumDate(startDate);
      await Future.wait([
        controller.getHealthTrackerUnits(parameter),
        controller.getUserHealthTrackingDetails(parameter),
      ]);
      controller.setSelectedDate(controller.selectedDate);
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 80.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(Images.planSummaryBGImage),
                ),
              ),
              child: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                titleSpacing: 0,
                title: Text(
                  "Update ${toTitleCase(parameter.toLowerCase())}",
                  style: appBarTextStyle(),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 20.w,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.blackLabelColor,
                  ),
                ),
              ),
            ),
            Expanded(child: GetBuilder<HealthTrackerController>(
                builder: (healthTrackerController) {
              if (healthTrackerController.isLoading.value == true) {
                return showLoading();
              } else if (healthTrackerController.healthTrackerUnitsData.value ==
                  null) {
                return const Offstage();
              } else if (healthTrackerController
                      .healthTrackerUnitsData.value!.healthTrackerUnits ==
                  null) {
                return const Offstage();
              } else if (healthTrackerController.healthTrackerUnitsData.value!
                      .healthTrackerUnits!.units ==
                  null) {
                return const Offstage();
              } else if (healthTrackerController.healthTrackerUnitsData.value!
                  .healthTrackerUnits!.units!.isEmpty) {
                return const Offstage();
              }

              HealthTrackerUnitsModelHealthTrackerUnitsUnits? selectedUnit;
              for (var element in healthTrackerController
                  .healthTrackerUnitsData.value!.healthTrackerUnits!.units!) {
                if (element!.selected == true) {
                  selectedUnit = element;
                  break;
                }
              }
              String providedAnswer = "";
              if (selectedUnit!.unitPicker == "SINGLE") {
                providedAnswer =
                    "${healthTrackerController.userAnswer} ${selectedUnit.displayUnit}";
              } else {
                providedAnswer =
                    "${healthTrackerController.userAnswer} ${selectedUnit.displayUnit}";
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: pageHorizontalPadding(),
                    child: DatePicker(
                      healthTrackerController.minSelectedDate,
                      controller: healthTrackerController.datePickerController,
                      height: 77.h,
                      width: 50.w,
                      initialSelectedDate:
                          healthTrackerController.initialSelectedDate,
                      selectionColor: AppColors.primaryColor,
                      selectedTextColor: Colors.white,
                      daysCount: daysCount,
                      dateTextStyle: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.secondaryLabelColor,
                        fontWeight: FontWeight.w700,
                      ),
                      monthTextStyle: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.secondaryLabelColor,
                        fontWeight: FontWeight.w400,
                      ),
                      dayTextStyle: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.secondaryLabelColor,
                        fontWeight: FontWeight.w400,
                      ),
                      onDateChange: (selectedDate) {
                        healthTrackerController.setSelectedDate(selectedDate);
                        healthTrackerController.datePickerController
                            .animateToDate(selectedDate);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFBFB),
                      borderRadius: BorderRadius.all(
                        Radius.circular(11.w),
                      ),
                    ),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 16.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                        text: "Your ${toTitleCase(parameter.toLowerCase())}: ",
                        children: <TextSpan>[
                          TextSpan(
                            text: providedAnswer,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 16.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  HealthTrackerUnitOptions(
                      healthTrackerController: healthTrackerController),
                  const Spacer(),
                  SizedBox(
                    width: 322.w,
                    child: (healthTrackerController.selectedDate
                                .compareTo(DateTime.now()) <=
                            0)
                        ? InkWell(
                            onTap: () async {
                              bool isSubmitted = await healthTrackerController
                                  .updateTrackerValue();
                              if (isSubmitted == true) {
                                Navigator.pop(context);
                              } else {
                                showCustomSnackBar(
                                    context, "Failed! Please try again.");
                              }
                            },
                            child: mainButton(
                                "Update ${toTitleCase(parameter.toLowerCase())}"),
                          )
                        : disabledButton(
                            "Update ${toTitleCase(parameter.toLowerCase())}"),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                ],
              );
            }))
          ]),
    );
  }
}
