import 'package:aayu/controller/consultant/nutrition/nutrition_list_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/widgets/consultant_not_available.dart';
import 'package:aayu/view/nudgets/need_help.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'widget/nutritionist_card.dart';

class NutritionistList extends StatelessWidget {
  final String pageSource;
  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionDoctorId;

  const NutritionistList({
    Key? key,
    this.pageSource = "",
    this.isReschedule = false,
    this.prevSessionId = "",
    this.prevSessionDoctorId = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NutritionListController nutritionListController =
        Get.put(NutritionListController());
    Future.delayed(Duration.zero, () async {
      await nutritionListController.getStartingPlan();
      nutritionListController.getNutritionList();
    });
    return Scaffold(
        body: Column(
      children: [
        Container(
          width: double.infinity,
          height: 100.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(Images.planSummaryBGImage),
            ),
          ),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            title: Text(
              "Select your Nutritionist",
              style: appBarTextStyle(),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 20.w,
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
        ),
        Obx(() {
          if (nutritionListController.isLoading.value == true) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [showLoading()],
              ),
            );
          } else if (nutritionListController.nutritionListResponse.value ==
              null) {
            return const ConsultantNotAvailable(
                consultationType: "NUTRITIONIST");
          } else if (nutritionListController
                  .nutritionListResponse.value!.coachList ==
              null) {
            return const ConsultantNotAvailable(
                consultationType: "NUTRITIONIST");
          } else if (nutritionListController
              .nutritionListResponse.value!.coachList!.isEmpty) {
            return const ConsultantNotAvailable(
                consultationType: "NUTRITIONIST");
          }
          return Expanded(
            child: ListView.separated(
              padding: pageHorizontalPadding(),
              shrinkWrap: true,
              itemCount: nutritionListController
                  .nutritionListResponse.value!.coachList!.length,
              separatorBuilder: (context, index) {
                if (index == 3) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 24.h),
                    child: const NeedHelp(),
                  );
                }
                return const Offstage();
              },
              itemBuilder: (context, index) {
                String packageStartsFrom = "";
                if (nutritionListController
                            .nutritionStartingPlansResponse.value !=
                        null &&
                    nutritionListController
                            .nutritionStartingPlansResponse.value!.packages !=
                        null &&
                    nutritionListController.nutritionStartingPlansResponse
                        .value!.packages!.isNotEmpty &&
                    nutritionListController.nutritionListResponse.value!
                            .coachList![index]!.level !=
                        null &&
                    nutritionListController.nutritionListResponse.value!
                        .coachList![index]!.level!.isNotEmpty) {
                  NutritionStaringPlansModelPackages? package =
                      nutritionListController
                          .nutritionStartingPlansResponse.value!.packages!
                          .firstWhereOrNull((element) =>
                              element!.packageType!.toUpperCase() ==
                              nutritionListController.nutritionListResponse
                                  .value!.coachList![index]!.level!
                                  .toUpperCase());
                  if (package != null) {
                    packageStartsFrom =
                        "Plan starts from ${package.currency?.display} ${package.purchaseAmount}";
                  }
                }
                if (packageStartsFrom.isEmpty) {
                  return const Offstage();
                }
                return Padding(
                  padding: index == 0
                      ? EdgeInsets.symmetric(vertical: 24.h)
                      : (index ==
                              nutritionListController.nutritionListResponse
                                      .value!.coachList!.length -
                                  1)
                          ? EdgeInsets.only(bottom: 56.h)
                          : EdgeInsets.only(bottom: 24.h),
                  child: NutritionistCard(
                    pageSource: pageSource,
                    coachDetails: nutritionListController
                        .nutritionListResponse.value!.coachList![index]!,
                    packageStartsFrom: packageStartsFrom,
                  ),
                );
              },
            ),
          );
        }),
      ],
    ));
  }
}
