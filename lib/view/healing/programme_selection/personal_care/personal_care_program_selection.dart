import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/view/healing/programme_selection/personal_care/personal_care_program_start_date.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'commit_your_duration.dart';

class PersonalCareProgramSelection extends StatefulWidget {
  final bool startProgram;
  const PersonalCareProgramSelection({
    Key? key, required this.startProgram
  }) : super(key: key);

  @override
  State<PersonalCareProgramSelection> createState() =>
      _PersonalCareProgramSelectionState();
}

class _PersonalCareProgramSelectionState
    extends State<PersonalCareProgramSelection> {
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
                      CommitYourDuration(
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
                      PersonalCareProgramStartDate(
                        pageController: pageController,
                        startProgram: widget.startProgram
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
