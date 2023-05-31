import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_controller.dart';
import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/controller/you_tracker/you_tracker_controller.dart';
import 'package:aayu/model/you_tracker/you_tracker_model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/mood_tracking/intro/mood_checkin_intro.dart';
import 'package:aayu/view/trackers/sleep_tracking/intro/sleep_tracker_intro.dart';
import 'package:aayu/view/trackers/water_intake/intro/water_intake_intro.dart';
import 'package:aayu/view/trackers/weight_tracking/intro/weight_tracking_intro.dart';
import 'package:aayu/view/trackers/you_tracker/you_tracker_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserTrackerList extends StatelessWidget {
  const UserTrackerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    YouTrackerController youTrackerController = Get.put(YouTrackerController());
    return  Container(
          padding: pagePadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Track Your Progress",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: "BaskerVille",
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff374957),
                  height: 1.18.h,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              Obx(() {
                // YouTrackerController controller = Get.put(YouTrackerController());
                final activeTrackers = youTrackerController
                    .youTrackerList.value?.data?.activeTrackers;
                final itemCount = activeTrackers?.length ?? 0;
                //  if (youTrackerController.isLoading.value == true) {
                //         return Expanded(child: showLoading());
                //       }
                // if (youTrackerController.youTrackerList.value ==
                //     null) {
                //   return const Offstage();
                // } else if (youTrackerController
                //         .youTrackerList.value!.data!.activeTrackers ==
                //     null) {
                //   return const Offstage();
                // } else if (youTrackerController
                //     .youTrackerList.value!.data!.activeTrackers!.isEmpty) {
                //   return const Offstage();
                // }
                return GridView.builder(
                  physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: itemCount + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 109.h,
                        crossAxisCount: 3,
                        mainAxisSpacing: 14.h,
                        crossAxisSpacing: 21.w),
                    itemBuilder: (context, index) {
                      if (index ==
                          youTrackerController.youTrackerList.value?.data
                              ?.activeTrackers?.length) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Color(0x4DE0E7EE),
                              borderRadius: BorderRadius.circular(15.sp)),
                          child: IconButton(
                            onPressed: () async {
                              youTrackerController.activeTrackersCopy =
                                  List<UserTrackersDataActiveTrackers?>.from(
                                      youTrackerController.youTrackerList.value
                                          ?.data?.activeTrackers as Iterable);
                              youTrackerController.trackerListCopy =
                                  List<UserTrackersDataActiveTrackers?>.from(
                                      youTrackerController.youTrackerList.value
                                          ?.data?.trackerList as Iterable);
                              youTrackerController.updateVisibility();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => YouTrackerList(),
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                            color: Color(0x99768897),
                            iconSize: 50.sp,
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            if (youTrackerController.youTrackerList.value?.data
                                    ?.activeTrackers?[index]?.tracker ==
                                null) {
                              showGreenSnackBar(context, 'Coming Soon');
                            } else {
                              switch (youTrackerController.youTrackerList.value
                                  ?.data?.activeTrackers?[index]?.tracker
                                  .toString()
                                  .toUpperCase()) {
                                case 'MOOD_TRACKER':
                                  if (MoodTrackerController().initialized ==
                                      false) {
                                    Get.put(MoodTrackerController());
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MoodCheckInIntro(),
                                    ),
                                  );
    
                                  break;
                                case 'SLEEP_TRACKER':
                                  if (SleepTrackerController().initialized ==
                                      false) {
                                    Get.put(SleepTrackerController());
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SleepTrackerIntro(),
                                    ),
                                  );
                                  break;
                                case 'WATER_INTAKE_TRACKER':
                                  Get.put(WaterIntakesController());
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WaterIntakeIntro(),
                                    ),
                                  );
                                  break;
                                case 'WEIGHT_TRACKER':
                                  Get.put(WeightDetailsController());
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WeightTrackingIntro(),
                                    ),
                                  );
                                  break;
    
                                default:
                                  showGreenSnackBar(context, "Coming Soon!");
                              }
                            }
                          },
                          child:  Container(
                              decoration: BoxDecoration(
                                  color: Color(0x4DE0E7EE),
                                  borderRadius: BorderRadius.circular(15.sp)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.network(
                                    youTrackerController
                                            .youTrackerList
                                            .value
                                            ?.data
                                            ?.activeTrackers?[index]
                                            ?.image ??
                                        "",
                                    height: 42.h,
                                    width: 42.w,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.error_outline,
                                        size: 50.sp,
                                        color: Colors
                                            .red, // Customize the error icon color if needed
                                      );
                                    },
                                  ),
                                  Padding(
                                     padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      youTrackerController
                                              .youTrackerList
                                              .value
                                              ?.data
                                              ?.activeTrackers?[index]
                                              ?.displayText
                                              .toString() ??
                                          "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Circular Std",
                                        fontSize: 10.sp,
                                        letterSpacing: 0,
                                        color: AppColors.blueGreyAssessmentColor,
                                        fontWeight: FontWeight.w700,
                                        height: 1.18.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            
                          ),
                        );
                      }
                    });
              })
            ],
          ));
    
  }

 
}
