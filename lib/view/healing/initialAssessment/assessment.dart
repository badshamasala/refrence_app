import 'package:aayu/controller/healing/initial_assessment_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/initialAssessment/initial_health_card.dart';
import 'package:aayu/view/healing/initialAssessment/widgets/objective_assessment.dart';
import 'package:aayu/view/healing/initialAssessment/widgets/subjective_assessment.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Assessment extends StatelessWidget {
  final String pageSource;
  final String? categoryName;
  const Assessment({Key? key, required this.pageSource, this.categoryName = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    InitialAssessmentController controller =
        Get.put(InitialAssessmentController());
    controller.setInitialValues(pageSource, categoryName);

    return WillPopScope(
      onWillPop: () => leavingMidWay(context, pageSource),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.pageBackgroundColor,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                leavingMidWay(context, pageSource);
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.blackLabelColor,
              ),
            )
          ],
        ),
        body: GetBuilder<InitialAssessmentController>(
            builder: (revisedAssessmentController) {
          if (revisedAssessmentController.isLoading.value == true) {
            return showLoading();
          }
          if (revisedAssessmentController.revisedAssessment.value == null) {
            return const Offstage();
          } else if (revisedAssessmentController
                  .revisedAssessment.value!.categories ==
              null) {
            return const Offstage();
          } else if (revisedAssessmentController
              .revisedAssessment.value!.categories!.isEmpty) {
            return const Offstage();
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100.h,
              ),
              AssessmentCategory(
                  category: revisedAssessmentController.currentCategory.value!),
              SizedBox(
                height: 26.h,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F5F5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 26.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.w),
                        child: LinearPercentIndicator(
                          animation: true,
                          width: 100.w,
                          lineHeight: 10.0.h,
                          animationDuration: 200,
                          percent:
                              revisedAssessmentController.completedPercentage,
                          center: const Offstage(),
                          trailing: Text(
                              "${revisedAssessmentController.completedQuestions}/${revisedAssessmentController.totalQuestions}"),
                          barRadius: Radius.circular(16.w),
                          backgroundColor: AppColors.whiteColor,
                          progressColor: const Color(0xFFA5ECD1),
                        ),
                      ),
                      SizedBox(
                        height: 26.h,
                      ),
                      Expanded(
                        child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: revisedAssessmentController
                                .categoryPageController,
                            itemCount: revisedAssessmentController
                                .revisedAssessment.value!.categories!.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, categoryIndex) {
                              return PageView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                controller:
                                    revisedAssessmentController.pageController,
                                itemCount: revisedAssessmentController
                                    .currentCategory.value!.question!.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, questionIndex) {
                                  revisedAssessmentController
                                      .selectedQuestionIndex
                                      .value = questionIndex;

                                  String questionType =
                                      revisedAssessmentController
                                          .currentCategory
                                          .value!
                                          .question![revisedAssessmentController
                                              .selectedQuestionIndex.value]!
                                          .questionType!
                                          .toUpperCase();

                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RevisedAssessmentQuestion(
                                            index: questionIndex,
                                            question: revisedAssessmentController
                                                .currentCategory
                                                .value!
                                                .question![
                                                    revisedAssessmentController
                                                        .selectedQuestionIndex
                                                        .value]!
                                                .question!),
                                        (questionType == "OBJECTIVE ASSESSMENT")
                                            ? ObjectiveAssessment(
                                                objectiveAssessmentController:
                                                    revisedAssessmentController)
                                            : const Offstage(),
                                        (questionType ==
                                                "SUBJECTIVE ASSESSMENT")
                                            ? SubjectiveAssessment(
                                                subjectiveAssessmentController:
                                                    revisedAssessmentController)
                                            : const Offstage(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: pagePadding(),
                color: const Color(0xFFF8F5F5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Visibility(
                          visible: (revisedAssessmentController
                              .questionHistory.isNotEmpty),
                          child: InkWell(
                            onTap: () {
                              revisedAssessmentController
                                  .showPreviousQuestion();
                            },
                            child: Container(
                              height: 54.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.07000000029802322),
                                      offset: Offset(-5, 10),
                                      blurRadius: 20),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "PREVIOUS".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    height: 1.h,
                                    fontFamily: "Circular Std",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            revisedAssessmentController.showNextQuestion();
                          },
                          child: SizedBox(
                            width: 150.w,
                            child: mainButton("Next"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Future<bool> leavingMidWay(context, pageSource) async {
    return showDialog(
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
                'LEAVING_MIDWAY'.tr,
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Circular Std"),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                'FINISH_YOUR_ASSESSMENT'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Circular Std",
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color.fromRGBO(86, 103, 137, 0.26),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 9.h,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        Navigator.of(context).pop(false);
                        EventsService().sendEvent(
                            "Initial_Assessment_Cancelled",
                            {"date_time": DateTime.now().toString()});
                        EventsService().sendClickNextEvent(
                            "Assessment", "Do it later", "InitialHealthCard");
                        if (pageSource == "BOOK_DOCTOR_SLOT") {
                          //BACK TO DOCTOR APPOINTMENT PAGE
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InitialHealthCard(
                                action: "Do It Later",
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'DO_IT_LATER'.tr,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Circular Std",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 9.h,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'CONTINUE'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ).then((exit) {
      if (exit == true) {
        return Future<bool>.value(true);
      }
      return Future<bool>.value(exit);
    });
  }
}

class AssessmentCategory extends StatelessWidget {
  final InitialAssessmentAssessment? category;
  const AssessmentCategory({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pageHorizontalPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ASSESSING_FOR".tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.normal,
                      height: 1.16.h),
                ),
                SizedBox(
                  height: 16.h,
                ),
                InkWell(
                  onTap: () {
                    showCategories(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        toTitleCase(category!.categoryName!),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: "Baskerville",
                          fontSize: 24.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0XFF9C9EB9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Visibility(
            visible: false,
            child: Container(
              width: 62.w,
              height: 62.h,
              decoration: const BoxDecoration(
                color: Color(0xFFA5ECD1),
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "SCORE".tr,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 10.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.end,
                    runAlignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "10".tr,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontSize: 26.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Text(
                        "%".tr,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showCategories(context) {
    Get.bottomSheet(
      Container(
        width: MediaQuery.of(context).size.width,
        padding: pagePadding(),
        decoration: BoxDecoration(
          color: AppColors.pageBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.w),
            topRight: Radius.circular(30.w),
          ),
        ),
        child: GetBuilder<InitialAssessmentController>(
            builder: (categoryController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                      width: 110.w,
                      height: 95.h,
                      fit: BoxFit.contain,
                      image: const AssetImage(Images.aayuHealingImage),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: categoryController
                      .revisedAssessment.value!.categories!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        categoryController.setCategory(index);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                toTitleCase(categoryController.revisedAssessment
                                    .value!.categories![index]!.categoryName!),
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.h,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Visibility(
                              visible: categoryController.revisedAssessment
                                  .value!.categories![index]!.isCompleted!,
                              child: SvgPicture.asset(
                                AppIcons.completedSVG,
                                color: AppColors.primaryColor,
                                width: 20.h,
                                height: 20.h,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              )
            ],
          );
        }),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
    );
  }
}

class RevisedAssessmentQuestion extends StatelessWidget {
  final int index;
  final String? question;
  const RevisedAssessmentQuestion(
      {Key? key, required this.index, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* Container(
            width: 56.w,
            height: 56.h,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.029999999329447746),
                  offset: Offset(5, 4),
                  blurRadius: 8,
                )
              ],
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  color: const Color(0XFFA5ECD1),
                  fontFamily: 'Circular Std',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 26.w,
          ), */
          Expanded(
            child: Text(
              question!.trim(),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.aayuUserChatTextColor,
                fontFamily: 'Circular Std',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                height: 1.4285714285714286.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
