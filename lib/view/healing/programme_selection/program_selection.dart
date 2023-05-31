import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/view/healing/programme_selection/program_start_date.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'choose_duration.dart';

class ProgramSelection extends StatefulWidget {
  final bool isProgramSwitch;
  final bool isRecommendedProgramSwitch;

  const ProgramSelection(
      {Key? key,
      this.isProgramSwitch = false,
      required this.isRecommendedProgramSwitch})
      : super(key: key);

  @override
  State<ProgramSelection> createState() => _ProgramSelectionState();
}

class _ProgramSelectionState extends State<ProgramSelection> {
  PageController pageController = PageController();

  @override
  initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostAssessmentController postAssessmentController = Get.find();
    DiseaseDetailsController diseaseDetailsController = Get.find();
    return Obx(() {
      if (postAssessmentController.isLoading.value == true) {
        return showLoading();
      } else if (postAssessmentController
              .programDurationDetails.value!.duration ==
          null) {
        return showLoading();
      } else if (postAssessmentController
          .programDurationDetails.value!.duration!.isEmpty) {
        return showLoading();
      }

      return WillPopScope(
        onWillPop: () async {
          if (postAssessmentController.selectedPage.value == 0) {
            Navigator.of(context).pop();
          } else {
            pageController.previousPage(
                duration: Duration(milliseconds: defaultAnimateToPageDuration),
                curve: Curves.easeOut);
          }
          return false;
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: PageView.builder(
            controller: pageController,
            itemCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Future.delayed(const Duration(seconds: 0), () {
                postAssessmentController.setSelectedPage(index);
              });
              switch (index) {
                case 0:
                  //Dont remove column; else height needs to be provided
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ChooseDuration(
                        isProgramSwitch: widget.isProgramSwitch,
                        programName: diseaseDetailsController.diseaseDetails
                                .value!.details!.silverAppBar!.title ??
                            "",
                        pageController: pageController,
                      )
                    ],
                  );
                case 1:
                  //Dont remove column; else height needs to be provided
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProgramStartDate(
                        isRecommendedProgramSwitch:
                            widget.isRecommendedProgramSwitch,
                        isProgramSwitch: widget.isProgramSwitch,
                        programName: diseaseDetailsController.diseaseDetails
                                .value!.details!.silverAppBar!.title ??
                            "",
                        pageController: pageController,
                      )
                    ],
                  );
                default:
                  return const Offstage();
              }
            },
          ),
        ),
      );
    });
  }
}
