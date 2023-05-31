import 'package:aayu/controller/consultant/coach_session_review_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/reviews/coach_session_feedback.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CoachSessionReviews extends StatelessWidget {
  final String coachType;
  const CoachSessionReviews({Key? key, required this.coachType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CoachSessionReviewController coachSessionReviewController =
        Get.put(CoachSessionReviewController());
    coachSessionReviewController.getPendingReviews(coachType);
    return GetBuilder<CoachSessionReviewController>(
        id: "CoachSessionReviews",
        builder: (coachSessionReviewController) {
          if (coachSessionReviewController.pendingReviewsList.value == null) {
            return const Offstage();
          } else if (coachSessionReviewController
                  .pendingReviewsList.value!.pendingReviews ==
              null) {
            return const Offstage();
          } else if (coachSessionReviewController
              .pendingReviewsList.value!.pendingReviews!.isEmpty) {
            return const Offstage();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tell us what you think",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              Text(
                "Aayu uses it to help improve your call experience",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5.h,
                ),
              ),
              SizedBox(
                height: 190.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: List.generate(
                      coachSessionReviewController.pendingReviewsList.value!
                          .pendingReviews!.length, (index) {
                    return Container(
                      width: 274.w,
                      padding: EdgeInsets.all(12.w),
                      margin: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.w),
                        border: Border.all(
                          color: AppColors.secondaryColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              circularConsultImage(
                                  coachType,
                                  coachSessionReviewController
                                      .pendingReviewsList
                                      .value!
                                      .pendingReviews![index]!
                                      .coach!
                                      .profilePic,
                                  64,
                                  64),
                              SizedBox(
                                width: 14.w,
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Text(
                                      coachSessionReviewController
                                          .pendingReviewsList
                                          .value!
                                          .pendingReviews![index]!
                                          .coach!
                                          .coachName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColors.secondaryLabelColor,
                                        fontFamily: 'Circular Std',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5.h,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Date : ${DateFormat('dd MMM yyyy').format(dateFromTimestamp(coachSessionReviewController.pendingReviewsList.value!.pendingReviews![index]!.fromTime!))}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.secondaryLabelColor
                                          .withOpacity(0.7),
                                      fontFamily: 'Circular Std',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5.h,
                                    ),
                                  ),
                                  Text(
                                    "Time : ${DateFormat('hh:mm aa').format(dateFromTimestamp(coachSessionReviewController.pendingReviewsList.value!.pendingReviews![index]!.fromTime!))}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.secondaryLabelColor
                                          .withOpacity(0.7),
                                      fontFamily: 'Circular Std',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5.h,
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              5,
                              (ratingIndex) {
                                return InkWell(
                                  onTap: () async {
                                    String? result = await Get.to(
                                      CoachSessionFeedback(
                                        coachType: coachType,
                                        sessionDetails:
                                            coachSessionReviewController
                                                .pendingReviewsList
                                                .value!
                                                .pendingReviews![index]!,
                                        rating: ratingIndex,
                                      ),
                                    );
                                    if (result != null && result.isNotEmpty) {
                                      coachSessionReviewController
                                          .getPendingReviews(coachType);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AppIcons.ratingUnfilledSVG,
                                    width: 16,
                                    height: 16,
                                    color: const Color(0xFF2A373B)
                                        .withOpacity(0.6),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InkWell(
                            onTap: () async {
                              String? result = await Get.to(
                                CoachSessionFeedback(
                                  coachType: coachType,
                                  sessionDetails: coachSessionReviewController
                                      .pendingReviewsList
                                      .value!
                                      .pendingReviews![index]!,
                                  rating: 3,
                                ),
                              );
                              if (result != null && result.isNotEmpty) {
                                coachSessionReviewController
                                    .getPendingReviews(coachType);
                              }
                            },
                            child: Text(
                              "Write a review",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontFamily: 'Circular Std',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.5.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              )
            ],
          );
        });
  }
}
