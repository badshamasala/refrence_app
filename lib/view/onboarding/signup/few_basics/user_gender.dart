import 'package:aayu/controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/onboarding/onboarding.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserGender extends StatelessWidget {
  final PageController pageController;
  const UserGender({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OnboardingBottomSheetController onboardingBottomSheetController =
        Get.find();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 26.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          onboardingTitleMessage("YOU_ARE_UNIQUE".toUpperCase().tr),
          SizedBox(
            height: 42.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: Text(
              "Nice to meet you, ${onboardingBottomSheetController.userNameController.text}!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.5.h,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "YOU_IDENTIFY_AS".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Baskerville',
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          GetBuilder<OnboardingBottomSheetController>(builder: (controller) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  controller.genderList.length,
                  (index) => GestureDetector(
                    onTap: () {
                      if (controller.genderList[index]["gender"] == "Male") {
                        controller.genderSelected.value = 1;
                        controller.userGender = "Male";
                      } else if (controller.genderList[index]["gender"] ==
                          "Female") {
                        controller.genderSelected.value = 2;
                        controller.userGender = "Female";
                      } else if (controller.genderList[index]["gender"] ==
                          "Non-Binary") {
                        controller.genderSelected.value = 3;
                        controller.userGender = "Non-Binary";
                      }

                      controller.update();
                    },
                    child: Container(
                      padding: EdgeInsets.zero,
                      margin: (index == 1)
                          ? EdgeInsets.symmetric(horizontal: 11.w)
                          : EdgeInsets.zero,
                      width: 90.w,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 45.h),
                            padding: EdgeInsets.zero,
                            width: 90.w,
                            height: 107.h,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                      125, 130, 138, 0.07999999821186066),
                                  offset: Offset(0, 10),
                                  blurRadius: 20,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 60.h,
                                ),
                                Text(
                                  controller.genderList[index]["gender"]
                                      .toString(),
                                  style:
                                      primaryFontPrimaryLabelSmallTextStyle(),
                                ),
                                FractionalTranslation(
                                  translation: const Offset(0, 0.5),
                                  child: CircleCheckbox(
                                    activeColor: AppColors.primaryColor,
                                    value: (controller.genderList[index]
                                                    ["gender"]
                                                .toString() ==
                                            'Male'
                                        ? controller.genderSelected.value == 1
                                        : (controller.genderList[index]
                                                        ["gender"]
                                                    .toString() ==
                                                'Female')
                                            ? controller.genderSelected.value ==
                                                2
                                            : controller.genderSelected.value ==
                                                3),
                                    onChanged: (value) {
                                      if (controller.genderList[index]["gender"]
                                              .toString() ==
                                          "Male") {
                                        controller.genderSelected.value = 1;
                                      } else if (controller.genderList[index]
                                                  ["gender"]
                                              .toString() ==
                                          "Female") {
                                        controller.genderSelected.value = 2;
                                      } else if (controller.genderList[index]
                                                  ["gender"]
                                              .toString() ==
                                          "Non-Binary") {
                                        controller.genderSelected.value = 3;
                                      }

                                      if (controller.genderSelected.value ==
                                          1) {
                                        controller.userGender = "Male";
                                      } else if (controller
                                              .genderSelected.value ==
                                          2) {
                                        controller.userGender = "Female";
                                      } else if (controller
                                              .genderSelected.value ==
                                          3) {
                                        controller.userGender = "Non-Binary";
                                      }

                                      controller.update();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.lightSecondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Image(
                                  image: AssetImage(
                                    controller.genderList[index]["image"]
                                        .toString(),
                                  ),
                                  width: 90.w,
                                  height: 90.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).toList(),
              ),
            );
          }),
          SizedBox(
            height: 60.h,
          ),
          GetBuilder<OnboardingBottomSheetController>(
              builder: (genderSelector) {
            return InkWell(
              onTap: genderSelector.genderSelected.value == 0
                  ? null
                  : () async {
                      if (genderSelector.genderSelected.value == 0) {
                        showGetSnackBar("PLEASE_PROVIDE_YOUR_IDENTITY".tr,
                            SnackBarMessageTypes.Info);
                      } else {
                        buildShowDialog(context);
                        bool isUpdated = await genderSelector.updateProfile();
                        Navigator.pop(context);

                        if (isUpdated == true) {
                          EventsService().sendClickNextEvent(
                              "SignUp_UserGender",
                              "NextButton",
                              "SignUp_UserBirthDate");
                          pageController.nextPage(
                              duration: Duration(
                                  milliseconds: defaultAnimateToPageDuration),
                              curve: Curves.easeIn);
                        } else {
                          showCustomSnackBar(
                              context, "FAILED_TO_SAVE_DETAILS".tr);
                        }
                      }
                    },
              child: SizedBox(
                width: 158.w,
                child: genderSelector.genderSelected.value == 0
                    ? disabledMainButton("NEXT".tr)
                    : mainButton("NEXT".tr),
              ),
            );
          }),
          const SizedBox(
            height: 32.0,
          ),
          InkWell(
            onTap: () async {
              buildShowDialog(context);
              EventsService().sendEvent(
                  "Aayu_Profile_Skiped", {"page_name": "SignUp_UserGender"});
              EventsService().sendClickNextEvent(
                  "SignUp_UserGender", "Skip", "PersonalisingYourSpace");
              OnboardingBottomSheetController onboardingBottomSheetController =
                  Get.find();
              await onboardingBottomSheetController.getAndSetUserProfile();
              Navigator.pop(context);
              Get.to(Onboarding(
                showSkip: true,
                personalisingYourSpace: true,
              ));
            },
            child: Text(
              "SKIP".tr,
              style: const TextStyle(
                fontFamily: "Circular Std",
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
                color: AppColors.secondaryLabelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
