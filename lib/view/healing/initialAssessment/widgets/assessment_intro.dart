import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/healing/initialAssessment/assessment.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AssessmentIntro extends StatelessWidget {
  final String pageSource;
  final String userName;
  final String categoryName;
  const AssessmentIntro(
      {Key? key,
      required this.pageSource,
      required this.userName,
      required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              Images.assessmentBGImage,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage(
                Images.assessmentIntroImage,
              ),
              width: 69.w,
              height: 69.h,
            ),
            SizedBox(
              height: 23.h,
            ),
            Image(
              width: 30.w,
              height: 4.h,
              image: const AssetImage(Images.ellipseImage),
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 23.h,
            ),
            Text(
              userName.isEmpty
                  ? "YOU_ARE_UNIQUE".tr
                  : "$userName, you are unique.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackLabelColor,
                fontFamily: 'Baskerville',
                fontSize: 24.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.5.h,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: 293.w,
              child: Text(
                "HELP_US_UNDERSTAND_YOU_BETTER_THROUGH_THIS_ASSESSMENT".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1.5.h,
                ),
              ),
            ),
            SizedBox(
              height: 54.h,
            ),
            InkWell(
              onTap: () {
                EventsService().sendEvent("Initial_Assessment_Started",
                    {"date_time": DateTime.now().toString()});
                Navigator.pop(context);
                EventsService().sendClickNextEvent(
                    "AssessmentIntro", "Next", "Assessment");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Assessment(
                      pageSource: pageSource,
                      categoryName: categoryName,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 150.w,
                child: mainButton("NEXT".tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
