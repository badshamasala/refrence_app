import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_calender_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/trackers/mood_tracking/widget/mood_checkin_details.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewMoodForDay extends StatelessWidget {
  final DateTime selectedDate;
  final String moodType;
  const ViewMoodForDay(
      {Key? key, required this.selectedDate, this.moodType = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoodTrackerCalenderController moodTrackerCalenderController =
        Get.put(MoodTrackerCalenderController());
    moodTrackerCalenderController.getDateWiseCheckInDetails(
        selectedDate, moodType);

    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: true,
            floating: true,
            titleSpacing: 0,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.blackLabelColor,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(height: 120.h),
              centerTitle: true,
              title: Column(children: [
                const Spacer(),
                Text(
                  DateFormat('dd MMM, yyyy').format(selectedDate),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Baskerville',
                  ),
                ),
              ]),
              collapseMode: CollapseMode.parallax,
            ),
            expandedHeight: 120.h,
            backgroundColor: AppColors.pageBackgroundColor,
            leading: const Offstage(),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () {
                if (moodTrackerCalenderController
                        .dateWiseCheckInDetailsLoading.value ==
                    true) {
                  return showLoading();
                } else if (moodTrackerCalenderController.checkInDetails.value ==
                    null) {
                  return const Offstage();
                } else if (moodTrackerCalenderController
                    .checkInDetails.value!.checkInDetails!.isEmpty) {
                  return const Offstage();
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: moodTrackerCalenderController
                      .checkInDetails.value!.checkInDetails!.length,
                  itemBuilder: (context, index) {
                    if (moodTrackerCalenderController
                            .checkInDetails.value?.checkInDetails?[index] ==
                        null) {
                      return const Offstage();
                    }
                    MoodCheckInModel model = moodTrackerCalenderController
                        .checkInDetails.value!.checkInDetails![index]!;

                    return Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 40.h),
                      child: MoodCheckInDetails(checkInDetails: model),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
