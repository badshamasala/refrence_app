import 'package:aayu/controller/onboarding/onboarding_controller.dart';
import 'package:aayu/view/onboarding/healing_and_you.dart';
import 'package:aayu/view/onboarding/movement_and_you.dart';
import 'package:aayu/view/onboarding/wellness_and_you.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboarding extends StatelessWidget {
  final bool showSkip;
  final bool personalisingYourSpace;
  const Onboarding({Key? key, required this.showSkip, this.personalisingYourSpace = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OnboardingController controller = Get.put(OnboardingController());
    controller.getOnboardingAssessment();
    return Scaffold(
      appBar: appBar("", Icons.arrow_back, () {
        if (controller.selectedPage.value == 0) {
          Navigator.pop(context);
        } else {
          controller.pageController.previousPage(
              duration: Duration(milliseconds: defaultAnimateToPageDuration),
              curve: Curves.easeOut);
        }
      }),
      body: Obx(() {
        if (controller.isLoading.value == true) {
          return showLoading();
        }
        return PageView.builder(
          controller: controller.pageController,
          itemCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            controller.setSelectedPage(index);
            switch (index) {
              case 0:
                return WellnessAndYou(
                  showSkip: showSkip,
                  personalisingYourSpace: personalisingYourSpace,
                  pageController: controller.pageController,
                );
              case 1:
                return HealingAndYou(
                  showSkip: showSkip,
                  personalisingYourSpace: personalisingYourSpace,
                  pageController: controller.pageController,
                );
              case 2:
                return MovementAndYou(
                  showSkip: showSkip,
                  personalisingYourSpace: personalisingYourSpace,
                  pageController: controller.pageController,
                );
              default:
                return Container();
            }
          },
        );
      }),
    );
  }
}
