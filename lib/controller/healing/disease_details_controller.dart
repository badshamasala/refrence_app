import 'dart:async';

import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/deeplink_data.dart';
import '../../model/deeplinks/how.to.proceed.model.dart';

class DiseaseDetailsController extends GetxController {
  Rx<bool> isLoading = false.obs;

  Rx<DiseaseDetailsResponse?> diseaseDetails = DiseaseDetailsResponse().obs;
  Rx<DiseaseDetailsResponse> selectedHealthProblem =
      DiseaseDetailsResponse().obs;
  Rx<HowToProceedModel> howToProceedContent = HowToProceedModel().obs;

  String multipleDiseaseIds = "";
  int tabIndex = 0;
  ScrollController scrollController = ScrollController();
  Color appBarTextColor = AppColors.blackLabelColor;

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  initScrollController() {
    scrollController = ScrollController()
      ..addListener(() {
        appBarTextColor = isSliverAppBarExpanded
            ? AppColors.blackLabelColor
            : Colors.transparent;
        update();
      });
  }

  scrollDown() {
    Timer(const Duration(seconds: 2), () {
      scrollController.animateTo(300,
          duration: const Duration(seconds: 2), curve: Curves.easeInOut);
    });
  }

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (340 - kToolbarHeight).h;
  }

  Future<void> getDiseaseDetails() async {
    try {
      isLoading.value = true;
      HealingListController healingListController = Get.find();
      DiseaseDetailsResponse? response = await HealingService()
          .getDiseaseDetails(healingListController.diseaseDetailsRequest);
      if (response != null) {
        diseaseDetails.value = response;

        multipleDiseaseIds = "";
        for (var element
            in healingListController.diseaseDetailsRequest.disease!) {
          if (multipleDiseaseIds.isEmpty) {
            multipleDiseaseIds = element!.diseaseId!;
          } else {
            multipleDiseaseIds = "$multipleDiseaseIds,${element!.diseaseId!}";
          }
        }

        if (diseaseDetails.value!.details!.silverAppBar!.title!
                .toUpperCase()
                .trim() !=
            "PERSONALIZED CARE") {
          howToProceedContent.value =
              HowToProceedModel.fromJson(howToProceedDataSingle);
        } else {
          howToProceedContent.value =
              HowToProceedModel.fromJson(howToProceedDataPeronalized);
        }
        EventsService().sendEvent("Disease_Viewed", {
          "multiple_disease_ids": multipleDiseaseIds,
          "multiple_selection":
              healingListController.diseaseDetailsRequest.disease!.length > 1
                  ? true
                  : false,
          "disease_names": healingListController.selectedDiseaseNames.join(","),
        });
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPersonalCareDetails() async {
    try {
      isLoading.value = true;
      DiseaseDetailsResponse? response =
          await HealingService().getPersonalCareDetialsDetails();
      if (response != null) {
        diseaseDetails.value = response;
        multipleDiseaseIds = "";
        howToProceedContent.value =
            HowToProceedModel.fromJson(howToProceedDataSingle);
      }
    } finally {
      isLoading.value = false;
    }
  }

  setSelectedHealthProblem() {
    sendDiseaseInterestedEvent();
    HealingListController healingListController = Get.find();
    if (healingListController.diseaseDetailsRequest.disease!.length == 1) {
      selectedHealthProblem.value = diseaseDetails.value!;
      update();
    }
  }

  sendDiseaseInterestedEvent() {
    HealingListController healingListController = Get.find();
    EventsService().sendEvent("Disease_Interested", {
      "multiple_disease_ids": multipleDiseaseIds,
      "multiple_selection":
          healingListController.diseaseDetailsRequest.disease!.length > 1
              ? true
              : false,
      "disease_names": healingListController.selectedDiseaseNames.join(","),
    });
  }
}
