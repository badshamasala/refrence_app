import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/coach.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/subscription/promo.code.model.dart';
import '../../services/hive.service.dart';
import '../../services/payment.service.dart';

class DoctorController extends GetxController {
  Rx<bool> isListLoading = false.obs;
  Rx<bool> isProfileLoading = false.obs;
  Rx<bool> isSlotDetailsLoading = false.obs;

  Rx<CoachListModel?> doctorList = CoachListModel().obs;
  Rx<CoachAvailableSlotsModel?> availableSlotsList =
      CoachAvailableSlotsModel().obs;
  Rx<CoachProfileModel?> doctorProfile = CoachProfileModel().obs;

  DateTime selectedDate = DateTime.now();
  DateTime initialSelectedDate = DateTime.now();
  DateTime minSelectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<CoachAvailableSlotsModelAvailableSlots> selectedDateSlots = [];
  CoachAvailableSlotsModelAvailableSlots? selectedSlot;

  RxDouble singleSessionPrice = 0.0.obs;
  RxDouble actualSingleSessionPrice = 0.0.obs;
  ConsultingPackagesModelConsultingPackagesDoctorPackages?
      selectedSingleDoctorSession =
      ConsultingPackagesModelConsultingPackagesDoctorPackages();

  DatePickerController datePickerController = DatePickerController();
  RxBool isPromoCodeApplied = false.obs;
  PromoCodesModelPromoCodes? appliedPromoCode;

  Future<void> getDoctorList({String? promoCode, String? offerOn}) async {
    try {
      isPromoCodeApplied.value = false;
      appliedPromoCode = null;

      isListLoading(true);
      CoachListModel? response = await CoachService()
          .getCoachList(globalUserIdDetails?.userId ?? "", "Doctor");
      if (response != null &&
          response.coachList != null &&
          response.coachList!.isNotEmpty) {
        doctorList.value = response;
        if (promoCode != null && offerOn != null) {
          String country = "";
          UserDetailsResponse? userDetailsResponse =
              await HiveService().getUserDetails();

          if (userDetailsResponse?.userDetails?.location != null &&
              userDetailsResponse!.userDetails!.location!.isNotEmpty) {
            country =
                userDetailsResponse.userDetails!.location!.first!.country ?? "";
          }

          dynamic postData = {
            "country": country,
            "promoCode": promoCode,
            "offerOn": offerOn
          };
          PromoCodesModelPromoCodes? response =
              await PaymentService().validateCouponText(postData);
          if (response != null) {
            // EventsService().sendEvent("Promo_Code_Search_Result", {
            //   "offer_on": response.offerOn,
            //   "promo_code_id": response.promoCodeId ?? "",
            //   "promo_code": response.promoCode ?? "",
            //   "title": response.title,
            // });
            print("APPLYING OFFER ============ ${response.toJson()}");
            applyCouponOffers(response);
          }
        }
      } else {
        doctorList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isListLoading(false);
      update();
    }
  }

  Future<void> getDoctorProfile(String doctorId) async {
    try {
      isProfileLoading(true);
      doctorProfile.value = null;
      CoachProfileModel? response = await CoachService()
          .getCoachProfile(globalUserIdDetails?.userId ?? "", doctorId);
      if (response != null && response.coachDetails != null) {
        doctorProfile.value = response;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isProfileLoading(false);
      update();
    }
  }

  Future<void> getDoctorAvailableSlots(String doctorId) async {
    try {
      isSlotDetailsLoading.value = true;
      availableSlotsList.value = null;
      selectedDateSlots = [];
      CoachAvailableSlotsModel? response = await CoachService()
          .getCoachAvailableSlots(
              globalUserIdDetails?.userId ?? "", "Doctor", doctorId);
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
        for (var element in availableSlotsList.value!.availableSlots!) {
          element!.selected = false;
        }
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

  Future<bool> bookSlot(String doctorId, String sessionId, String consultType,
      String bookType, String paymentOrderId) async {
    bool isBooked = false;
    if (sessionId.isNotEmpty) {
      String subscriptionId = "";
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        subscriptionId =
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!;
      }
      dynamic postData = {
        "profession": "Doctor",
        "coachId": doctorId,
        "sessionId": sessionId,
        "consultType": consultType,
        "sessionBookType": bookType,
        "mediator": "AGORA",
        "subscriptionId": subscriptionId,
        "paymentOrderId": paymentOrderId
      };
      isBooked =
          await CoachService().bookSlot(globalUserIdDetails!.userId!, postData);
      if (isBooked == true) {
        DoctorSessionController doctorSessionController = Get.find();
        doctorSessionController.getSessionSummary();
        SubscriptionController subscriptionController = Get.find();
        subscriptionController.blockHealingAccess(sessionId);
      }
    } else {
      showGetSnackBar("Please select any slot", SnackBarMessageTypes.Info);
    }
    return isBooked;
  }

  Future<bool> blockSlot(String doctorId, String sessionId) async {
    bool isBlocked = false;
    if (sessionId.isNotEmpty) {
      dynamic postData = {
        "profession": "Doctor",
        "coachId": doctorId,
        "sessionId": sessionId,
      };
      isBlocked = await CoachService()
          .blockSlot(globalUserIdDetails!.userId!, postData);
    } else {
      showGetSnackBar("Please select any slot", SnackBarMessageTypes.Info);
    }
    return isBlocked;
  }

  Future<bool> rescheduleSlot(
      String previousDoctorId,
      String previousSessionId,
      String doctorId,
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
        "profession": "Doctor",
        "mediator": "AGORA",
        "previousSession": {
          "coachId": previousDoctorId,
          "sessionId": previousSessionId
        },
        "newSession": {
          "coachId": doctorId,
          "sessionId": sessionId,
          "consultType": consultType,
          "sessionBookType": bookType,
          "subscriptionId": subscriptionId
        },
      };
      isBooked = await CoachService()
          .rescheduleSlot(globalUserIdDetails!.userId!, postData);
      if (isBooked == true) {
        DoctorSessionController doctorSessionController = Get.find();
        doctorSessionController.getSessionSummary();
      }
    } else {
      showGetSnackBar("Please select any slot", SnackBarMessageTypes.Info);
    }
    return isBooked;
  }

  Future<void> selectSingleSessionPackage() async {
    isListLoading(true);
    PostAssessmentController postAssessmentController =
        Get.put(PostAssessmentController());
    await postAssessmentController.getConsultingPackageDetails();
    isPromoCodeApplied.value = false;
    appliedPromoCode = null;

    if (postAssessmentController.consultingPackageResponse.value != null &&
        postAssessmentController
                .consultingPackageResponse.value!.consultingPackages !=
            null &&
        postAssessmentController.consultingPackageResponse.value!
                .consultingPackages!.doctorPackages !=
            null) {
      for (var element in postAssessmentController.consultingPackageResponse
          .value!.consultingPackages!.doctorPackages!) {
        if (element!.sessions == 1) {
          element.isSelected = true;
          selectedSingleDoctorSession = element;
          singleSessionPrice.value = element.purchaseAmount!;
          actualSingleSessionPrice.value = element.purchaseAmount!;
          postAssessmentController.update();
          update();
          break;
        }
      }
    }
  }

  Future<bool> confirmSlot(String doctorId, String sessionId,
      String consultType, String bookType, String paymentOrderId) async {
    if (sessionId.isNotEmpty) {
      String subscriptionId = "";
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        subscriptionId =
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!;
      }
      dynamic postData = {
        "profession": "Doctor",
        "coachId": doctorId,
        "mediator": "AGORA",
        "sessionId": sessionId,
        "consultType": consultType,
        "sessionBookType": bookType,
        "subscriptionId": subscriptionId,
        "paymentOrderId": paymentOrderId
      };

      bool isConfirmed = await CoachService()
          .confirmSlot(globalUserIdDetails!.userId!, postData);

      if (isConfirmed) {
        SubscriptionController subscriptionController =
            Get.put(SubscriptionController());
        subscriptionController.blockHealingAccess(sessionId);
        return isConfirmed;
      } else {
        return false;
      }
    } else {
      showGetSnackBar("Please select any slot", SnackBarMessageTypes.Info);
    }
    return false;
  }

  applyCouponOffers(PromoCodesModelPromoCodes? promoCode) {
    PostAssessmentController postAssessmentController = Get.find();
    isListLoading(true);

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
          if (element!.sessions == 1) {
            element.isSelected = true;
            selectedSingleDoctorSession = element;
            singleSessionPrice.value =
                element.purchaseAmount! - element.offerAmount!;
            if (element.country == "IN") {
              singleSessionPrice.value =
                  singleSessionPrice.value.floorToDouble();
            }
            postAssessmentController.update();
            update();
          }
        }
      }

      update();
    }
    isListLoading(false);
  }

  applyTemporaryDiscount(double percent) {
    appliedPromoCode = null;
    isPromoCodeApplied.value = false;
    PostAssessmentController postAssessmentController = Get.find();
    if (postAssessmentController.consultingPackageResponse.value
            ?.consultingPackages?.doctorPackages !=
        null) {
      for (var element in postAssessmentController.consultingPackageResponse
          .value!.consultingPackages!.doctorPackages!) {
        element!.offerAmount = 0;

        double offerAmount = (element.purchaseAmount! * percent) / 100;
        element.offerAmount = offerAmount;

        if (element.sessions == 1) {
          element.isSelected = true;
          selectedSingleDoctorSession = element;
          singleSessionPrice.value =
              element.purchaseAmount! - element.offerAmount!;
          if (element.country == "IN") {
            singleSessionPrice.value = singleSessionPrice.value.floorToDouble();
          }
          postAssessmentController.update();
          update();
        }
      }
    }
  }

  removeCoupon() {
    isListLoading(true);
    PostAssessmentController postAssessmentController = Get.find();
    for (var element in postAssessmentController
        .consultingPackageResponse.value!.consultingPackages!.doctorPackages!) {
      element!.offerAmount = 0;
      if (element.sessions == 1) {
        element.isSelected = true;
        selectedSingleDoctorSession = element;
        singleSessionPrice.value =
            element.purchaseAmount! - element.offerAmount!;
        postAssessmentController.update();
        update();
      }
    }
    isPromoCodeApplied.value = false;
    appliedPromoCode = null;

    update();
    isListLoading(false);
  }
}
