import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../disease_details/disease_details.dart';

class SwitchDisease extends StatelessWidget {
  final bool fromMySubscription;
  const SwitchDisease({Key? key, this.fromMySubscription = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealingListController healingListController = Get.find();

    bool canSwitchProgram =
        subscriptionCheckResponse!.subscriptionDetails!.canSwitchProgram!;

    return Container(
      color: fromMySubscription ? Colors.white : const Color(0xFFFFF6F5),
      child: Column(
        children: [
          if (!fromMySubscription)
            SizedBox(
              height: 28.h,
            ),
          if (!fromMySubscription)
            Text(
              (canSwitchProgram == true)
                  ? "Explore another program"
                  : "Explore our programs",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          const SizedBox(
            height: 7,
          ),
          if (!fromMySubscription)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                (canSwitchProgram == true)
                    ? "Find a different healing program that will work better for you. You can switch your program once within the first 7 days of your healing subscription. "
                    : "Our healing programs are holistic in their\napproach, backed by decades of scientific\nresearch and surprisingly simple to follow.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGreyAssessmentColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
            ),
          SizedBox(
            height: 205.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: healingListController.activeHealingList!.length,
                itemBuilder: (context, index) {
                  if (subscriptionCheckResponse!.subscriptionDetails!.disease!
                      .any((element) =>
                          element!.diseaseId ==
                          healingListController
                              .activeHealingList![index]!.diseaseId)) {
                    return const Offstage();
                  }
                  return InkWell(
                    onTap: () async {
                      await healingListController.setDiseaseFromDeepLink(
                          healingListController
                              .activeHealingList![index]!.diseaseId!);
                      Get.put(DiseaseDetailsController());
                      if (fromMySubscription) {
                        Navigator.of(context).pop();
                      }
                      Get.to(
                        DiseaseDetails(
                          fromThankYou: false,
                          pageSource: (canSwitchProgram == true)
                              ? "SWITCH_PROGRAM"
                              : "EXPLORE_PROGRAM",
                        ),
                      );
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 28,
                              offset: Offset(0, 2),
                              color: Color.fromRGBO(0, 0, 0, 0.07),
                            )
                          ]),
                      width: 123.h,
                      padding: EdgeInsets.only(
                          top: 22.h, bottom: 12.h, left: 9.2.w, right: 9.2.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  height: 67.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF9F6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Positioned(
                                  top: -13.h,
                                  child: ShowNetworkImage(
                                    imgPath: healingListController
                                            .activeHealingList![index]!
                                            .image!
                                            .imageUrl ??
                                        "",
                                    imgHeight: 64.h,
                                    boxFit: BoxFit.fitHeight,
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              healingListController
                                      .activeHealingList![index]!.disease ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.blueGreyAssessmentColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 16.h,
          )
        ],
      ),
    );
  }
}
