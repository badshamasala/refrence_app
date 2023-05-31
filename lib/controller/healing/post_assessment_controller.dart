import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/model/subscription/promo.code.model.dart';
import 'package:aayu/services/payment.service.dart';
import 'package:aayu/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostAssessmentController extends GetxController {
  RxDouble containerHeight = 447.0.h.obs;
  RxInt selectedPage = 0.obs;

  Rx<bool> isLoading = false.obs;
  Rx<ConsultingPackagesModel?> consultingPackageResponse =
      ConsultingPackagesModel().obs;
  Rx<ProgramDurationPeriodResponse?> programDurationDetails =
      ProgramDurationPeriodResponse().obs;

  DateTime programStartDate = DateTime.now().add(const Duration(days: 1));
  TextEditingController programStartDateController = TextEditingController();

  HealingListController healingListController = Get.find();

  RxBool isPromoCodeApplied = false.obs;
  PromoCodesModelPromoCodes? appliedPromoCode;

  setSelectedPage(int index) {
    switch (index) {
      case 0:
        containerHeight.value = 613.h;
        break;
      case 1:
        containerHeight.value = 673.h;
        break;
      default:
        containerHeight.value = 460.h;
        break;
    }
    selectedPage.value = index;
    update();
  }

  @override
  void onInit() {
    programStartDateController.text =
        DateFormat('dd-MM-yyyy').format(programStartDate);
    super.onInit();
  }

  Future<bool> getProgramDurationDetails() async {
    bool isDataAvailable = false;
    try {
      isLoading.value = true;
      programDurationDetails.value = null;
      final DiseaseDetailsController diseaseDetailsController =
          Get.put(DiseaseDetailsController());
      ProgramDurationPeriodResponse? response = await ProgrameService()
          .getProgramDurationPackages(diseaseDetailsController
              .selectedHealthProblem.value.details!.diseaseId!);
      if (response != null &&
          response.duration != null &&
          response.duration!.isNotEmpty) {
        programDurationDetails.value = response;
        isDataAvailable = true;
      }
    } finally {
      isLoading.value = false;
      update();
    }
    return isDataAvailable;
  }

  Future<bool> getConsultingPackageDetails() async {
    bool isDataAvailable = false;
    try {
      isLoading.value = true;
      isPromoCodeApplied.value = false;
      appliedPromoCode = null;
      ConsultingPackagesModel? response =
          await PaymentService().getAllConsultingPackages();
      if (response != null && response.consultingPackages != null) {
        consultingPackageResponse.value = response;
        if (consultingPackageResponse
            .value!.consultingPackages!.doctorPackages!.isNotEmpty) {
          ConsultingPackagesModelConsultingPackagesDoctorPackages? recommended =
              consultingPackageResponse
                  .value!.consultingPackages!.doctorPackages!
                  .firstWhereOrNull((element) => element!.recommended == true);
          if (recommended == null) {
            consultingPackageResponse.value!.consultingPackages!.doctorPackages!
                .first!.recommended = true;
            consultingPackageResponse.value!.consultingPackages!.doctorPackages!
                .first!.isSelected = true;
          } else {
            recommended.isSelected = true;
          }
        }
        if (consultingPackageResponse
            .value!.consultingPackages!.therapistPackages!.isNotEmpty) {
          ConsultingPackagesModelConsultingPackagesTherapistPackages?
              recommended = consultingPackageResponse
                  .value!.consultingPackages!.therapistPackages!
                  .firstWhereOrNull((element) => element!.recommended == true);
          if (recommended == null) {
            consultingPackageResponse.value!.consultingPackages!
                .therapistPackages!.first!.recommended = true;
            consultingPackageResponse.value!.consultingPackages!
                .therapistPackages!.first!.isSelected = true;
          } else {
            recommended.isSelected = true;
          }
        }

        isDataAvailable = true;
      }
    } finally {
      isLoading.value = false;
      update();
    }
    return isDataAvailable;
  }

  setProgramDuration(int index) {
    for (var element in programDurationDetails.value!.duration!) {
      element!.isSelected = false;
    }
    programDurationDetails.value!.duration![index]!.isSelected = true;

    sendDiseaseInterestedProgramEvent(
        programDurationDetails.value!.duration![index]!.programId!,
        programDurationDetails.value!.duration![index]!.duration!,
        "");

    update();
  }

  setProgramPeriod(int durationIndex, int periodIndex) {
    for (var element
        in programDurationDetails.value!.duration![durationIndex]!.period!) {
      element!.isSelected = false;
    }
    programDurationDetails.value!.duration![durationIndex]!
        .period![periodIndex]!.isSelected = true;

    sendDiseaseInterestedProgramEvent(
        programDurationDetails.value!.duration![durationIndex]!.programId!,
        programDurationDetails.value!.duration![durationIndex]!.duration!,
        programDurationDetails
            .value!.duration![durationIndex]!.period![periodIndex]!.days!);

    update();
  }

  setPersonalTrainingOption(index) {
    for (var element in consultingPackageResponse
        .value!.consultingPackages!.therapistPackages!) {
      element!.isSelected = false;
    }
    consultingPackageResponse.value!.consultingPackages!
        .therapistPackages![index]!.isSelected = true;
    update();
  }

  skipPersonalTrainingOptions() {
    for (var element in consultingPackageResponse
        .value!.consultingPackages!.therapistPackages!) {
      element!.isSelected = false;
    }
    update();
  }

  setDoctorTrainingOption(index) {
    for (var element in consultingPackageResponse
        .value!.consultingPackages!.doctorPackages!) {
      element!.isSelected = false;
    }
    consultingPackageResponse
        .value!.consultingPackages!.doctorPackages![index]!.isSelected = true;
    update();
  }

  skipDoctorTrainingOptions() {
    for (var element in consultingPackageResponse
        .value!.consultingPackages!.doctorPackages!) {
      element!.isSelected = false;
    }
    update();
  }

  updateProgramStartDate(DateTime dateTime) {
    programStartDate = dateTime;
    update();
  }

  sendDiseaseInterestedProgramEvent(
      String programId, String duration, String period) {
    String multipleDiseaseIds = "";
    for (var element in healingListController.diseaseDetailsRequest.disease!) {
      if (multipleDiseaseIds.isEmpty) {
        multipleDiseaseIds = element!.diseaseId!;
      } else {
        multipleDiseaseIds = "$multipleDiseaseIds,${element!.diseaseId!}";
      }
    }
    EventsService().sendEvent("Disease_Interested_Program", {
      "multiple_disease_ids": multipleDiseaseIds,
      "multiple_selection":
          healingListController.diseaseDetailsRequest.disease!.length > 1
              ? true
              : false,
      "disease_names": healingListController.selectedDiseaseNames.join(","),
      "program_id": programId,
      "duration": duration,
      "period": period
    });
  }

  Future<bool> getProgramDetails(String programId) async {
    bool isDataAvailable = false;
    try {
      programDurationDetails.value = null;
      ProgramDurationPeriodResponse? response =
          await ProgrameService().getProgramDetailsOnProgramId(programId);
      if (response != null &&
          response.duration != null &&
          response.duration!.isNotEmpty) {
        programDurationDetails.value = response;
        isDataAvailable = true;
      }
    } finally {
      update();
    }
    return isDataAvailable;
  }

  applyCouponOffers(PromoCodesModelPromoCodes? promoCode) {
    PostAssessmentController postAssessmentController = Get.find();
    if (promoCode?.offerDetails != null &&
        promoCode?.offerOn == "DOCTOR CONSULTATION") {
      if (postAssessmentController.consultingPackageResponse.value
              ?.consultingPackages?.doctorPackages !=
          null) {
        for (var element in postAssessmentController.consultingPackageResponse
            .value!.consultingPackages!.doctorPackages!) {
          int index = promoCode!.offerDetails!.indexWhere(
              (offer) => offer!.referenceId == element!.consultingPackageId!);
          if (index != -1) {
            appliedPromoCode = promoCode;
            isPromoCodeApplied.value = true;
            if (promoCode.offerDetails![index]!.isPercentage == true) {
              double offerAmount = 0;
              offerAmount = (element!.purchaseAmount! *
                      promoCode.offerDetails![index]!.discount!) /
                  100;
              element.offerAmount = offerAmount;
            } else {
              element!.offerAmount = promoCode.offerDetails![index]!.discount!;
            }
          }
        }
        update();
      }
    } else if (promoCode?.offerDetails != null &&
        promoCode?.offerOn == "THERAPIST CONSULTATION") {
      if (postAssessmentController.consultingPackageResponse.value
              ?.consultingPackages?.therapistPackages !=
          null) {
        for (var element in postAssessmentController.consultingPackageResponse
            .value!.consultingPackages!.therapistPackages!) {
          int index = promoCode!.offerDetails!.indexWhere(
              (offer) => offer!.referenceId == element!.consultingPackageId!);
          if (index != -1) {
            appliedPromoCode = promoCode;
            isPromoCodeApplied.value = true;
            if (promoCode.offerDetails![index]!.isPercentage == true) {
              double offerAmount = 0;
              offerAmount = (element!.purchaseAmount! *
                      promoCode.offerDetails![index]!.discount!) /
                  100;
              element.offerAmount = offerAmount;
            } else {
              element!.offerAmount = promoCode.offerDetails![index]!.discount!;
            }
          }
        }
        update();
      }
    }
  }

  removeCoupon(String offerOn) {
    if (offerOn == "DOCTOR SESSIONS") {
      for (var element in consultingPackageResponse
          .value!.consultingPackages!.doctorPackages!) {
        element!.offerAmount = 0;
      }
    } else if (offerOn == "TRAINER SESSIONS") {
      for (var element in consultingPackageResponse
          .value!.consultingPackages!.therapistPackages!) {
        element!.offerAmount = 0;
      }
    }
    isPromoCodeApplied.value = false;
    appliedPromoCode = null;
    update();
  }
}
