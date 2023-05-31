import 'package:aayu/controller/consultant/doctor_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/widgets/doctor_card.dart';
import 'package:aayu/view/nudgets/need_help.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/offers/widgets/apply_coupon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../new_deeplinks/book_freee_doctor.dart';
import '../../subscription/offers/widgets/coupon_applied.dart';
import 'widgets/consultant_not_available.dart';

class DoctorList extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String bookType;
  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionDoctorId;
  final String? promoCode;

  const DoctorList({
    Key? key,
    this.pageSource = "",
    required this.consultType,
    required this.bookType,
    this.isReschedule = false,
    this.prevSessionId = "",
    this.prevSessionDoctorId = "",
    this.promoCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DoctorController doctorListController = Get.put(DoctorController());
    Future.delayed(Duration.zero, () async {
      if (consultType == "GOT QUERY" &&
          bookType == "PAID" &&
          isReschedule == false) {
        await doctorListController.selectSingleSessionPackage().then((value) {
          doctorListController.getDoctorList(
              promoCode: promoCode, offerOn: "DOCTOR CONSULTATION");
        });
      } else {
        doctorListController.getDoctorList();
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
              "BOOK_CONSULTATION".tr,
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
                    BookFreeDoctor(
                      allowBack: true,
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
        GetBuilder<DoctorController>(builder: (doctorListController) {
          if (doctorListController.isListLoading.value == true) {
            return const Offstage();
          } else if (doctorListController.doctorList.value == null) {
            return const Offstage();
          } else if (doctorListController.doctorList.value!.coachList == null) {
            return const Offstage();
          } else if (doctorListController
              .doctorList.value!.coachList!.isEmpty) {
            return const Offstage();
          }
          if (consultType == "GOT QUERY" &&
              bookType == "PAID" &&
              isReschedule == false) {
            return Padding(
              padding: EdgeInsets.only(top: 22.h),
              child: doctorListController.isPromoCodeApplied.value == false
                  ? const ApplyCoupon(
                      offerOn: "DOCTOR CONSULTATION",
                    )
                  : CouponApplied(
                      offerOn: "DOCTOR CONSULTATION",
                      appliedPromoCode: doctorListController.appliedPromoCode!,
                      removeFunction: () {
                        doctorListController.removeCoupon();
                      }),
            );
          }
          return const Offstage();
        }),
        Obx(() {
          if (doctorListController.isListLoading.value == true) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [showLoading()],
              ),
            );
          } else if (doctorListController.doctorList.value == null) {
            return const ConsultantNotAvailable(consultationType: "DOCTOR");
          } else if (doctorListController.doctorList.value!.coachList == null) {
            return const ConsultantNotAvailable(consultationType: "DOCTOR");
          } else if (doctorListController
              .doctorList.value!.coachList!.isEmpty) {
            return const ConsultantNotAvailable(consultationType: "DOCTOR");
          }
          return Expanded(
            child: ListView.separated(
              padding: pageHorizontalPadding(),
              shrinkWrap: true,
              itemCount:
                  doctorListController.doctorList.value!.coachList!.length,
              separatorBuilder: (context, index) {
                if (index == 3) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 24.h),
                    child: const NeedHelp(),
                  );
                }
                /* if (index == 6) {
                  return const CoachSessionReviews(
                    coachType: "DOCTOR",
                  );
                } */
                return const Offstage();
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: (index ==
                          doctorListController
                                  .doctorList.value!.coachList!.length -
                              1)
                      ? EdgeInsets.only(bottom: 56.h)
                      : index == 0
                          ? EdgeInsets.symmetric(vertical: 24.h)
                          : EdgeInsets.only(bottom: 24.h),
                  child: DoctorCard(
                    pageSource: pageSource,
                    consultType: consultType,
                    bookType: bookType,
                    isReschedule: isReschedule,
                    prevSessionId: prevSessionId,
                    prevSessionDoctorId: prevSessionDoctorId,
                    doctorDetails: doctorListController
                        .doctorList.value!.coachList![index]!,
                    showSessionPrice: (consultType == "GOT QUERY" &&
                            bookType == "PAID" &&
                            isReschedule == false)
                        ? true
                        : false,
                    currency: doctorListController
                                .selectedSingleDoctorSession!.currency !=
                            null
                        ? doctorListController
                            .selectedSingleDoctorSession!.currency!.display!
                        : "",
                    singleSessionPrice:
                        doctorListController.singleSessionPrice.value,
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
