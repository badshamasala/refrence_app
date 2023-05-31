import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/healing/consultant/sessions/buy_sessions/buy_trainer_sessions.dart';
import 'package:aayu/view/healing/consultant/sessions/buy_sessions/confirm_trainer_sessions.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetTrainerSessions extends StatefulWidget {
  const GetTrainerSessions({Key? key}) : super(key: key);

  @override
  State<GetTrainerSessions> createState() => _GetTrainerSessionsState();
}

class _GetTrainerSessionsState extends State<GetTrainerSessions> {
  PageController pageController = PageController();
  int pageIndex = 0;
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
      } else if (postAssessmentController.consultingPackageResponse.value!
              .consultingPackages!.therapistPackages ==
          null) {
        return showLoading();
      } else if (postAssessmentController.consultingPackageResponse.value!
          .consultingPackages!.therapistPackages!.isEmpty) {
        return showLoading();
      }

      return WillPopScope(
        onWillPop: () async {
          if (pageIndex == 1) {
            pageController.previousPage(
                duration: Duration(milliseconds: defaultAnimateToPageDuration),
                curve: Curves.easeOut);
          } else if (pageIndex == 0) {
            EventsService().sendEvent("Therapist_Payment_Back",
                {"consult_type": "Therapist"});
            Navigator.of(context).pop();
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
              setHeight(index);
              switch (index) {
                case 0:
                  //Dont remove column; else height needs to be provided
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BuyTrainerSessions(pageController: pageController),
                    ],
                  );
                case 1:
                  //Dont remove column; else height needs to be provided
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConfirmTrainerSessions(pageController: pageController),
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

  setHeight(int index) {
    Future.delayed(Duration.zero, () {
      setState(() {
        pageIndex = index;
      });
    });
  }
}
