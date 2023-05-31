import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/healing/consultant/sessions/buy_sessions/buy_doctor_sessions.dart';
import 'package:aayu/view/healing/consultant/sessions/buy_sessions/confirm_doctor_sessions.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetDoctorSessions extends StatefulWidget {
  const GetDoctorSessions({Key? key}) : super(key: key);

  @override
  State<GetDoctorSessions> createState() => _GetDoctorSessionsState();
}

class _GetDoctorSessionsState extends State<GetDoctorSessions> {
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
              .consultingPackages!.doctorPackages ==
          null) {
        return showLoading();
      } else if (postAssessmentController.consultingPackageResponse.value!
          .consultingPackages!.doctorPackages!.isEmpty) {
        return showLoading();
      }

      return WillPopScope(
        onWillPop: () async {
          if (pageIndex == 1) {
            pageController.previousPage(
                duration: Duration(milliseconds: defaultAnimateToPageDuration),
                curve: Curves.easeOut);
          } else if (pageIndex == 0) {
            EventsService().sendEvent("Doctor_Payment_Back",
                {"consult_type": "Doctor"});
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
                      BuyDoctorSessions(pageController: pageController),
                    ],
                  );
                case 1:
                  //Dont remove column; else height needs to be provided
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConfirmDoctorSessions(pageController: pageController),
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
