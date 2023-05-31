import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DoctorsRecommendationCard extends StatelessWidget {
  const DoctorsRecommendationCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProgramRecommendationController programRecommendationController =
        Get.find();
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    Future.delayed(Duration.zero, () {
      subscriptionController.getSubscriptionDetails();
    });

    return Obx(() {
      if (programRecommendationController.isLoading.value == true) {
        return const Offstage();
      }
      if (programRecommendationController.recommendation.value == null) {
        return const Offstage();
      }
      if (programRecommendationController
              .recommendation.value!.recommendation ==
          null) {
        return const Offstage();
      }
      if (programRecommendationController
              .recommendation.value!.recommendation!.programType ==
          "SINGLE DISEASE") {
        return SingleDiseaseRecommendation(
          programRecommendationController: programRecommendationController,
          subscriptionController: subscriptionController,
        );
      } else {
        return MultipleDiseaseRecommendation(
            programRecommendationController: programRecommendationController,
            subscriptionController: subscriptionController);
      }
    });
  }
}

class SingleDiseaseRecommendation extends StatelessWidget {
  final ProgramRecommendationController programRecommendationController;
  final SubscriptionController subscriptionController;

  const SingleDiseaseRecommendation(
      {Key? key,
      required this.programRecommendationController,
      required this.subscriptionController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealingListController healingListController = Get.find();
    return Column(
      children: [
        SizedBox(
          height: 55.h,
        ),
        Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 23.h),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFF7F9FD), Color(0xFFEAF1FE)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.07),
                          blurRadius: 28.51,
                          offset: Offset(0, 1.68))
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 37.h,
                    ),
                    Text(
                      'After your in-depth consultation\nsession, ${programRecommendationController.recommendation.value!.recommendation!.doctorDetails!.doctorName ?? ""} recommends this program for you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.blueGreyAssessmentColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ShowNetworkImage(
                                imgPath: programRecommendationController
                                        .recommendation
                                        .value!
                                        .recommendation!
                                        .silverAppBar!
                                        .backgroundImage ??
                                    "",
                                imgHeight: 200.h,
                                boxFit: BoxFit.cover,
                                imgWidth: double.infinity,
                              ),
                            ),
                            Positioned(
                              bottom: -32.h,
                              child: CircleAvatar(
                                backgroundColor: const Color(0xFFF2F7FF),
                                radius: 32.h,
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ShowNetworkImage(
                                      imgPath: healingListController
                                          .getImageFromDiseaseId(
                                              programRecommendationController
                                                      .recommendation
                                                      .value!
                                                      .recommendation!
                                                      .disease![0]!
                                                      .diseaseId ??
                                                  ""),
                                      boxFit: BoxFit.contain,
                                    )),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      '${programRecommendationController.recommendation.value!.recommendation!.disease![0]!.diseaseName ?? ""} Care Program',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.blueGreyAssessmentColor,
                          fontFamily: 'Baskerville',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Image.asset(
                            Images.greenRibbonPersonalisedCareImage,
                            height: 25.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text(
                          'Get one month’s subscription free',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.blueGreyAssessmentColor,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    InkWell(
                      onTap: () {
                        programRecommendationController
                            .handleProgramRecommendation(
                                subscriptionController);
                      },
                      child: mainButton("Let’s get started"),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -39.h,
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFF7F9FD),
                  radius: 45.h,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: circularConsultImage(
                        "DOCTOR",
                        programRecommendationController.recommendation.value!
                            .recommendation!.doctorDetails!.photo,
                        83.h,
                        83.h),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                    onPressed: () {
                      showCloseConfirmation(
                          context,
                          programRecommendationController,
                          subscriptionController,
                          false);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.blackLabelColor,
                    )),
              ),
            ]),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }
}

class MultipleDiseaseRecommendation extends StatelessWidget {
  final ProgramRecommendationController programRecommendationController;
  final SubscriptionController subscriptionController;
  const MultipleDiseaseRecommendation(
      {Key? key,
      required this.programRecommendationController,
      required this.subscriptionController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealingListController healingListController = Get.find();
    return Column(
      children: [
        SizedBox(
          height: 55.h,
        ),
        Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 23.h),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFF7F9FD), Color(0xFFEAF1FE)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.07),
                          blurRadius: 28.51,
                          offset: Offset(0, 1.68))
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 37.h,
                    ),
                    Text(
                      'After your in-depth consultation\nsession, ${programRecommendationController.recommendation.value!.recommendation!.doctorDetails!.doctorName ?? ""} recommends this program for you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.blueGreyAssessmentColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 23.h,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Personalised Care Program',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.blueGreyAssessmentColor,
                              fontFamily: 'Baskerville',
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        Text(
                          'Chronic health conditions included:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.blueGreyAssessmentColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Divider(
                          color: Color(0xFFE9E9E9),
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        SizedBox(
                          height: 130.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: programRecommendationController
                                .recommendation
                                .value!
                                .recommendation!
                                .disease!
                                .length,
                            itemBuilder: (context, index) => Container(
                              width: 70.h,
                              margin: EdgeInsets.symmetric(horizontal: 10.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShowNetworkImage(
                                      imgHeight: 50.h,
                                      boxFit: BoxFit.fitHeight,
                                      imgPath: healingListController
                                          .getImageFromDiseaseId(
                                              programRecommendationController
                                                      .recommendation
                                                      .value!
                                                      .recommendation!
                                                      .disease![index]!
                                                      .diseaseId ??
                                                  "")),
                                  SizedBox(
                                    height: 13.h,
                                  ),
                                  Text(
                                    programRecommendationController
                                            .recommendation
                                            .value!
                                            .recommendation!
                                            .disease![index]!
                                            .diseaseName ??
                                        "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                            AppColors.blueGreyAssessmentColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InkWell(
                      onTap: () {
                        programRecommendationController
                            .handleProgramRecommendation(
                                subscriptionController);
                      },
                      child: mainButton("Let's get started"),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -39.h,
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFF7F9FD),
                  radius: 45.h,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: circularConsultImage(
                        "DOCTOR",
                        programRecommendationController.recommendation.value!
                            .recommendation!.doctorDetails!.photo,
                        83.h,
                        83.h),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                    onPressed: () {
                      showCloseConfirmation(
                          context,
                          programRecommendationController,
                          subscriptionController,
                          true);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.blackLabelColor,
                    )),
              ),
            ]),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }
}

showCloseConfirmation(
    BuildContext context,
    ProgramRecommendationController programRecommendationController,
    SubscriptionController subscriptionController,
    bool isMultipleDisease) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Container(
        padding:
            EdgeInsets.only(top: 32.h, bottom: 24.h, left: 24.w, right: 24.w),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure?',
              style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Circular Std"),
            ),
            SizedBox(
              height: 18.h,
            ),
            Text(
              isMultipleDisease
                  ? "Don’t wish to go ahead with the doctor’s recommendation?\n\nTo start a Personalised Care Program again you’ll have to schedule another doctor consultation."
                  : "Don’t wish to go ahead with the doctor’s recommendation? It is ideal for your unique health conditions. ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Circular Std"),
            ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                programRecommendationController
                    .handleProgramRecommendation(subscriptionController);
              },
              child: mainButton("Choose the recommended program"),
            ),
            SizedBox(
              height: 10.h,
            ),
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  buildShowDialog(context);
                  await programRecommendationController
                      .deleteDoctorsRecommendation();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Choose your own program',
                  style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      decoration: TextDecoration.underline),
                ))
          ],
        ),
      ),
    ),
  );
}
