import 'package:aayu/controller/onboarding/healing_and_you_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/onboarding/signup/personalising_your_space.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HealingAndYou extends StatelessWidget {
  final bool showSkip;
  final PageController pageController;
  final bool personalisingYourSpace;
  const HealingAndYou(
      {Key? key,
      required this.pageController,
      this.showSkip = true,
      required this.personalisingYourSpace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealingAndYouController healingAndYouController = Get.find();

    return WillPopScope(
      onWillPop: () async {
        EventsService().sendEvent('Healing_Screen_Back', {
          "pageName": "HealingAndYou",
          "actionSource": "Back",
          "backPage": "WellnessAndYou",
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
                healingAndYouController.healingAssessment.title!.toUpperCase(),
                textAlign: TextAlign.center,
                style: primaryFontPrimaryLabelExtraSmallTextStyle(),
              ),
              SizedBox(
                height: 11.h,
              ),
              SizedBox(
                width: 244.w,
                child: Text(
                  healingAndYouController.healingAssessment.question!,
                  textAlign: TextAlign.center,
                  style: secondaryFontTitleTextStyle(),
                ),
              ),
              SizedBox(
                height: 38.h,
              ),
              ShowNetworkImage(
                imgPath: healingAndYouController.healingAssessment.image!,
                imgWidth: 296.w,
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
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: GetBuilder<HealingAndYouController>(
                    builder: (healingAndYouController) {
                      return Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.w,
                        runSpacing: 10.h,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: List.generate(
                          healingAndYouController
                              .healingAssessment.options!.length,
                          (index) {
                            return InkWell(
                              splashColor: Colors.white,
                              onTap: () {
                                healingAndYouController.toggleSelection(index);
                              },
                              child: BuildChip(
                                title: healingAndYouController
                                    .healingAssessment.options![index]!.text!,
                                isSelected: healingAndYouController
                                    .healingAssessment
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
                onTap: () {
                  EventsService().sendEvent('Healing_Screen_Next', {
                    "pageName": "HealingAndYou",
                    "actionSource": "Next",
                    "nextPage": "MovementAndYou",
                  });
                  pageController.animateToPage(2,
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
                height: 18.h,
              ),
              (showSkip == true)
                  ? InkWell(
                      onTap: () {
                        showSkipPopupScreen(context, ()  {
                        EventsService().sendEvent('Healing_Screen_Skip', {
                          "pageName": "HealingAndYou",
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
      ),
    );
  }
}
