import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/widgets/consultant_not_available.dart';
import 'package:aayu/view/nudgets/need_help.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/consultant/psychologist/pyschology_list_controller.dart';
import 'widget/psychologist_card.dart';

class PsychologistList extends StatelessWidget {
  final String pageSource;
  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionCoachId;

  const PsychologistList({
    Key? key,
    this.pageSource = "",
    this.isReschedule = false,
    this.prevSessionId = "",
    this.prevSessionCoachId = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PsychologyListController psychologyListController =
        Get.put(PsychologyListController());
    Future.delayed(Duration.zero, () async {
      psychologyListController.getPsychologyList();
    });
    return Scaffold(
        body: Column(
      children: [
        Container(
          width: double.infinity,
          height: 95.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(
                Images.planSummaryBGImage,
              ),
            ),
          ),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            title: Text(
              "Select Counsellor",
              style: appBarTextStyle(),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 20.w,
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
        ),
        Obx(() {
          if (psychologyListController.isLoading.value == true) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [showLoading()],
              ),
            );
          } else if (psychologyListController.psychologyListResponse.value ==
              null) {
            return const ConsultantNotAvailable(
                consultationType: "PSYCHOLOGIST");
          } else if (psychologyListController
                  .psychologyListResponse.value!.coachList ==
              null) {
            return const ConsultantNotAvailable(
                consultationType: "PSYCHOLOGIST");
          } else if (psychologyListController
              .psychologyListResponse.value!.coachList!.isEmpty) {
            return const ConsultantNotAvailable(
                consultationType: "PSYCHOLOGIST");
          }
          return Expanded(
            child: ListView.separated(
              padding: pageHorizontalPadding(),
              shrinkWrap: true,
              itemCount: psychologyListController
                  .psychologyListResponse.value!.coachList!.length,
              separatorBuilder: (context, index) {
                if (index == 3) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 24.h),
                    child: const NeedHelp(),
                  );
                }
                return const Offstage();
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: index == 0
                      ? EdgeInsets.symmetric(vertical: 24.h)
                      : (index ==
                              psychologyListController.psychologyListResponse
                                      .value!.coachList!.length -
                                  1)
                          ? EdgeInsets.only(bottom: 56.h)
                          : EdgeInsets.only(bottom: 24.h),
                  child: PsychologistCard(
                    pageSource: pageSource,
                    coachDetails: psychologyListController
                        .psychologyListResponse.value!.coachList![index]!,
                    isReschedule: isReschedule,
                    prevSessionId: prevSessionId,
                    prevSessionCoachId: prevSessionCoachId,
                  ),
                );
              },
            ),
          );
        }),
      ],
    ));
  }
}
