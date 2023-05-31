import 'package:aayu/model/subscription/subscription.carousel.model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../controller/payment/subscription_package_controller.dart';

class SubscriptionCarousel extends StatefulWidget {
  final String subscribeVia;

  const SubscriptionCarousel({Key? key, required this.subscribeVia})
      : super(key: key);

  @override
  State<SubscriptionCarousel> createState() => _SubscriptionCarouselState();
}

class _SubscriptionCarouselState extends State<SubscriptionCarousel> {
  int carouselIndex = 0;

  List<SubscriptionCarouselModelListModel?> carouselList = [];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionPackageController>(builder: (controller) {
      if (controller.isCarouselLoading.value == true) {
        return SizedBox(
            height: 210.h, width: double.infinity, child: showLoading());
      } else if (controller.subscriptionCarouselModel.value == null) {
        return SizedBox(
            height: 210.h, width: double.infinity, child: showLoading());
      } else {
        if (widget.subscribeVia == "HEALING") {
          carouselList =
              controller.subscriptionCarouselModel.value!.healing ?? [];
        } else if (widget.subscribeVia == 'PERSONAL_CARE') {
          carouselList =
              controller.subscriptionCarouselModel.value!.personalCare ?? [];
        } else {
          carouselList = controller.subscriptionCarouselModel.value!.grow ?? [];
        }

        return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 400.h,
                  child: CarouselSlider.builder(
                    itemCount: carouselList.length,
                    itemBuilder: (BuildContext context, int index, int value) {
                      return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            LottieBuilder.network(
                                carouselList[index]!.image ?? "",
                                width: double.infinity,
                                fit: BoxFit.fitWidth),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 63.w, left: 63.w, bottom: 70.h),
                              child: Text(
                                carouselList[index]!.text ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.blueGreyAssessmentColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ]);
                    },
                    options: CarouselOptions(
                      initialPage: 0,
                      height: 480.h,
                      enlargeCenterPage: false,
                      autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          carouselIndex = index;
                        });
                      },
                      autoPlay: true,
                      reverse: false,
                      enableInfiniteScroll: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 2000),
                      pauseAutoPlayOnTouch: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      carouselList.length,
                      (index) => Container(
                        width: 8.h,
                        height: 8.h,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: carouselIndex == index
                              ? AppColors.primaryColor
                              : const Color(0xFFC4C4C4).withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                )
              ],
            ));
      }
    });
  }
}
