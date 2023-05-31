// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightSummary extends StatelessWidget {
  const WeightSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 26.h,
        ),
        Text(
          "SUMMARY",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xffFF8B8B),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 26.h,
        ),
        buildSelectionOptions(),
        Align(
          alignment: Alignment.centerRight,
          child: buildWeightGoal(),
        ),
        buildChart(),
      ],
    );
  }

  buildWeightGoal() {
    return GetBuilder<WeightDetailsController>(
      id: "WeightGoalDetails",
      builder: (controller) {
        if (controller.enableWeightGoal == false) {
          return const Offstage();
        }
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFBEBA),
            borderRadius: BorderRadius.circular(5.sp),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Weight Goal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                "${controller.targetWeight.toStringAsFixed(1)} ${toTitleCase(controller.defaultWeightUnit.toLowerCase())}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildSelectionOptions() {
    return Padding(
      padding: pageHorizontalPadding(),
      child: GetBuilder<WeightDetailsController>(
          id: "WeightSummaryDurationList",
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

                              buildShowDialog(context);
                              await controller.getWeightSummary();
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

  buildSummaryeDateSelection(WeightDetailsController controller) {
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
    return GetBuilder<WeightDetailsController>(
        id: "WeightSummary",
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
                controller.targetWeight,
              ));
            } else {
              columnChartData.add(ChartData(
                element?.checkInDate ?? "",
                element?.avgWeight ?? 0,
                controller.targetWeight,
              ));
            }
          }
          return SizedBox(
            height: 360.h,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              margin: EdgeInsets.all(12.sp),
              enableAxisAnimation: true,
              tooltipBehavior: TooltipBehavior(
                  enable: true,
                  header: "Weight",
                  format: 'point.y ${toTitleCase(controller.summarayDetails?.defaultUnit!.toLowerCase() ?? "KG")}',
                  canShowMarker: true),
              primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  interval: (duration == "Monthly") ? 7 : 1,
                  majorGridLines: const MajorGridLines(width: 0),
                  minorGridLines: const MinorGridLines(width: 0),
                  labelIntersectAction: AxisLabelIntersectAction.multipleRows),
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
                // Render Line series
                LineSeries<ChartData, String>(
                  dataSource: columnChartData,
                  color: const Color(0xFFFF8B8B),
                  dashArray: <double>[3, 5],
                  xValueMapper: (ChartData data, _) =>
                      data.duration.replaceFirst("-", "\n").toUpperCase(),
                  yValueMapper: (ChartData data, _) => data.weightGoal,
                ),
                // Render column series
                ColumnSeries<ChartData, String>(
                  dataSource: columnChartData,
                  xValueMapper: (ChartData data, _) =>
                      data.duration.replaceFirst("-", "\n").toUpperCase(),
                  yValueMapper: (ChartData data, _) => data.weight,
                  pointColorMapper: (ChartData data, _) =>
                      data.weight >= controller.targetWeight
                          ? const Color(0xFF7FE3F0)
                          : const Color(0xFFD9D9D9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(48),
                  ),
                  enableTooltip: true,
                ),
              ],
            ),
          );
        });
  }
}

class ChartData {
  final String duration;
  final double weight;
  final double weightGoal;
  ChartData(this.duration, this.weight, this.weightGoal);
}
