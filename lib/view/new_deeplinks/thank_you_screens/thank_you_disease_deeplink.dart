// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/new_deeplinks/widgets/thank_you_disease_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/healing/healing_list_controller.dart';
import '../../../controller/you/you_controller.dart';
import '../../../services/third-party/events.service.dart';
import '../../healing/disease_details/disease_details.dart';
import '../../shared/constants.dart';
import '../../shared/network_image.dart';
import '../../shared/ui_helper/ui_helper.dart';

class ThankYouDiseaseDeepLink extends StatelessWidget {
  String diseaseName;
  ThankYouDiseaseDeepLink({Key? key, this.diseaseName = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    YouController youController = Get.put(YouController());
    HealingListController healingListController = Get.find();

    if (healingListController.selectedDiseaseNames.length > 1) {
      diseaseName = "Personalised Care";
    } else {
      diseaseName = healingListController.selectedDiseaseNames[0];
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
          iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
        ),
        backgroundColor: AppColors.lightPrimaryColor,
        body: Obx(() {
          if (youController.isLoading.value) {
            return showLoading();
          } else if (youController.userDetails.value == null) {
            return showLoading();
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16.h,
                    ),
                    (youController.userDetails.value != null &&
                            youController.userDetails.value!.userDetails !=
                                null)
                        ? Text(
                            'Thank you ${youController.userDetails.value!.userDetails!.firstName ?? ""} ${youController.userDetails.value!.userDetails!.lastName ?? ""}',
                            style: TextStyle(
                                color: AppColors.blueGreyAssessmentColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400),
                          )
                        : Text(
                            'Thank you',
                            style: TextStyle(
                                color: AppColors.blueGreyAssessmentColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'for taking the time out to register. ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 83.h,
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 282.h,
                          width: 322.w,
                          decoration: const BoxDecoration(
                              color: AppColors.containerBgColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 80.0, left: 25.0, right: 25.0),
                                child: Text(
                                  '$diseaseName Care',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.blackLabelColor,
                                    fontFamily: 'Baskerville',
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Your healing journey awaits!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.blueGreyAssessmentColor,
                                    fontSize: 16.sp,
                                    fontFamily: 'Circular Std',
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 24.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 29.0, right: 29.0),
                                child: InkWell(
                                  onTap: () async {
                                    buildShowDialog(context);
                                    DiseaseDetailsController
                                        diseaseDetailsController =
                                        Get.put(DiseaseDetailsController());
                                    await diseaseDetailsController
                                        .getDiseaseDetails();

                                    diseaseDetailsController
                                        .setSelectedHealthProblem();

                                    Navigator.pop(context);

                                    if (subscriptionCheckResponse != null &&
                                        subscriptionCheckResponse!
                                                .subscriptionDetails !=
                                            null &&
                                        subscriptionCheckResponse!
                                            .subscriptionDetails!
                                            .programId!
                                            .isNotEmpty) {
                                      //diseaseDetailAlreadySubscribed!();
                                      Get.to(
                                        const DiseaseDetails(
                                          fromThankYou: false,
                                          pageSource: "EXPLORE_PROGRAM",
                                        ),
                                      );
                                    } else {
                                      Get.to(const DiseaseDetails(
                                        fromThankYou: true,
                                      ))!
                                          .then((value) {
                                        EventsService().sendClickBackEvent(
                                            "Disease Details",
                                            "Back",
                                            "Healing List");
                                      });
                                    }
                                  },
                                  child: mainButton("Continue"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -50,
                          child: SizedBox(
                            height: 117.h,
                            width: 117.w,
                            child: CircleAvatar(
                              backgroundColor: AppColors.whiteColor,
                              child: ShowNetworkImage(
                                imgPath: healingListController
                                            .selectedDiseaseNames.length ==
                                        1
                                    ? healingListController
                                        .getImageFromDiseaseName(
                                            healingListController
                                                .selectedDiseaseNames[0])
                                    : "",
                                imgHeight: 80.h,
                                boxFit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 45,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              const Spacer(),
              Text(
                'OUR_OTHER_PROGRAMS'.tr,
                style: TextStyle(
                    color: AppColors.blueGreyAssessmentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 152.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: healingListController.activeHealingList!.length,
                  itemBuilder: (context, index) => ThankYourDiseaseCard(
                      healingListController: healingListController,
                      disease:
                          healingListController.activeHealingList![index]!),
                ),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          );
        }));
  }
}
