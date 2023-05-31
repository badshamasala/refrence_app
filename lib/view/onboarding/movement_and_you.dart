import 'package:aayu/controller/home/home_controller.dart';
import 'package:aayu/controller/home/home_top_section_controller.dart';
import 'package:aayu/controller/onboarding/movement_and_you_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/onboarding/onboarding_bottom_sheet.dart';
import 'package:aayu/view/onboarding/signup/personalising_your_space.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MovementAndYou extends StatelessWidget {
  final PageController pageController;
  final bool showSkip;
  final bool personalisingYourSpace;
  const MovementAndYou(
      {Key? key,
      required this.pageController,
      this.showSkip = true,
      required this.personalisingYourSpace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MovementAndYouController movementAndYouController = Get.find();

    return WillPopScope(
      onWillPop: () async {
        EventsService().sendEvent('Movement_And_You_Screen_Back', {
          "pageName": "MovementAndYou",
          "actionSource": "Back",
          "backPage": "HealingAndYou",
        });
        pageController.previousPage(
            duration: Duration(milliseconds: defaultAnimateToPageDuration),
            curve: Curves.easeOut);
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                movementAndYouController.movementAssessment.title!
                    .toUpperCase(),
                textAlign: TextAlign.center,
                style: primaryFontPrimaryLabelExtraSmallTextStyle(),
              ),
              SizedBox(
                height: 9.h,
              ),
              SizedBox(
                width: 281.w,
                child: Text(
                  movementAndYouController.movementAssessment.question!,
                  textAlign: TextAlign.center,
                  style: secondaryFontTitleTextStyle(),
                ),
              ),
              SizedBox(
                height: 38.h,
              ),
              ShowNetworkImage(
                imgPath: movementAndYouController.movementAssessment.image!,
                imgWidth: 290.w,
                imgHeight: 268.h,
                boxFit: BoxFit.contain,
                placeholderImage:
                    "assets/images/placeholder/affirmation_default_placeholder.png",
              ),
              SizedBox(
                height: 40.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 62.w),
                  child: GetBuilder<MovementAndYouController>(
                    builder: (painAndInjuriesController) {
                      return Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: List.generate(
                          painAndInjuriesController
                              .movementAssessment.options!.length,
                          (index) {
                            return InkWell(
                              splashColor: Colors.white,
                              onTap: () {
                                painAndInjuriesController
                                    .toggleSelection(index);
                              },
                              child: BuildChip(
                                title: painAndInjuriesController
                                    .movementAssessment.options![index]!.text!,
                                isSelected: painAndInjuriesController
                                    .movementAssessment
                                    .options![index]!
                                    .selected!,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              InkWell(
                onTap: () async {
                  if (showSkip == true) {
                    EventsService().sendEvent('Movement_And_You_Screen_Next', {
                      "pageName": "MovementAndYou",
                      "actionSource": "Next",
                      "nextPage": "Onboarding Bottom Sheet",
                    });
                    buildShowDialog(context);
                    await movementAndYouController
                        .updateOnboardingAssessment();
                    Navigator.pop(context);

                    if (!personalisingYourSpace) {
                      Navigator.pop(context);
                    } else {
                      Get.to(const PersonalisingYourSpace(
                        isSkiped: true,
                      ));
                    }
                  } else {
                    buildShowDialog(context);
                    bool isUpdated = await movementAndYouController
                        .updateOnboardingAssessment();

                    if (isUpdated == true) {
                      if (personalisingYourSpace) {
                        Get.to(const PersonalisingYourSpace(
                          isSkiped: false,
                        ));
                      } else {
                        HomeController homeController = Get.find();
                        HomeTopSectionController homeTopSectionController =
                            Get.find();
                        await Future.wait([
                          homeController.getHomePageContent(),
                          homeTopSectionController
                              .getHomePageTopSectionContent()
                        ]);
                        homeController.update();
                        homeTopSectionController.update();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    } else {
                      Navigator.of(context).pop();
                      showGetSnackBar("FAILED_TO_UPDATE_DETAILS".tr,
                          SnackBarMessageTypes.Info);
                    }
                  }
                },
                child: SizedBox(
                  width: 150.w,
                  child: mainButton(showSkip == true ? "NEXT".tr : "UPDATE".tr),
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              (showSkip == true)
                  ? InkWell(
                      onTap: () {
                        EventsService()
                            .sendEvent('Movement_And_You_Screen_Skip', {
                          "pageName": "MovementAndYou",
                          "actionSource": "Skip",
                          "nextPage": "Onboarding Bottom Sheet",
                        });
                        Get.bottomSheet(
                          const OnboardingBottomSheet(),
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: false,
                        );
                      },
                      child: Text(
                        "SKIP".tr,
                        style: skipButtonTextStyle(),
                      ),
                    )
                  : const Offstage(),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
