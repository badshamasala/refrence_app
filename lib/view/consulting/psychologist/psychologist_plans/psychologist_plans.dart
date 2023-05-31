import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/psychologist/psychologist_plans/what_you_get.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/offers/widgets/apply_coupon.dart';
import 'package:aayu/view/subscription/offers/widgets/coupon_applied.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/consultant/psychologist/psychology_plan_controller.dart';
import 'psychologist_plan_pricing.dart';

class PsychologistPlans extends StatelessWidget {
  final bool extendPlan;
  const PsychologistPlans({Key? key, required this.extendPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: true,
            floating: true,
            titleSpacing: 0,
            elevation: 0,
            centerTitle: true,
            leading: null,
            flexibleSpace: Stack(
              children: [
                Image(
                  image: const AssetImage(Images.planSummaryBGImage),
                  fit: BoxFit.cover,
                  height: 108.h,
                  width: double.infinity,
                ),
                Positioned(
                  top: 26.h,
                  left: 10.w,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.blackLabelColor,
                    ),
                  ),
                )
              ],
            ),
            expandedHeight: 160.h,
            backgroundColor: AppColors.whiteColor,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: Size(160.w, 160.h),
              child: Image(
                width: 160.w,
                height: 160.h,
                fit: BoxFit.contain,
                image: const AssetImage(Images.mentalWellBeingImage),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 26.w, right: 26.w, bottom: 26.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Mental Wellbeing",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Baskerville",
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  SizedBox(
                    width: 300.w,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor.withOpacity(0.8),
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                          height: 1.2.h,
                        ),
                        text:
                            "Our mental wellbeing program provides you with the support and resources to overcome challenges and thrive in all areas of your life.",
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChoosePsychologyPlans(extendPlan: extendPlan),
                      SizedBox(
                        height: 40.h,
                      ),
                      const WhatYouGet()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChoosePsychologyPlans extends StatelessWidget {
  final bool extendPlan;
  const ChoosePsychologyPlans({Key? key, required this.extendPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PsychologyPlanController psychologyPlanController =
        Get.put(PsychologyPlanController());
    psychologyPlanController
        .getPlans(extendPlan == false ? "FIRST TIME" : "UPGRADE");
    return Obx(() {
      if (psychologyPlanController.isLoading.value == true) {
        return showLoading();
      } else if (psychologyPlanController.psychologyPlansResponse.value ==
          null) {
        return showLoading();
      } else if (psychologyPlanController
              .psychologyPlansResponse.value!.packages ==
          null) {
        return showLoading();
      } else if (psychologyPlanController
          .psychologyPlansResponse.value!.packages!.isEmpty) {
        return showLoading();
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 26.h,
          ),
          Text(
            "Select your package",
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Baskerville',
              fontSize: 20.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          psychologyPlanController.isPromoCodeApplied.value == false
              ? const ApplyCoupon(
                  offerOn: "PSYCHOLOGY PLANS",
                )
              : CouponApplied(
                  offerOn: "PSYCHOLOGY PLANS",
                  appliedPromoCode: psychologyPlanController.appliedPromoCode!,
                  removeFunction: () {
                    psychologyPlanController.removeCoupon();
                  },
                ),
          PsychologyPlanPricing(
            extendPlan: extendPlan,
            psychologyPlanController: psychologyPlanController,
          )
        ],
      );
    });
  }
}
