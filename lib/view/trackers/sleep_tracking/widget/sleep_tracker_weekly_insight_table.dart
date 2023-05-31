import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_weekly_summary_controller.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SleepTrackerWeeklyInsightTable extends StatelessWidget {
  const SleepTrackerWeeklyInsightTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late SleepTrackerWeeklySummaryController controller;
    if (SleepTrackerWeeklySummaryController().initialized) {
      controller = Get.find();
    } else {
      controller = Get.put(SleepTrackerWeeklySummaryController());
    }
    Future.delayed(Duration.zero, () {
      controller.getWeeklySummary();
    });

    return GetBuilder<SleepTrackerWeeklySummaryController>(
        builder: (sleepTrackerSummaryController) {
      if (sleepTrackerSummaryController.isLoading.value == true) {
        return Container(
          height: 1000.h,
          alignment: Alignment.center,
          width: double.infinity,
          child: showLoading(),
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 61.h,
          ),
          const Text(
            'Your Weekly Insights',
            style: AppTheme.secondarySmallFontTitleTextStyleSleeptracker,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  sleepTrackerSummaryController.setPreviousWeekSummary();
                },
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Obx(() {
                return Text(
                  sleepTrackerSummaryController.range.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Circular Std',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),
              IconButton(
                onPressed: () {
                  sleepTrackerSummaryController.setNextWeekSummary();
                },
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25.h,
          ),
          SfCartesianChart(
            plotAreaBorderWidth: 0,
            borderWidth: 0,
            enableAxisAnimation: true,
            tooltipBehavior: controller.tooltipBehavior,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            series: <CartesianSeries>[
              ColumnSeries<ChartSampleData, String>(
                enableTooltip: true,
                color: const Color(0xFF76C8E2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(48),
                  topRight: Radius.circular(48),
                ),
                dataSource: sleepTrackerSummaryController.chartData.value
                    .map((e) => ChartSampleData(
                        x: e.x, val: e.val, dateTime: e.dateTime))
                    .toList(),
                xValueMapper: (ChartSampleData data, _) => data.x,
                yValueMapper: (ChartSampleData data, _) => data.val,
              ),
            ],
            primaryXAxis: CategoryAxis(
              axisLine: const AxisLine(width: 1),
              interval: 1,
              labelStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Circular Std',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900),
              majorTickLines: const MajorTickLines(size: 0, width: 0),
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              axisLine: const AxisLine(
                width: 1,
              ),
              labelFormat: '{value}h',
              labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              majorTickLines: const MajorTickLines(size: 0, width: 0),
              majorGridLines: const MajorGridLines(width: 0),
            ),
          ),
          SizedBox(
            height: 46.h,
          )
        ],
      );
    });
  }
}
