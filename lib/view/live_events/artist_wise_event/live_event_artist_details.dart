import 'package:aayu/controller/live_events/past_events_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LiveEventsArtistDetails extends StatelessWidget {
  final String trainerId;
  const LiveEventsArtistDetails({Key? key, required this.trainerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PastEventsController>(
        tag: trainerId,
        builder: (pastEventsController) {
          if (pastEventsController.isLoading.value == true) {
            return const Offstage();
          } else if (pastEventsController.artistWisePastLiveEvents == null) {
            return const Offstage();
          } else if (pastEventsController
                  .artistWisePastLiveEvents!.trainerDetails ==
              null) {
            return const Offstage();
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 26.h,
                ),
                Padding(
                  padding: pageHorizontalPadding(),
                  child: Text(
                    pastEventsController
                            .artistWisePastLiveEvents!.trainerDetails!.bio ??
                        '',
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryLabelColor,
                      fontSize: 12.sp,
                      height: 1.2.h,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: pageHorizontalPadding(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Profession: ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackLabelColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            pastEventsController.artistWisePastLiveEvents!
                                .trainerDetails!.profession!.length,
                            (index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                margin: EdgeInsets.only(right: 8.w),
                                constraints: BoxConstraints(minWidth: 80.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.w),
                                  color: AppColors.lightSecondaryColor,
                                ),
                                child: Text(
                                  toTitleCase(pastEventsController
                                      .artistWisePastLiveEvents!
                                      .trainerDetails!
                                      .profession![index]!
                                      .toLowerCase()),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.primaryLabelColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: pageHorizontalPadding(),
                  child: Text(
                    "Spciality: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackLabelColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 560.w,
                    margin: EdgeInsets.symmetric(horizontal: 26.w),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: List.generate(
                        pastEventsController.artistWisePastLiveEvents!
                            .trainerDetails!.speciality!.length,
                        (index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            constraints: BoxConstraints(minWidth: 80.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32.w),
                              color: AppColors.lightSecondaryColor,
                            ),
                            child: Text(
                              toTitleCase(pastEventsController
                                  .artistWisePastLiveEvents!
                                  .trainerDetails!
                                  .speciality![index]!
                                  .toLowerCase()),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryLabelColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ]);
        });
  }
}
