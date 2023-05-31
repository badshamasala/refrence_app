import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/disease_details/disease_details.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealingListController extends GetxController {
  Color appBarTextColor = AppColors.blackLabelColor;

  Rx<HealingListResponse?> healingListResponse = HealingListResponse().obs;
  List<HealingListResponseDiseases?>? activeHealingList = [];
  List<HealingListResponseDiseases?>? inActiveHealingList = [];

  RxInt noOfDiseaseSelected = 0.obs;
  Rx<bool> isLoading = false.obs;

  Rx<bool> showThankYou = false.obs;

  DiseaseDetailsRequest diseaseDetailsRequest = DiseaseDetailsRequest();
  SelectedDiseaseDetailsRequest selectedDiseaseDetailsRequest =
      SelectedDiseaseDetailsRequest();
  List<String> selectedDiseaseNames = [];

  DoctorSessionController doctorSessionController =
      Get.put(DoctorSessionController());

  @override
  void onInit() {
    getHealingList();
    super.onInit();
  }

  setShowThankYou(bool flag) {
    showThankYou.value = flag;
    update();
  }

  getHealingList() async {
    try {
      isLoading.value = true;
      healingListResponse.value = null;
      activeHealingList = [];
      inActiveHealingList = [];
      HealingListResponse? response = await HealingService().getHealingList();
      if (response != null) {
        healingListResponse.value = response;
        for (var element in response.diseases!) {
          if (element!.isActive == true) {
            activeHealingList!.add(element);
          } else {
            inActiveHealingList!.add(element);
          }
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  resetSelection() {
    if (activeHealingList != null && activeHealingList!.isNotEmpty) {
      for (var item in activeHealingList!) {
        item!.isSelected = false;
      }
      noOfDiseaseSelected.value = 4;
      update();
    }
  }

  toggleSelection(int index, BuildContext context) {
    if (!activeHealingList![index]!.isSelected! &&
        noOfDiseaseSelected.value == 4) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showGreenSnackBar(
          context, "You cannot select more than 4 diseases at a time.");
    } else {
      activeHealingList![index]!.isSelected =
          !activeHealingList![index]!.isSelected!;
      checkAnyOptionSelected();
    }

    update();
  }

  checkAnyOptionSelected() {
    noOfDiseaseSelected.value = 0;
    for (var item in activeHealingList!) {
      if (item!.isSelected == true) {
        noOfDiseaseSelected.value++;
      }
    }
  }

  setSelectedDiseaseFromMultiDiseaseIds(List<String> diseaseList) {
    diseaseDetailsRequest.disease = [];
    selectedDiseaseNames = [];
    selectedDiseaseDetailsRequest.disease = [];
    for (HealingListResponseDiseases? item in activeHealingList!) {
      if (diseaseList.contains(item!.diseaseId!) &&
          selectedDiseaseNames.length < diseaseList.length) {
        selectedDiseaseNames.add(item.disease!);
        diseaseDetailsRequest.disease!
            .add(DiseaseDetailsRequestDisease.fromJson({
          "diseaseId": item.diseaseId,
        }));

        selectedDiseaseDetailsRequest.disease!
            .add(SelectedDiseaseDetailsRequestDisease.fromJson({
          "diseaseId": item.diseaseId,
          "diseaseName": item.disease,
        }));
      }
    }
    update();
  }

  setDiseaseFromDeepLink(String diseaseId) {
    diseaseDetailsRequest.disease = [];
    selectedDiseaseNames = [];
    selectedDiseaseDetailsRequest.disease = [];
    for (HealingListResponseDiseases? item in activeHealingList!) {
      if (item!.diseaseId == diseaseId && selectedDiseaseNames.isEmpty) {
        selectedDiseaseNames.add(item.disease!);
        diseaseDetailsRequest.disease!
            .add(DiseaseDetailsRequestDisease.fromJson({
          "diseaseId": item.diseaseId,
        }));

        selectedDiseaseDetailsRequest.disease!
            .add(SelectedDiseaseDetailsRequestDisease.fromJson({
          "diseaseId": item.diseaseId,
          "diseaseName": item.disease,
        }));
      }
    }
    for (var element in selectedDiseaseNames) {
      print("DEEP LINK DISEASE =======>>>>$element");
    }

    update();
  }

  getSelectedDiseaseList() {
    diseaseDetailsRequest.disease = [];
    selectedDiseaseNames = [];
    selectedDiseaseDetailsRequest.disease = [];
    for (HealingListResponseDiseases? item in activeHealingList!) {
      if (item!.isSelected == true) {
        selectedDiseaseNames.add(item.disease!);
        diseaseDetailsRequest.disease!
            .add(DiseaseDetailsRequestDisease.fromJson({
          "diseaseId": item.diseaseId,
        }));

        selectedDiseaseDetailsRequest.disease!
            .add(SelectedDiseaseDetailsRequestDisease.fromJson({
          "diseaseId": item.diseaseId,
          "diseaseName": item.disease,
        }));
      }
    }

    update();
    print("================Disease DETAILS REQ ====================");
    print(diseaseDetailsRequest.toJson().toString());
  }

  getImageFromDiseaseName(String disease) {
    HealingListResponseDiseases? diseaseDetails = activeHealingList!
        .firstWhereOrNull((element) => element!.disease == disease);
    if (diseaseDetails != null) {
      return diseaseDetails.image!.imageUrl ?? "";
    } else {
      return "";
    }
  }

  getImageFromDiseaseId(String diseaseId) {
    HealingListResponseDiseases? diseaseDetails = activeHealingList!
        .firstWhereOrNull((element) => element!.diseaseId == diseaseId);
    if (diseaseDetails != null) {
      return diseaseDetails.image!.imageUrl ?? "";
    } else {
      return "";
    }
  }

  String getDiseaseNameFromDiseaseId(String diseaseId) {
    return activeHealingList!
            .firstWhere((element) => element!.diseaseId == diseaseId)!
            .disease ??
        "";
  }

  setDiseaseSelected(int index, String pageSource, BuildContext context) {
    if (activeHealingList != null && activeHealingList!.isNotEmpty) {
      for (var item in activeHealingList!) {
        item!.isSelected = false;
      }
    }
    activeHealingList![index]!.isSelected = true;
    update();
    Future.delayed(const Duration(milliseconds: 300), () {
      getSelectedDiseaseList();
      Get.put(DiseaseDetailsController());
      EventsService().sendClickNextEvent(
          "Healing List", "View Program", "Disease Details");
      Get.to(DiseaseDetails(
        pageSource: pageSource,
        fromThankYou: false,
      ))!
          .then((value) {
        EventsService()
            .sendClickBackEvent("Disease Details", "Back", "Healing List");
      });
    });
  }
}
