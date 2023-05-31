import 'package:aayu/services/coach.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/consultant/doctor_session_controller.dart';
import '../../../controller/deeplink/singular_deeplink_controller.dart';
import '../../../controller/healing/healing_list_controller.dart';
import '../../../controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import '../../../model/model.dart';
import '../../../services/services.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../healing/consultant/doctor_list.dart';
import '../../onboarding/onboarding_bottom_sheet.dart';
import '../../shared/constants.dart';
import '../../shared/network_image.dart';
import '../../shared/ui_helper/images.dart';
import '../../shared/ui_helper/ui_helper.dart';

class SelectDisease extends StatelessWidget {
  final Map<String, dynamic>? deepLinkData;
  const SelectDisease({Key? key, this.deepLinkData}) : super(key: key);
  setDeepLinkContinuedFreeDoctor(String diseaseId) {
    Map<String, dynamic> data = {
      "screenName": "BOOK_DOCTOR_CONSULT",
      "diseaseId": diseaseId,
      "bookType": "FREE",
      "consultType": "ADD-ON",
    };

    SingularDeepLinkController singularDeepLinkController = Get.find();
    Get.put(OnboardingBottomSheetController(true));
    singularDeepLinkController.nullDeepLinkData();
    singularDeepLinkController.setDeepLinkDataContinued(data);
    Get.to(const OnboardingBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: true,
            floating: true,
            titleSpacing: 0,
            elevation: 0,
            centerTitle: true,
            leading: null,
            flexibleSpace: Stack(
              children: [
                Image(
                  image: const AssetImage(Images.planSummaryBGImage),
                  fit: BoxFit.cover,
                  height: 151.h,
                ),
                Positioned(
                  top: 26.h,
                  left: 10.w,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.blackLabelColor,
                    ),
                  ),
                )
              ],
            ),
            expandedHeight: 256.h,
            backgroundColor: AppColors.whiteColor,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: Size(256.w, 256.h),
              child: Image(
                width: 256.w,
                height: 256.h,
                fit: BoxFit.contain,
                image: const AssetImage(Images.selectDiseaseDoctor),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Select the Disease",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Baskerville"),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  "Your doctor consultation session will help \nyou get disease-specific guidance.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                GetBuilder<HealingListController>(
                    builder: (healingListController) {
                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 20,
                    // maxCrossAxisExtent: 200.0,
                    crossAxisCount: 2,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: List.generate(
                      healingListController.activeHealingList!.length,
                      (index) {
                        return InkWell(
                          onTap: () {
                            healingListController.toggleSelection(
                                index, context);
                          },
                          child: buildHealingList(
                            healingListController.activeHealingList![index]!,
                            () {
                              healingListController.toggleSelection(
                                  index, context);
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<HealingListController>(
        builder: (controller) => Visibility(
          // visible: controller.noOfDiseaseSelected.value > 0,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 26.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                    offset: Offset(-5, 10),
                    blurRadius: 20)
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                if (controller.noOfDiseaseSelected.value > 0) {
                  controller.getSelectedDiseaseList();
                  if (controller.diseaseDetailsRequest.disease!.isEmpty) {
                    return;
                  }
                  try {
                    if (appProperties.consultation!.doctor!.enabled == false) {
                      EventsService().sendEvent("Doctor_Session_Free_Notify", {
                        "date_time": DateTime.now().toString(),
                      });
                      showCustomSnackBar(
                        context,
                        "Thank you for showing interest.\nFeature is coming soon.",
                      );
                    } else if (appProperties
                            .consultation!.doctor!.underMaintainance ==
                        true) {
                      showCustomSnackBar(
                        context,
                        "UNDER_SCHEDULED_MAINTENANCE_MSG".tr,
                      );
                    } else {
                      bool isAlreadyBooked = await CoachService().checkIsBooked(
                          globalUserIdDetails!.userId!, "Doctor");

                      if (isAlreadyBooked == false) {
                        HealingListController healingListController =
                            Get.find();
                        EventsService().sendClickNextEvent(
                            "DoctorConsultationInfo",
                            "Select Your Doctor",
                            "BookDoctorSession");

                        DoctorSessionController doctorSessionController =
                            Get.find();
                        bool isSessionAvailable = false;
                        if (doctorSessionController
                                    .upcomingSessionsList.value !=
                                null &&
                            doctorSessionController.upcomingSessionsList.value!
                                    .upcomingSessions !=
                                null) {
                          CoachUpcomingSessionsModelUpcomingSessions?
                              sessionDetails = doctorSessionController
                                  .upcomingSessionsList.value!.upcomingSessions!
                                  .firstWhereOrNull((element) =>
                                      element!.status == "PENDING");

                          if (sessionDetails != null) {
                            isSessionAvailable = true;
                          }
                        }

                        if (isSessionAvailable == true) {
                          healingListController.getSelectedDiseaseList();
                          Get.to(
                            DoctorList(
                              pageSource: "PROGRAM_DETAILS",
                              consultType: "ADD-ON",
                              bookType: "PAID",
                            ),
                          )!
                              .then((value) {
                            EventsService().sendClickBackEvent(
                                "BookDoctorSession", "Back", "DoctorList");
                          });
                        } else {
                          EventsService().sendClickNextEvent(
                              "Disease Details", "Got Query", "DoctorList");
                          Get.to(
                            DoctorList(
                              pageSource: "PROGRAM_DETAILS",
                              consultType: "GOT QUERY",
                              bookType: "PAID",
                            ),
                          )!
                              .then((value) {
                            EventsService().sendClickBackEvent(
                                "BookDoctorSession", "Back", "DoctorList");
                          });
                        }
                      } else {
                        showCustomSnackBar(
                            context, "COMPLETE_DOCTOR_CALL_BOOKED".tr);
                      }
                    }
                  } catch (e) {}
                }
              },
              style: controller.noOfDiseaseSelected.value > 0
                  ? AppTheme.mainButtonStyle
                  : AppTheme.disableMainButtonStyle,
              child: Text(
                "NEXT".tr,
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildHealingList(HealingListResponseDiseases disease, Function? onChanged) {
    return SizedBox(
      width: 140.w,
      height: 157.h,
      child: SizedBox(
        width: 140.w,
        height: 129.09.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140.w,
                  height: 110.13.h,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(top: 20.h),
                  decoration: disease.isSelected == true
                      ? const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(89, 115, 147, 0.5),
                              offset: Offset(0, 12),
                              blurRadius: 28,
                              spreadRadius: 0,
                            )
                          ],
                          color: AppColors.whiteColor,
                        )
                      : const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          color: AppColors.lightSecondaryColor,
                        ),
                ),
                SizedBox(
                  height: 14.w,
                ),
                SizedBox(
                  width: 140.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      onChanged == null
                          ? const Offstage()
                          : Container(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: disease.isSelected == true
                                    ? AppColors.primaryColor
                                    : AppColors.lightSecondaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Checkbox(
                                onChanged: onChanged == null
                                    ? null
                                    : (value) => onChanged(),
                                side: BorderSide.none,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                activeColor: Colors.transparent,
                                checkColor: AppColors.whiteColor,
                                value:
                                    disease.isSelected == true ? true : false,
                              ),
                            ),
                      onChanged == null
                          ? const Offstage()
                          : SizedBox(
                              width: 8.w,
                            ),
                      Expanded(
                        child: Text(
                          disease.disease!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: onChanged == null
                              ? TextAlign.center
                              : TextAlign.left,
                          style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                            height: 1.h,
                            fontFamily: "Circular Std",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            (disease.image == null)
                ? const Offstage()
                : Align(
                    alignment: Alignment.topCenter,
                    child: ShowNetworkImage(
                      imgPath: disease.image!.imageUrl!,
                      imgWidth: disease.image!.width!,
                      imgHeight: disease.image!.height!,
                      boxFit: BoxFit.contain,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
