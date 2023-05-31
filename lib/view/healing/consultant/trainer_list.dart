import 'package:aayu/controller/consultant/personal_trainer_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions_info.dart';
import 'package:aayu/view/healing/consultant/widgets/trainer_card.dart';
import 'package:aayu/view/nudgets/need_help.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../subscription/offers/widgets/apply_coupon.dart';
import '../../subscription/offers/widgets/coupon_applied.dart';
import 'widgets/consultant_not_available.dart';

class TrainerList extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String bookType;

  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionTrainerId;
  final String? promoCode;

  const TrainerList({
    Key? key,
    this.pageSource = "",
    required this.consultType,
    required this.bookType,
    this.isReschedule = false,
    this.prevSessionId = "",
    this.prevSessionTrainerId = "",
    this.promoCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersonalTrainerController personalTrainerController =
        Get.put(PersonalTrainerController());
    Future.delayed(Duration.zero, () async {
      if (consultType == "GOT QUERY" &&
          bookType == "PAID" &&
          isReschedule == false) {
        await personalTrainerController
            .selectSingleSessionPackage()
            .then((value) {
          personalTrainerController.getPersonalTrainerList(
              offerOn: "THERAPIST CONSULTATION", promoCode: promoCode);
        });
      } else {
        personalTrainerController.getPersonalTrainerList();
      }
    });
    return Scaffold(
        body: Column(
      children: [
        Container(
          width: double.infinity,
          height: 100.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(Images.planSummaryBGImage),
            ),
          ),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            title: Text(
              "PERSONAL_TRAINER".tr,
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
            actions: [
              InkWell(
                onTap: () {
                  Get.bottomSheet(
                    TrainerSessionsInfo(
                      bookFunction: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    isScrollControlled: true,
                    isDismissible: true,
                    enableDrag: false,
                  );
                },
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.secondaryLabelColor,
                ),
              ),
              SizedBox(
                width: 13.w,
              ),
            ],
          ),
        ),
        GetBuilder<PersonalTrainerController>(builder: (trainerController) {
          if (trainerController.isListLoading.value == true) {
            return const Offstage();
          } else if (trainerController.personalTrainerList.value == null) {
            return const Offstage();
          } else if (trainerController.personalTrainerList.value!.coachList ==
              null) {
            return const Offstage();
          } else if (trainerController
              .personalTrainerList.value!.coachList!.isEmpty) {
            return const Offstage();
          }
          if (consultType == "GOT QUERY" &&
              bookType == "PAID" &&
              isReschedule == false) {
            return Padding(
              padding: EdgeInsets.only(top: 22.h),
              child: trainerController.isPromoCodeApplied.value == false
                  ? const ApplyCoupon(
                      offerOn: "THERAPIST CONSULTATION",
                    )
                  : CouponApplied(
                      offerOn: "THERAPIST CONSULTATION",
                      appliedPromoCode: trainerController.appliedPromoCode!,
                      removeFunction: () {
                        trainerController.removeCoupon();
                      }),
            );
          }
          return const Offstage();
        }),
        Obx(() {
          if (personalTrainerController.isListLoading.value == true) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [showLoading()],
              ),
            );
          } else if (personalTrainerController.personalTrainerList.value ==
              null) {
            return const ConsultantNotAvailable(consultationType: "THERAPIST");
          } else if (personalTrainerController
                  .personalTrainerList.value!.coachList ==
              null) {
            return const ConsultantNotAvailable(consultationType: "THERAPIST");
          } else if (personalTrainerController
              .personalTrainerList.value!.coachList!.isEmpty) {
            return const ConsultantNotAvailable(consultationType: "THERAPIST");
          }
          return Expanded(
            child: ListView.separated(
              padding: pageHorizontalPadding(),
              shrinkWrap: true,
              itemCount: personalTrainerController
                  .personalTrainerList.value!.coachList!.length,
              separatorBuilder: (context, index) {
                if (index == 3) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 24.h),
                    child: const NeedHelp(),
                  );
                }
                /* if (index == 6) {
                  return const CoachSessionReviews(
                    coachType: "TRAINER",
                  );
                } */
                return const Offstage();
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: (index ==
                          personalTrainerController.personalTrainerList.value!
                                  .coachList!.length -
                              1)
                      ? EdgeInsets.only(bottom: 56.h)
                      : index == 0
                          ? EdgeInsets.symmetric(vertical: 24.h)
                          : EdgeInsets.only(bottom: 24.h),
                  child: TrainerCard(
                    pageSource: pageSource,
                    consultType: consultType,
                    bookType: bookType,
                    isReschedule: isReschedule,
                    prevSessionId: prevSessionId,
                    prevSessionTrainerId: prevSessionTrainerId,
                    trainerDetails: personalTrainerController
                        .personalTrainerList.value!.coachList![index]!,
                    showSessionPrice: (consultType == "GOT QUERY" &&
                            bookType == "PAID" &&
                            isReschedule == false)
                        ? true
                        : false,
                    currency: personalTrainerController
                                .selectedSingleTrainerSession!.currency !=
                            null
                        ? personalTrainerController
                            .selectedSingleTrainerSession!.currency!.display!
                        : "",
                    singleSessionPrice:
                        personalTrainerController.singleSessionPrice.value,
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
