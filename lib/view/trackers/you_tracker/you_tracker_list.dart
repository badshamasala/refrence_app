import 'package:aayu/services/you.tracker.service.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/you_tracker/you_tracker_controller.dart';
import '../../../model/you_tracker/you_tracker_model.dart';
import 'widget/tracker_card.dart';

class YouTrackerList extends StatelessWidget {
  YouTrackerList({
    Key? key,
  }) : super(key: key);

  YouTrackerController youTrackerController = Get.find<YouTrackerController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.all(12),
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
      bottomNavigationBar:
          GetBuilder<YouTrackerController>(builder: (controller) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 26.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                offset: Offset(-5, 10),
                blurRadius: 20,
              )
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              controller.youTrackerList.value?.data?.activeTrackers =
                  List<UserTrackersDataActiveTrackers?>.from(
                      controller.activeTrackersCopy as Iterable);

              controller.youTrackerList.value?.data?.trackerList =
                  List<UserTrackersDataActiveTrackers?>.from(
                      controller.trackerListCopy as Iterable);

              controller.sennID();
              controller.isLoading.value = true;
              YouTrackerService()
                  .postYouTrackersList(controller.listOfTrackerId)
                  .then((value) {
                controller.isLoading.value = false;
              });
              Navigator.pop(context);
              controller.youTrackerList.refresh();
            },
            style: AppTheme.mainButtonStyle,
            child: const Text(
              "Confirm",
            ),
          ),
        );
      }),
      body: Obx(() {
        return youTrackerController.isLoading.value == true
            ? const Center(
                child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ))
            : ListView(
                padding: pageHorizontalPadding(),
                children: [
                  buildYouTrackers(),
                  SizedBox(
                    height: 50.h,
                  ),
                  buildSelectYourTrackers(),
                ],
              );
      }),
    );
  }

  Widget buildYouTrackers() {
    return Visibility(
        visible: youTrackerController.selectYourTracker.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Trackers",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: AppColors.blackLabelColor,
                fontFamily: "Circular Std",
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GetBuilder<YouTrackerController>(builder: (controller) {
              return ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TrackerListCard(
                      tracker: controller.activeTrackersCopy![index]!,
                      operation: "REMOVE",
                      action: () {
                        controller.removeMethod(index);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                  itemCount: controller.activeTrackersCopy?.length ?? 0);
            }),
          ],
        ),
      );
  }

  Widget buildSelectYourTrackers() {
    return Visibility(
        visible: youTrackerController.youTracker.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Your Trackers",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: const Color(0xff344553),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GetBuilder<YouTrackerController>(builder: (controller) {
              return ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TrackerListCard(
                      tracker: controller.trackerListCopy![index]!,
                      operation: "ADD",
                      action: () {
                        controller.addMethod(index);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                  itemCount: controller.trackerListCopy?.length ?? 0);
            }),
          ],
        ),
      );
  }
}
