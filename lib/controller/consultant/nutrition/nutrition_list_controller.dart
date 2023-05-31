// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:aayu/services/coach.service.dart';
import 'package:aayu/services/payment.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:get/get.dart';
import '../../../model/model.dart';
import 'package:intl/intl.dart';

class NutritionListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isProfileLoading = false.obs;
  Rx<bool> isSlotDetailsLoading = false.obs;

  Rx<NutritionStaringPlansModel?> nutritionStartingPlansResponse =
      NutritionStaringPlansModel().obs;

  Rx<CoachListModel?> nutritionListResponse = CoachListModel().obs;
  Rx<CoachAvailableSlotsModel?> availableSlotsList =
      CoachAvailableSlotsModel().obs;
  Rx<CoachProfileModel?> coachProfile = CoachProfileModel().obs;

  DateTime selectedDate = DateTime.now();
  DateTime initialSelectedDate = DateTime.now();
  DateTime minSelectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<CoachAvailableSlotsModelAvailableSlots> selectedDateSlots = [];
  CoachAvailableSlotsModelAvailableSlots? selectedSlot = null;

  DatePickerController datePickerController = DatePickerController();

  Future<void> getStartingPlan() async {
    try {
      isLoading(true);
      String country = "";
      UserDetailsResponse? userDetailsResponse =
          await HiveService().getUserDetails();
      if (userDetailsResponse != null &&
          userDetailsResponse.userDetails != null) {
        if (userDetailsResponse.userDetails!.location != null &&
            userDetailsResponse.userDetails!.location!.isNotEmpty) {
          country =
              userDetailsResponse.userDetails!.location!.first!.country ?? "";
        }
      }
      dynamic postData = {"country": country, "purchaseType": "FIRST TIME"};
      NutritionStaringPlansModel? response =
          await PaymentService().getNutritionStartingPlans(postData);
      if (response != null &&
          response.packages != null &&
          response.packages!.isNotEmpty) {
        nutritionStartingPlansResponse.value = response;
      } else {
        nutritionStartingPlansResponse.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getNutritionList() async {
    try {
      isLoading(true);
      CoachListModel? response = await CoachService()
          .getCoachList(globalUserIdDetails?.userId ?? "", "Nutritionist");
      if (response != null &&
          response.coachList != null &&
          response.coachList!.isNotEmpty) {
        nutritionListResponse.value = response;
      } else {
        nutritionListResponse.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getNutritionProfile(String nutritionistId) async {
    try {
      isProfileLoading(true);
      coachProfile.value = null;
      CoachProfileModel? response = await CoachService()
          .getCoachProfile(globalUserIdDetails?.userId ?? "", nutritionistId);
      if (response != null && response.coachDetails != null) {
        coachProfile.value = response;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isProfileLoading(false);
      update();
    }
  }

  Future<void> getNutritionAvailableSlots(String nutritionistId) async {
    try {
      isSlotDetailsLoading.value = true;
      availableSlotsList.value = null;
      selectedDateSlots = [];
      CoachAvailableSlotsModel? response = await CoachService()
          .getCoachAvailableSlots(globalUserIdDetails?.userId ?? "",
              "Nutritionist", nutritionistId);
      if (response != null &&
          response.availableSlots != null &&
          response.availableSlots!.isNotEmpty) {
        availableSlotsList.value = response;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isSlotDetailsLoading.value = false;
      setSelectedDate(selectedDate);
      update();
    }
  }

  setSelectedDate(DateTime changedDate) {
    if (changedDate.compareTo(minSelectedDate) >= 0) {
      selectedDate = changedDate;
      selectedDateSlots = [];
      if (availableSlotsList.value != null) {
        availableSlotsList.value!.availableSlots!.forEach((element) {
          element!.selected = false;
        });
        for (var element in availableSlotsList.value!.availableSlots!) {
          if (DateFormat.yMMMd().format(selectedDate).toString() ==
              DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
                element!.fromTime!,
              ))) {
            selectedDateSlots.add(element);
          }
        }
      }
    }
    update(["SlotCalender", "AvailableSlots", "AvailableSlotAction"]);
  }

  checkSlotSeleted() {
    bool isSelected = false;
    if (availableSlotsList.value != null) {
      CoachAvailableSlotsModelAvailableSlots? userSelectedSlot =
          availableSlotsList.value!.availableSlots!
              .firstWhereOrNull((element) => element!.selected == true);
      if (userSelectedSlot != null) {
        selectedSlot = userSelectedSlot;
        isSelected = userSelectedSlot.selected!;
      } else {
        selectedSlot = null;
      }
    }
    return isSelected;
  }

  Future<bool> bookSlot(String nutritionistId, String sessionId,
      String consultType, String bookType, String paymentOrderId) async {
    bool isBooked = false;
    if (sessionId.isNotEmpty) {
      String subscriptionId = "";
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        subscriptionId =
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!;
      }
      dynamic postData = {
        "profession": "Nutritionist",
        "coachId": nutritionistId,
        "sessionId": sessionId,
        "consultType": consultType,
        "sessionBookType": bookType,
        "mediator": "AGORA",
        "subscriptionId": subscriptionId,
        "paymentOrderId": paymentOrderId
      };
      isBooked =
          await CoachService().bookSlot(globalUserIdDetails!.userId!, postData);
      if (isBooked == true) {}
    } else {
      showGetSnackBar("Please select any slot", SnackBarMessageTypes.Info);
    }
    return isBooked;
  }

  Future<bool> rescheduleSlot(
      String previousNutritionistId,
      String previousSessionId,
      String nutritionistId,
      String consultType,
      String bookType,
      String sessionId) async {
    bool isBooked = false;
    if (sessionId.isNotEmpty) {
      String subscriptionId = "";
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        subscriptionId =
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!;
      }
      dynamic postData = {
        "profession": "Nutritionist",
        "mediator": "AGORA",
        "previousSession": {
          "coachId": previousNutritionistId,
          "sessionId": previousSessionId
        },
        "newSession": {
          "coachId": nutritionistId,
          "sessionId": sessionId,
          "consultType": consultType,
          "sessionBookType": bookType,
          "subscriptionId": subscriptionId
        },
      };
      isBooked = await CoachService()
          .rescheduleSlot(globalUserIdDetails!.userId!, postData);
      if (isBooked == true) {}
    } else {
      showGetSnackBar("Please select any slot", SnackBarMessageTypes.Info);
    }
    return isBooked;
  }
}
