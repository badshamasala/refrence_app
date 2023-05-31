import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_summary_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/sleep_tracking/widget/sleep_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewSleepCheckInForDay extends StatelessWidget {
  final DateTime selectedDate;

  const ViewSleepCheckInForDay({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SleepTrackerSummaryController sleepTrackerSummaryController = Get.find();
    sleepTrackerSummaryController.getDateWiseSleepCheckIn(selectedDate);

    return Scaffold(
        backgroundColor: AppColors.sleepTrackerBackgroundLight,
        body: Obx(
          () {
            if (sleepTrackerSummaryController
                    .dateWiseSleepCheckInLoading.value ==
                true) {
              return showLoading();
            } else if (sleepTrackerSummaryController
                        .dateWiseSleepCheckInModel.value?.checkInDetails ==
                    null ||
                sleepTrackerSummaryController
                    .dateWiseSleepCheckInModel.value!.checkInDetails!.isEmpty) {
              return const Offstage();
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  snap: false,
                  pinned: true,
                  floating: true,
                  titleSpacing: 0,
                  elevation: 0,
                  centerTitle: true,
                  iconTheme:
                      const IconThemeData(color: AppColors.blackLabelColor),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: SizedBox(height: 120.h),
                    centerTitle: true,
                    title: Column(children: [
                      const Spacer(),
                      Text(
                        formatDate(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Baskerville',
                        ),
                      ),
                    ]),
                    collapseMode: CollapseMode.parallax,
                  ),
                  expandedHeight: 120.h,
                  backgroundColor: AppColors.sleepTrackerBackgroundLight,
                  leading: const Offstage(),
                ),
                SliverToBoxAdapter(
                  child: Obx(
                    () {
                      return Column(
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: sleepTrackerSummaryController
                                .dateWiseSleepCheckInModel
                                .value!
                                .checkInDetails!
                                .length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(top: 20.h, bottom: 40.h),
                                child: SleepCard(
                                  icon: sleepTrackerSummaryController
                                          .dateWiseSleepCheckInModel
                                          .value!
                                          .checkInDetails![index]!
                                          .sleep
                                          ?.icon ??
                                      "",
                                  howWasSleep: sleepTrackerSummaryController
                                          .dateWiseSleepCheckInModel
                                          .value!
                                          .checkInDetails![index]!
                                          .sleep
                                          ?.sleep ??
                                      "",
                                  inTime: DateFormat('hh:mm a')
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              sleepTrackerSummaryController
                                                      .dateWiseSleepCheckInModel
                                                      .value!
                                                      .checkInDetails![index]!
                                                      .bedTime ??
                                                  0))
                                      .toUpperCase(),
                                  outTime: DateFormat('hh:mm a')
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              sleepTrackerSummaryController
                                                      .dateWiseSleepCheckInModel
                                                      .value!
                                                      .checkInDetails![index]!
                                                      .wakeupTime ??
                                                  0))
                                      .toUpperCase(),
                                  listReasons: sleepTrackerSummaryController
                                      .dateWiseSleepCheckInModel
                                      .value!
                                      .checkInDetails![index]!
                                      .identifications!
                                      .map((e) => e?.identification ?? "")
                                      .toList(),
                                  duration: sleepTrackerSummaryController
                                          .dateWiseSleepCheckInModel
                                          .value!
                                          .checkInDetails![index]!
                                          .sleepHours ??
                                      0,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }

  String formatDate() {
    return '${DateFormat.d().format(selectedDate)} ${DateFormat.MMM().format(selectedDate)}, ${DateFormat.y().format(selectedDate)}';
  }
}
