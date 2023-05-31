import 'package:aayu/controller/content/content_review_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/content_details/content_reviews_all.dart';
import 'package:aayu/view/content/content_details/widgets/review_user.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ContentReviws extends StatelessWidget {
  final String contentId;
  const ContentReviws({Key? key, required this.contentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ContentReviewController(contentId), tag: contentId);
    return GetBuilder<ContentReviewController>(
        tag: contentId,
        builder: (contentReviewController) {
          if (contentReviewController.isLoading.value == true) {
            return const Offstage();
          } else if (contentReviewController.contentReviews.value == null) {
            return const Offstage();
          } else if (contentReviewController.contentReviews.value?.reviews ==
              null) {
            return const Offstage();
          } else if (contentReviewController
                  .contentReviews.value?.reviews?.isEmpty ==
              true) {
            return const Offstage();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 26.w, right: 26.w, bottom: 26.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Reviews",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 16.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 26.w,
                    ),
                    Visibility(
                      visible: contentReviewController
                              .contentReviews.value!.reviews!.length >
                          10,
                      child: InkWell(
                        onTap: () {
                          Get.to(ContentReviwsAll(contentId: contentId));
                        },
                        child: Text(
                          "VIEW_ALL".tr,
                          style: TextStyle(
                            color: const Color(0xFF2A373B),
                            fontFamily: 'Circular Std',
                            fontSize: 14.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 150.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: contentReviewController
                      .contentReviews.value!.reviews!.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 275.w,
                      padding: EdgeInsets.all(13.w),
                      margin: (index == 0)
                          ? EdgeInsets.only(left: 26.w, right: 13.w)
                          : (index ==
                                  contentReviewController.contentReviews.value!
                                          .reviews!.length -
                                      1)
                              ? EdgeInsets.only(right: 26.w)
                              : EdgeInsets.only(right: 13.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDE8E5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.w),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReviewUser(
                            createdAt: contentReviewController.contentReviews
                                .value!.reviews![index]!.createdAt!,
                            profilePic: contentReviewController.contentReviews
                                    .value!.reviews![index]!.profilePhoto ??
                                "",
                            userName: contentReviewController.contentReviews
                                    .value!.reviews![index]!.userName ??
                                "",
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          Text(
                            contentReviewController.contentReviews.value!
                                .reviews![index]!.comments ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF2A373B).withOpacity(0.6),
                              fontFamily: 'Circular Std',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              height: 1.2.h,
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                              5,
                              (ratingIndex) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: SvgPicture.asset(
                                    (ratingIndex <=
                                            contentReviewController
                                                .contentReviews
                                                .value!
                                                .reviews![index]!
                                                .rating!)
                                        ? AppIcons.ratingFilledSVG
                                        : AppIcons.ratingUnfilledSVG,
                                    width: 16,
                                    height: 16,
                                    color: const Color(0xFF2A373B)
                                        .withOpacity(0.6),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
            ],
          );
        });
  }
}
