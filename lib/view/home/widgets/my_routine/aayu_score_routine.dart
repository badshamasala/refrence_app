import 'package:aayu/controller/healing/insight_card_controller.dart';
import 'package:aayu/view/healing/programme/insight_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../theme/app_colors.dart';
import '../../../shared/ui_helper/images.dart';
import '../../../shared/ui_helper/ui_helper.dart';

class AayuRoutineScoreWidget extends StatelessWidget {
  const AayuRoutineScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InsightCardController>(builder: (insightCardController) {
      if (insightCardController.isLoading.value == true) {
        return showLoading();
      } else if (insightCardController.weeklyHealthCardDetails.value == null) {
        return showLoading();
      } else if (insightCardController
              .weeklyHealthCardDetails.value!.healthCardList ==
          null) {
        return showLoading();
      } else if (insightCardController
                  .weeklyHealthCardDetails.value!.healthCardList!.weeks ==
              null ||
          insightCardController
              .weeklyHealthCardDetails.value!.healthCardList!.weeks!.isEmpty) {
        return showLoading();
      }
      return InkWell(
        onTap: () {
          Get.to(const InsightCard());
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 180.h,
              width: 155.w,
              decoration: const BoxDecoration(
                  color: AppColors.lightPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(top: 42.0, left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Aayu Score ",
                      style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Circular Std"),
                    ),
                    const SizedBox(
                      height: 7.0,
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400),
                        children: [
                          const TextSpan(
                            text: 'Your',
                          ),
                          const TextSpan(
                            text: ' Aayu score',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(
                            text: ' \nfor the week is',
                          ),
                          TextSpan(
                            text:
                                '\n${insightCardController.weeklyHealthCardDetails.value!.healthCardList!.weeks!.last!.totalPercentage ?? 0}%',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CircleAvatar(
                          radius: 14.h,
                          backgroundColor: AppColors.primaryColor,
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 17.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                left: 100,
                top: -20,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      Images.healthCardImage,
                      height: 60.h,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      top: 15.h,
                      child: Text(
                        " ${insightCardController.weeklyHealthCardDetails.value!.healthCardList!.weeks!.last!.totalPercentage ?? 0}%",
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Circular Std',
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      );
    });
  }
}
