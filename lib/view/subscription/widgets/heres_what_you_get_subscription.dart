import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/model.dart';
import '../../../theme/theme.dart';

class HeresWhatYouGetSubscription extends StatelessWidget {
  const HeresWhatYouGetSubscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubscriptionPackageController subscriptionPackageController = Get.find();
    return Obx(() {
      if (subscriptionPackageController.isCommunicationLoading.value == true) {
        return Offstage();
      }
      List<Widget> children = [];
      if (subscriptionPackageController
                  .subscriptionCommunicationData.value?.details !=
              null &&
          subscriptionPackageController
              .subscriptionCommunicationData.value!.details!.isNotEmpty) {
        subscriptionPackageController
            .subscriptionCommunicationData.value!.details!
            .forEach((element) {
          if (element != null) {
            children.add(subscriptionCommunicationBlock(element));
          }
        });
      }
      if (subscriptionPackageController
                  .subscriptionTestimonialData.value?.details?.testimonials !=
              null &&
          subscriptionPackageController.subscriptionTestimonialData.value!
              .details!.testimonials!.isNotEmpty) {
        children.add(subscriptionTestimonialsBlock(subscriptionPackageController
            .subscriptionTestimonialData.value!.details!));
      }
      if (subscriptionPackageController
              .subscriptionTestimonialData.value?.details?.bottomText !=
          null) {
        children.add(Padding(
          padding: EdgeInsets.only(left: 26.w, right: 26.w, bottom: 30.h),
          child: Text(
            subscriptionPackageController
                    .subscriptionTestimonialData.value?.details?.bottomText ??
                "",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400),
          ),
        ));
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    });
  }

  Widget subscriptionCommunicationBlock(
      SubscriptionCommunicationModelDetails? details) {
    List<Widget> listOfWidgets = [];
    if (details?.items == null || details!.items!.isEmpty) {
      return Offstage();
    }

    details.items!.forEach((element) {
      listOfWidgets.add(Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              height: 158.h,
              width: 156.w,
              padding: EdgeInsets.only(
                  top: 40.h, left: 10.w, right: 10.w, bottom: 10.h),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  if (element?.item != null && element!.item!.isNotEmpty)
                    Text(
                      element.item ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF496074),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  if (element?.item != null && element!.item!.isNotEmpty)
                    SizedBox(
                      height: 4.h,
                    ),
                  Text(
                    element?.desc ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )),
          Positioned(
            left: 0,
            right: 0,
            top: -38.h,
            child: ShowNetworkImage(
              imgPath: element?.image ?? "",
              imgHeight: 70.h,
              boxFit: BoxFit.fitHeight,
            ),
          )
        ],
      ));
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          (details.section ?? "").toUpperCase(),
          style: TextStyle(
              color: Color(0xFFFF7979),
              fontWeight: FontWeight.w700,
              fontSize: 14.sp),
        ),
        Text(
          (details.subTitle ?? ""),
          style: TextStyle(
              color: AppColors.blueGreyAssessmentColor,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp),
        ),
        SizedBox(
          height: 57.h,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 57.h,
          spacing: 15.w,
          children: listOfWidgets,
        ),
        SizedBox(
          height: 35.h,
        ),
      ],
    );
  }

  Widget subscriptionTestimonialsBlock(
      SubscriptionTestimonialModelDetails details) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          (details.section ?? "").toUpperCase(),
          style: TextStyle(
              color: Color(0xFFFF7979),
              fontWeight: FontWeight.w700,
              fontSize: 14.sp),
        ),
        Text(
          (details.subTitle ?? ""),
          style: TextStyle(
              color: AppColors.blueGreyAssessmentColor,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp),
        ),
        SizedBox(
          height: 26.h,
        ),
        CarouselSlider(
          options: CarouselOptions(
            initialPage: 0,
            enlargeCenterPage: false,
            height: 140.h,
            clipBehavior: Clip.none,
            autoPlay: true,
            reverse: false,
            enableInfiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 2000),
            pauseAutoPlayOnTouch: true,
            scrollDirection: Axis.horizontal,
          ),
          items: List.generate(details.testimonials!.length, (index) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 140.h,
                  padding: EdgeInsets.only(
                      top: 40.h, left: 10.w, right: 10.w, bottom: 10.h),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        details.testimonials![index]!.testimonial ?? "",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors.blackLabelColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "- ${details.testimonials![index]?.userName ?? ""}",
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: -30.h,
                  child: Image.asset(
                    Images.testimonialImage,
                    height: 70.h,
                    fit: BoxFit.fitHeight,
                  ),
                )
              ],
            );
          }),
        ),
        SizedBox(
          height: 26.h,
        ),
      ],
    );
  }
}
