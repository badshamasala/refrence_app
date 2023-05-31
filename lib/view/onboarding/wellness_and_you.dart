import 'package:aayu/controller/onboarding/wellness_and_you_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/onboarding/signup/personalising_your_space.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WellnessAndYou extends StatelessWidget {
  final PageController pageController;
  final bool showSkip;
  final bool personalisingYourSpace;
  const WellnessAndYou(
      {Key? key,
      required this.pageController,
      this.showSkip = true,
      required this.personalisingYourSpace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WellnessAndYouController wellnessAndYouController = Get.find();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              wellnessAndYouController.wellnessAssessment.title!.toUpperCase(),
              textAlign: TextAlign.center,
              style: primaryFontPrimaryLabelExtraSmallTextStyle(),
            ),
            SizedBox(
              height: 9.h,
            ),
            SizedBox(
              width: 260.w,
              child: Text(
                wellnessAndYouController.wellnessAssessment.question!,
                textAlign: TextAlign.center,
                style: secondaryFontTitleTextStyle(),
              ),
            ),
            SizedBox(
              height: 36.h,
            ),
            ShowNetworkImage(
              imgPath: wellnessAndYouController.wellnessAssessment.image!,
              imgWidth: 268.w,
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
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: GetBuilder<WellnessAndYouController>(
                    builder: (wellnessAndYouController) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.w,
                    runSpacing: 10.h,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: List.generate(
                      wellnessAndYouController
                          .wellnessAssessment.options!.length,
                      (index) {
                        return InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            wellnessAndYouController.toggleSelection(index);
                          },
                          child: BuildChip(
                            title: wellnessAndYouController
                                .wellnessAssessment.options![index]!.text!,
                            isSelected: wellnessAndYouController
                                .wellnessAssessment.options![index]!.selected!,
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            InkWell(
              onTap: () {
                EventsService().sendEvent('Wellness_Screen_Next', {
                  "pageName": "WellnessAndYou",
                  "actionSource": "Next",
                  "nextPage": "HealingAndYou",
                });
                pageController.animateToPage(1,
                    duration:
                        Duration(milliseconds: defaultAnimateToPageDuration),
                    curve: Curves.easeIn);
              },
              child: SizedBox(
                width: 150.w,
                child: mainButton("NEXT".tr),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            (showSkip == true)
                ? InkWell(
                    onTap: () {
                      showSkipPopupScreen(context, () {
                        EventsService().sendEvent('Wellness_Screen_Skip', {
                          "pageName": "WellnessAndYou",
                          "actionSource": "Skip",
                          "nextPage": "Onboarding Bottom Sheet",
                        });
                        Get.to(const PersonalisingYourSpace(
                          isSkiped: true,
                        ));
                      });
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
    );
  }
}
