import 'dart:async';

import 'package:aayu/controller/consultant/doctor_controller.dart';
import 'package:aayu/controller/consultant/personal_trainer_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import '../../../model/model.dart';
import '../../payment/juspay_payment.dart';
import '../../shared/ui_helper/ui_helper.dart';

class SpecialDiscountCoach extends StatefulWidget {
  final String pageSource;
  final int time;
  final double percent;
  final SpecialOfferModel specialOfferModel;
  final dynamic customData;
  final DoctorController? doctorController;
  final PersonalTrainerController? personalTrainerController;

  final String country;
  const SpecialDiscountCoach(
      {Key? key,
      required this.time,
      required this.percent,
      required this.customData,
      required this.specialOfferModel,
      required this.country,
      required this.pageSource,
      this.doctorController,
      this.personalTrainerController})
      : super(key: key);

  @override
  State<SpecialDiscountCoach> createState() => _SpecialDiscountCoachState();
}

class _SpecialDiscountCoachState extends State<SpecialDiscountCoach> {
  late DoctorController doctorController;
  late PersonalTrainerController personalTrainerController;
  Timer? timer;
  int time = 0;
  bool expired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.doctorController != null) {
      doctorController = widget.doctorController!;
    }
    if (widget.personalTrainerController != null) {
      personalTrainerController = widget.personalTrainerController!;
    }

    time = widget.time;
    timer = Timer.periodic(const Duration(seconds: 1), (ti) {
      setState(() {
        time--;
        if (time == 0) {
          expired = true;
          if (widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION") {
            doctorController.removeCoupon();
          } else {
            personalTrainerController.removeCoupon();
          }

          if (timer != null) {
            timer!.cancel();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
            ),
            Container(
              height: 165.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 14.h),
              margin: EdgeInsets.symmetric(horizontal: 27.w),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          'assets/images/subscription/offer-tile-green.png'))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.specialOfferModel.offerDetails?.title ??
                                  "",
                              style: TextStyle(
                                  color: AppColors.blackLabelColor,
                                  fontFamily: 'Baskerville',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              widget.specialOfferModel.offerDetails?.desc ?? "",
                              style: TextStyle(
                                  color: const Color(0xFF768897),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Text(
                            '${widget.percent.toInt()}%',
                            style: TextStyle(
                                color: const Color(0xFF496074),
                                fontWeight: FontWeight.w700,
                                fontSize: 60.sp,
                                shadows: [
                                  Shadow(
                                      color: Colors.white,
                                      offset: Offset(0, 4.h),
                                      blurRadius: 2)
                                ]),
                          ),
                          Positioned(
                            bottom: -22,
                            child: Text(
                              'OFF',
                              style: TextStyle(
                                  color: const Color(0xFF496074),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30.sp,
                                  shadows: [
                                    Shadow(
                                        color: Colors.white,
                                        offset: Offset(0, 4.h),
                                        blurRadius: 2)
                                  ]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Get it before it\'s gone',
                        style: TextStyle(
                            color: const Color(0xFF768897),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      Stack(
                        alignment: Alignment.centerLeft,
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            '${time}s',
                            style: TextStyle(
                                color: time <= 10
                                    ? AppColors.errorColor
                                    : AppColors.blueGreyAssessmentColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          Positioned(
                            left: -35,
                            child: LottieBuilder.asset(
                              'assets/animations/timer-lottie.json',
                              height: 40.h,
                              fit: BoxFit.fill,
                              animate: !expired,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(27.h),
                  border:
                      Border.all(color: AppColors.primaryColor, width: 0.5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    'Confirm your slot with\n${widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION" ? widget.customData["doctorName"] : widget.customData["trainerName"]}',
                    style: TextStyle(
                        color: AppColors.blackAssessmentColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 22.sp,
                        fontFamily: 'Baskerville'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  circularConsultImage(
                      widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION"
                          ? "DOCTOR"
                          : "TRAINER",
                      widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION"
                          ? doctorController.doctorProfile.value?.coachDetails
                                  ?.profilePic ??
                              ""
                          : personalTrainerController.trainerProfile.value
                                  ?.coachDetails?.profilePic ??
                              "",
                      110,
                      110),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 11.w),
                    margin: EdgeInsets.symmetric(horizontal: 28.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.h),
                        color: const Color.fromRGBO(252, 175, 175, 0.1)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondaryLabelColor),
                                children: [
                              const TextSpan(
                                text: "Date: ",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(text: widget.customData["scheduleDate"])
                            ])),
                        const Divider(
                          thickness: 1,
                          color: Color.fromRGBO(91, 112, 129, 0.1),
                        ),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondaryLabelColor),
                                children: [
                              const TextSpan(
                                text: "Time: ",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                  text: DateFormat('hh:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.customData["scheduleTime"])))
                            ])),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 29.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 248, 248, 0.8),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(27.h),
                          bottomRight: Radius.circular(27.h),
                        )),
                    child: Row(
                      children: [
                        widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION"
                            ? Text(
                                doctorController
                                            .actualSingleSessionPrice.value ==
                                        doctorController
                                            .singleSessionPrice.value
                                    ? "Price"
                                    : "Discounted price",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF496074)),
                              )
                            : Text(
                                personalTrainerController
                                            .actualSingleSessionPrice.value ==
                                        personalTrainerController
                                            .singleSessionPrice.value
                                    ? "Price"
                                    : "Discounted price",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF496074)),
                              ),
                        const Spacer(),
                        widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION"
                            ? Text(
                                doctorController.actualSingleSessionPrice.value
                                    .toString(),
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: doctorController
                                                .actualSingleSessionPrice
                                                .value ==
                                            doctorController
                                                .singleSessionPrice.value
                                        ? Colors.transparent
                                        : AppColors.secondaryLabelColor),
                              )
                            : Text(
                                personalTrainerController
                                    .actualSingleSessionPrice.value
                                    .toString(),
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: personalTrainerController
                                                .actualSingleSessionPrice
                                                .value ==
                                            personalTrainerController
                                                .singleSessionPrice.value
                                        ? Colors.transparent
                                        : AppColors.secondaryLabelColor),
                              ),
                        SizedBox(
                          width: 5.w,
                        ),
                        widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION"
                            ? Text(
                                (doctorController.selectedSingleDoctorSession
                                            ?.currency?.display ??
                                        "") +
                                    doctorController.singleSessionPrice.value
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blackLabelColor),
                              )
                            : Text(
                                (personalTrainerController
                                            .selectedSingleTrainerSession
                                            ?.currency
                                            ?.display ??
                                        "") +
                                    personalTrainerController
                                        .singleSessionPrice.value
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blackLabelColor),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          dynamic custom = widget.customData;
          custom["promoCodeDetails"] = null;
          custom["specialOffer"] = {
            "referencePackageId": widget.customData["selectedConsultingPackage"]
                ["consultingPackageId"],
            "specialOfferId":
                widget.specialOfferModel.offerDetails?.specialOfferId,
            "source": widget.specialOfferModel.offerDetails?.source,
            "offerOn": widget.specialOfferModel.offerDetails?.offerOn,
            "country": widget.country,
            "discount": widget.percent
          };
          Navigator.pop(context);
          Get.to(JuspayPayment(
            pageSource: widget.pageSource,
            totalPayment: widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION"
                ? doctorController.singleSessionPrice.value
                : personalTrainerController.singleSessionPrice.value,
            currency: widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION"
                ? doctorController
                        .selectedSingleDoctorSession!.currency!.billing ??
                    ""
                : personalTrainerController
                        .selectedSingleTrainerSession?.currency?.billing ??
                    "",
            paymentEvent: widget.pageSource == "CONFIRM_DOCTOR_CONSULTATION"
                ? "DOCTOR_CONSULTATION"
                : "THERAPIST_CONSULTATION",
            customData: custom,
          ));
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 25.h, left: 26.w, right: 25.w),
          child: mainButton("Pay Now"),
        ),
      ),
    );
  }
}
