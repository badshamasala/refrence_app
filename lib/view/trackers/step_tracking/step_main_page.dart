// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/did_you_know_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/cross_promotions/did_you_know.dart';
import 'package:aayu/view/trackers/step_tracking/widget/step_tracker_calender.dart';
import 'package:aayu/view/trackers/step_tracking/widget/step_tracker_weekly_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../controller/daily_records/step_tracker/step_details_controller.dart';
import '../../cross_promotions/cross_promotions.dart';
import '../../shared/ui_helper/ui_helper.dart';
import '../sleep_tracking/widget/sleep_tracker_calendar.dart';
import '../sleep_tracking/widget/sleep_tracker_weekly_insight_table.dart';

class StepMainPage extends StatelessWidget {
  StepMainPage({Key? key}) : super(key: key);
  StepsDetailsController stepDetailsController =
      Get.put(StepsDetailsController());

  int? number;
  String? formattedNumber;
  method() {
    number = 10000;
    NumberFormat formatter = NumberFormat('#,###');
    formattedNumber = formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    method();
    DidYouKnowController didYouKnowController = Get.put(DidYouKnowController());
    Future.delayed(Duration.zero, () {
      didYouKnowController.getDidYouKnow("WEIGHT");
      stepDetailsController.getStepSummary();
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          "Step Tracker",
          style: TextStyle(
            color: Color(0xffFF8B8B),
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Circular Std',
          ),
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
      body: ListView(
        children: [
          buildSelectionOptions(),
          Obx(() {
            return stepDetailsController.selectedIndex.value == "Weekly"
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0x40C4C4C4), width: 5)),
                    child: CircularPercentIndicator(
                      backgroundColor: Colors.transparent,
                      radius: 100.0,
                      lineWidth: 10.0,
                      animation: true,
                      percent: 0.7,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$formattedNumber",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 48.sp,
                                fontFamily: "Circular Std",
                                color: Color(0xff768897)),
                          ),
                          Text(
                            "Today",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                fontFamily: "Circular Std",
                                color: Color(0xffF39D9D)),
                          ),
                          Text(
                            "Goal 10000",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                fontFamily: "Circular Std",
                                color: Color(0xff768897)),
                          ),
                        ],
                      ),
                      circularStrokeCap: CircularStrokeCap.square,
                      progressColor: const Color(0xffAAFDB4),
                    ),
                  )
                :stepDetailsController.selectedIndex.value == "Monthly"
                ?  StepTrackerCalender() : StepTrackerWeeklyInsightTable();
          }),

          SizedBox(
            height: 20.h,
          ),
          Center(
            child: Text(
              "Goal Achieved",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                color: const Color(0xffFF8B8B),
                fontFamily: "Circular Std",

                // height: 2.h
              ),
            ),
          ),
          Center(
            child: Text(
              "Reached your daily steps goal",
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff768897),
                  fontFamily: "Circular Std"),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          const CrossPromotions(
            key: Key("WATER_INTAKE"),
            moduleName: "WATER_INTAKE",
          ),

          // buildChart(),
          const DidYouKnow(
            category: "WEIGHT",
          ),
        ],
      ),
    );
  }

  buildSelectionOptions() {
    return Padding(
      padding: pageHorizontalPadding(),
      child: GetBuilder<StepsDetailsController>(
          id: "StepSummaryDurationList",
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 33.h,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.summaryDurationList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              for (var element
                                  in controller.summaryDurationList) {
                                element["selected"] = false;
                              }

                              controller.summaryDurationList[index]
                                  ["selected"] = true;
                              controller.changeIndex(index);
                              buildShowDialog(context);
                              await controller.getStepSummary();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 100.w,
                              height: 33.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.w),
                                color: (controller.summaryDurationList[index]
                                            ["selected"] ==
                                        true)
                                    ? AppColors.primaryColor
                                    : AppColors.whiteColor,
                                border:
                                    Border.all(color: AppColors.primaryColor),
                              ),
                              child: Center(
                                child: Text(
                                  controller.summaryDurationList[index]["text"]
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: (controller.summaryDurationList[index]
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
                                          color: const Color(0xFF768897),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Circular Std",
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10.w,
                          );
                        },
                      )),
                ),
                buildSummaryeDateSelection(controller)
              ],
            );
          }),
    );
  }

  buildSummaryeDateSelection(StepsDetailsController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFFBEBA)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              buildShowDialog(Get.context!);
              await controller.setPreviousDate();
              Navigator.pop(Get.context!);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFFF8B8B),
              size: 20,
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
            DateFormat('dd MMM yyyy').format(controller.fromDate),
            style: TextStyle(
              color: const Color(0xFF768897),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              "-",
              style: TextStyle(
                color: const Color(0xFF768897),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            DateFormat('dd MMM yyyy').format(controller.toDate),
            style: TextStyle(
              color: const Color(0xFF768897),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () async {
              buildShowDialog(Get.context!);
              await controller.setNextDate();
              Navigator.pop(Get.context!);
            },
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFFF8B8B),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  buildChart() {
    return GetBuilder<StepsDetailsController>(
        id: "StepSummary",
        builder: (controller) {
          if (controller.summarayDetails == null) {
            return const Offstage();
          } else if (controller.summarayDetails?.summary == null) {
            return const Offstage();
          } else if (controller.summarayDetails!.summary!.isEmpty) {
            return const Offstage();
          }

          List<ChartData> columnChartData = [];
          String duration = controller.summaryDurationList
              .firstWhere((element) => element["selected"] == true)["text"]
              .toString();
          for (var element in controller.summarayDetails!.summary!) {
            if (duration == "Yearly") {
              columnChartData.add(ChartData(
                element?.checkInDate ?? "",
                element?.avgWeight ?? 0,
              ));
            } else {
              columnChartData.add(ChartData(
                element?.checkInDate ?? "",
                element?.avgWeight ?? 0,
              ));
            }
          }

          String xAxisTitle = "Date";
          if (duration == "Yearly") {
            xAxisTitle = "Month";
          }
          return SizedBox(
            height: 400.h,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelRotation:
                    (duration == "Yearly" || duration == "Weekly") ? 90 : 0,
                title: AxisTitle(
                  text: xAxisTitle,
                  textStyle: TextStyle(
                    color: AppColors.secondaryLabelColor.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                labelStyle: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                interval: (duration == "Monthly") ? 7 : 1,
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
                title: AxisTitle(
                  text:
                      "Weight (${toTitleCase(controller.summarayDetails?.defaultUnit!.toLowerCase() ?? "KG")})",
                  textStyle: TextStyle(
                    color: AppColors.secondaryLabelColor.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                labelStyle: TextStyle(
                  color: const Color(0xFFFF8B8B),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              series: <CartesianSeries>[
                // Render column series
                ColumnSeries<ChartData, String>(
                  dataSource: columnChartData,
                  xValueMapper: (ChartData data, _) => data.x.toUpperCase(),
                  yValueMapper: (ChartData data, _) => data.y,
                  pointColorMapper: (ChartData data, _) =>
                      data.y >= controller.targetWeight
                          ? const Color(0xFF7FE3F0)
                          : const Color(0xFFD9D9D9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(48),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}
