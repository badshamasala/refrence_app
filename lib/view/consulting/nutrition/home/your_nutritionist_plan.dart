import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/nutrition_plans/nutrition_extend_plan.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class YourNutritionistPlan extends StatelessWidget {
  final UserNutritionDetailsModel userNutritionDetails;
  const YourNutritionistPlan({
    Key? key,
    required this.userNutritionDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 26.h),
      width: double.infinity,
      color: const Color(0xFFFFF3F3),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      circularConsultImage(
                          "NUTRITIONIST",
                          userNutritionDetails.currentTrainer!.profilePhoto,
                          64,
                          64),
                      SizedBox(
                        width: 14.w,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Text(
                              userNutritionDetails.currentTrainer!.coachName!,
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
                          SizedBox(
                            height: 12.h,
                          ),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                NutritionPlanDetails(
                                    userNutritionDetails: userNutritionDetails),
                                isScrollControlled: true,
                                isDismissible: true,
                                enableDrag: false,
                              );
                            },
                            child: Text(
                              "View Plan",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                fontFamily: 'Circular Std',
                                fontSize: 12.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -17.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 40.h,
                  width: 128.w,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF9FBFE),
                      borderRadius: BorderRadius.circular(100)),
                ),
                Container(
                  height: 24.h,
                  width: 112.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFAAFDB4),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    //"${toTitleCase(userNutritionDetails.selectedPackage!.packageType!.toLowerCase())} Plan",
                    "Your Nutritionist",
                    style: TextStyle(
                        color: const Color(0xFF597393),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NutritionPlanDetails extends StatelessWidget {
  final UserNutritionDetailsModel userNutritionDetails;
  const NutritionPlanDetails({Key? key, required this.userNutritionDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: pagePadding(),
      decoration: BoxDecoration(
        color: AppColors.pageBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your Current Plan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Baskerville",
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
              buildRichTextLabel(
                  "Package Type: ",
                  toTitleCase(userNutritionDetails.selectedPackage!.packageType!
                      .toLowerCase())),
              buildDivider(),
              buildRichTextLabel("Duration: ",
                  userNutritionDetails.selectedPackage!.displayText!),
              buildDivider(),
              buildRichTextLabel(
                  "Start Date: ",
                  DateFormat('dd MMM, yyyy').format(dateFromTimestamp(
                      userNutritionDetails.selectedPackage!.startDate!))),
              buildDivider(),
              buildRichTextLabel(
                  "End Date: ",
                  DateFormat('dd MMM, yyyy').format(dateFromTimestamp(
                      userNutritionDetails.selectedPackage!.endDate!))),
              buildDivider(),
              buildRichTextLabel("Consulting Sessions: ",
                  userNutritionDetails.selectedPackage!.sessions!.toString()),
              buildDivider(),
              buildRichTextLabel("Food Plans: ",
                  userNutritionDetails.selectedPackage!.dietPlans!.toString()),
              SizedBox(
                height: 26.h,
              ),
              Visibility(
                visible: userNutritionDetails.showExtendPlan!,
                child: InkWell(
                  onTap: () {
                    EventsService().sendClickNextEvent("NutritionPlanDetails", "Extend Plan", "NutritionExtendPlan");
                    Navigator.pop(context);
                    Get.to(NutritionExtendPlan(
                      packageType:
                          userNutritionDetails.selectedPackage!.packageType!,
                      coachId: userNutritionDetails.currentTrainer!.coachId!,
                    ));
                  },
                  child: SizedBox(
                    width: 322.w,
                    child: mainButton("Extend Plan"),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0.h,
            left: 0.h,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.secondaryLabelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildDivider() {
    return Divider(
      color: AppColors.secondaryLabelColor.withOpacity(0.3),
    );
  }

  buildRichTextLabel(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontSize: 14.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontSize: 14.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
