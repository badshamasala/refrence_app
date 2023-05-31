import 'package:aayu/controller/content/content_review_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/content_details/widgets/review_user.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ContentReviwsAll extends StatelessWidget {
  final String contentId;
  const ContentReviwsAll({Key? key, required this.contentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContentReviewController contentReviewController =
        Get.put(ContentReviewController(contentId), tag: contentId);
    contentReviewController.getAllContentReviewDetails(contentId);
    return Scaffold(
      appBar: appBar("Rating and Reviews", Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: Obx(() {
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
        return ListView.builder(
          shrinkWrap: true,
          padding: pagePadding(),
          itemCount:
              contentReviewController.contentReviews.value!.reviews!.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(13.w),
              margin: EdgeInsets.only(bottom: 13.w),
              decoration: BoxDecoration(
                  color: AppColors.lightSecondaryColor,
                  borderRadius: BorderRadius.circular(16.w)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReviewUser(
                    createdAt: contentReviewController
                        .contentReviews.value!.reviews![index]!.createdAt!,
                    profilePic: contentReviewController.contentReviews.value!
                            .reviews![index]!.profilePhoto ??
                        "",
                    userName: contentReviewController
                            .contentReviews.value!.reviews![index]!.userName ??
                        "",
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  Text(
                    contentReviewController
                        .contentReviews.value!.reviews![index]!.comments!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
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
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: SvgPicture.asset(
                            (ratingIndex <=
                                    contentReviewController.contentReviews
                                        .value!.reviews![index]!.rating!)
                                ? AppIcons.ratingFilledSVG
                                : AppIcons.ratingUnfilledSVG,
                            width: 16,
                            height: 16,
                            color: AppColors.secondaryLabelColor,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}