// ignore_for_file: use_build_context_synchronously

import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/consulting/psychologist/initial_assessment/initial_assessment.dart';
import 'package:aayu/view/profile/need_profile_info.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PsychologistAssessmentStart extends StatelessWidget {
  const PsychologistAssessmentStart({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithOnlyLeading(Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 140.w,
              image: const AssetImage(Images.mentalWellBeingUnqiueImage),
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 26.h),
            SizedBox(
              width: 255.w,
              child: Text(
                "Your assessment\nis greatly appreciated.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 24.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                  height: 1.18.h,
                  fontFamily: "Baskerville",
                ),
              ),
            ),
            SizedBox(height: 26.h),
            InkWell(
              onTap: () async {
                UserDetailsResponse? userDetailsResponse =
                    await HiveService().getUserDetails();
                if (userDetailsResponse != null &&
                    userDetailsResponse.userDetails != null) {
                  if (userDetailsResponse.userDetails!.firstName!.isEmpty ||
                      userDetailsResponse.userDetails!.gender!.isEmpty ||
                      userDetailsResponse.userDetails!.dob!.isEmpty) {
                    EventsService().sendClickNextEvent(
                        "HelpUsWithInfo", "Next", "NeedProfileInfo");
                    String? result = await Get.bottomSheet(
                      const NeedProfileInfo(),
                      isScrollControlled: true,
                      isDismissible: true,
                      enableDrag: false,
                    );
                    if (result != null && result.isNotEmpty) {
                      EventsService().sendClickNextEvent("HelpUsWithInfo",
                          "Next", "NutritionInitialAssessment");
                      Navigator.pushReplacement(
                        navState.currentState!.context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PsychologyInitialAssessment(),
                        ),
                      );
                    }
                  } else {
                    EventsService().sendClickNextEvent(
                        "HelpUsWithInfo", "Next", "PsychologyInitialAssessment");
                    Navigator.pushReplacement(
                      navState.currentState!.context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PsychologyInitialAssessment(),
                      ),
                    );
                  }
                } else {
                  EventsService().sendClickNextEvent(
                      "HelpUsWithInfo", "Next", "PsychologyInitialAssessment");
                  Navigator.pushReplacement(
                    navState.currentState!.context,
                    MaterialPageRoute(
                      builder: (context) => const PsychologyInitialAssessment(),
                    ),
                  );
                }
              },
              child: SizedBox(
                width: 216.w,
                height: 48.h,
                child: mainButton("Sure, why not!"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
