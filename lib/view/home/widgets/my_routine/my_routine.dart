import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyRoutine extends StatelessWidget {
  final HomePageContentResponseDetailsDailyRoutine? dailyRoutineData;
  const MyRoutine({Key? key, required this.dailyRoutineData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyRoutineController>(builder: (controller) {
      if (controller.isLoading.value == true) {
        return const Offstage();
      } else if (controller.listOfWidgets.isEmpty) {
        return const Offstage();
      }
      return Container(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        color: AppColors.whiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: pageHorizontalPadding(),
              child: Text(
                "Quick Access",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color(0xFF344553),
                  fontFamily: 'Circular Std',
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
            SizedBox(
              height: 26.h,
            ),
            GridView.count(
              shrinkWrap: true,

              padding: const EdgeInsets.only(top: 25, bottom: 16, left: 20),
              crossAxisSpacing: 9,
              mainAxisSpacing: 30,
              // maxCrossAxisExtent: 200.0,
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),

              children: controller.listOfWidgets,
              // children: const <Widget>[
              //   FreeDoctorRoutineWidget(),
              //   // AayuRoutineScoreWidget(),
              //   DailyRoutineWidget(
              //     title: "Explore \nHealing Programs",
              //     subtitle: "To help you \nunderstand your \nhealth better. ",
              //     topImage: Images.personalizeRoutineIcon,
              //     iconData: Icons.arrow_forward,
              //     bgColor: AppColors.shareAayuBackgroundColor,
              //     iconBgColor: AppColors.primaryColor,
              //   ),
              //   ShareAayuWidget(),
              //   BreathingRoutineWidget(),
              //   DailyRoutineWidget(
              //     title: "Your \nAssessment",
              //     subtitle: "Get insights \nto improve \nyour health.",
              //     topImage: Images.assesmentRoutineIcon,
              //     iconData: Icons.arrow_forward,
              //     bgColor: AppColors.aayuScoreBackgroundColor,
              //     iconBgColor: AppColors.primaryColor,
              //   ),
              //   DailyRoutineWidget(
              //     title: "Customise \nyour Journey",
              //     subtitle:
              //         "Answer health \nquestions to get \npersonalised \ncontent.",
              //     topImage: Images.customizeRoutineIcon,
              //     iconData: Icons.arrow_forward,
              //     bgColor: AppColors.shareAayuBackgroundColor,
              //     iconBgColor: AppColors.primaryColor,
              //   ),
              // ],
            )

            /* StaggeredGridView.countBuilder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              itemCount: 2,
              itemBuilder: (context, index) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 28.0, right: 18.0),
                      height: 176.h,
                      width: 152.w,
                      decoration: const BoxDecoration(
                          color: AppColors.myRoutineBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 42.0, left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Free Doctor\nConsultation",
                              style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Circular Std"),
                            ),
                            const SizedBox(
                              height: 7.0,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                style: TextStyle(
                                    color: AppColors.secondaryLabelColor,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700),
                                children: const [
                                  TextSpan(
                                    text: 'Got questions?',
                                  ),
                                  TextSpan(
                                    text: '\nGet expert help \nfor free.',
                                    style: TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: CircleAvatar(
                                  radius: 14.h,
                                  backgroundColor: AppColors.primaryColor,
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 17.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 104,
                      bottom: 147.0,
                      child: Image.asset(
                        Images.doctorImage,
                        height: 48.75.h,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                );
              },
              staggeredTileBuilder: (index) {
                return const StaggeredTile.fit(
                  1,
                );
              },
            ), */

            /* SizedBox(
              height: 154.h,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: dailyRoutineData!.content!.length + 6,
                itemBuilder: (BuildContext context, index) {
                  if (index == dailyRoutineData!.content!.length) {
                    return const JoinCallWidget();
                  }
                  if (index == dailyRoutineData!.content!.length + 1) {
                    return const FreeCallWidget();
                  }
                  if (index == dailyRoutineData!.content!.length + 2) {
                    return const AayuScoreWidget();
                  }
                  if (index == dailyRoutineData!.content!.length + 3) {
                    return const AssesmentWidget();
                  }
                  if (index == dailyRoutineData!.content!.length + 4) {
                    return const AssesmentInsightsWidget();
                  }
                  if (index == dailyRoutineData!.content!.length + 5) {
                    return const DailyQuestionWidget();
                  }
                  
                  String accessType = dailyRoutineData!
                      .content![index]!.accessType!
                      .toUpperCase();
    
                  if (Platform.isIOS) {
                    if (accessType != "BREATHE") {
                      return const Offstage();
                    }
                  }
    
                  return InkWell(
                    onTap: () {
                      EventsService().sendEvent("Daily_Routine_Clicked", {
                        "daily_routine": dailyRoutineData!.content![index]!.title
                      });
    
                      if (accessType == "BREATHE") {
                        EventsService().sendClickNextEvent(
                            "Home", "DailyRoutine", "Breathing");
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => const BreathingExercise(),
                          ),
                        )
                            .then((value) {
                          EventsService()
                              .sendClickBackEvent("Breathing", "Back", "Home");
                        });
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        showGreenSnackBar(
                          context,
                          "FEATURE_COMING_SOON".tr,
                        );
                      }
                    },
                    child: Container(
                      width: 274.w,
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(
                          right: 20.w, left: (index == 0) ? 26.w : 0),
                      child: ShowNetworkImage(
                        imgPath: dailyRoutineData!.content![index]!.image!,
                        imgHeight: 154.h,
                        boxFit: BoxFit.fitHeight,
                      ),
                    ),
                  );
                },
              ),
            ) */
          ],
        ),
      );
    });
  }
}
