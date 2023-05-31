import 'dart:convert';

import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/controller/consultant/trainer_session_controller.dart';
import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/controller/healing/user_identification_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/get.dart';

import '../home/home_top_section_controller.dart';
import '../home/my_routine_controller.dart';
import '../program/programme_controller.dart';

class SubscriptionController extends GetxController {
  Rx<bool> isLoading = false.obs;

  Rx<SubscriptionDetailsResponse?> subscriptionDetailsResponse =
      SubscriptionDetailsResponse().obs;

  Rx<SubscriptionDetailsResponse?> previousSubscriptionDetails =
      SubscriptionDetailsResponse().obs;

  Future<void> getSubscriptionDetails() async {
    try {
      isLoading.value = true;
      SubscriptionDetailsResponse? response = await SubscriptionService()
          .getSubscriptionDetails(globalUserIdDetails!.userId!);
      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionDetailsResponse.value = response;
      } else {
        subscriptionDetailsResponse.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<bool> checkSubscription() async {
    bool isSubscribed = false;
    try {
      isLoading.value = true;
      SubscriptionCheckResponse? response = await SubscriptionService()
          .checkSubscription(globalUserIdDetails!.userId!);
      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;

        if (response.subscriptionDetails!.programId!.isNotEmpty) {
          //Get Identification Id Details
          UserIdentificationController userIdentificationController =
              Get.put(UserIdentificationController());
          DiseaseDetailsRequest diseaseDetailsRequest = DiseaseDetailsRequest();
          diseaseDetailsRequest.disease = [];
          for (var element in response.subscriptionDetails!.disease!) {
            diseaseDetailsRequest.disease!.add(
                DiseaseDetailsRequestDisease(diseaseId: element!.diseaseId));
          }
          await userIdentificationController.getUserIdentificationId(
              "Initial Assessment",
              diseaseDetailsRequest,
              response.subscriptionDetails!.subscriptionId!);
        }

        isSubscribed = true;
      } else {
        subscriptionCheckResponse = null;
      }
      return isSubscribed;
    } catch (exp) {
      print(exp);
      return isSubscribed;
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<bool> postSubscription() async {
    bool isSubscribed = false;

    try {
      HealingListController healingListController = Get.find();
      PostAssessmentController postAssessmentController = Get.find();

      ProgramDurationPeriodResponseDuration? selectedDuration;
      ProgramDurationPeriodResponseDurationPeriod? selectedPeriod;

      for (var element
          in postAssessmentController.programDurationDetails.value!.duration!) {
        if (element!.isSelected == true) {
          selectedDuration = element;
          for (var item in element.period!) {
            if (item!.isSelected == true) {
              selectedPeriod = item;
              break;
            }
          }
          break;
        }
      }

      print(
          "-------------healingListController.selectedDiseaseDetailsRequest-------------------");
      print(healingListController.selectedDiseaseDetailsRequest.toJson());

      String selectedDiseaseId = "";
      String selectedDisease = "";

      DiseaseDetailsRequest diseaseDetailsRequest = DiseaseDetailsRequest();
      diseaseDetailsRequest.disease = [];
      SubscriptionPostData postData = SubscriptionPostData();
      postData.programId = selectedDuration!.programId;
      postData.disease = [];
      for (var element
          in healingListController.selectedDiseaseDetailsRequest.disease!) {
        if (selectedDiseaseId.isEmpty) {
          selectedDiseaseId = element!.diseaseId!;
        } else {
          selectedDiseaseId = "$selectedDiseaseId, ${element!.diseaseId!}";
        }

        if (selectedDisease.isEmpty) {
          selectedDisease = element.diseaseName!;
        } else {
          selectedDisease = "$selectedDisease, ${element.diseaseName!}";
        }

        postData.disease!
            .add(SubscriptionPostDataDisease.fromJson(element.toJson()));

        diseaseDetailsRequest.disease!
            .add(DiseaseDetailsRequestDisease(diseaseId: element.diseaseId));
      }
      postData.duration = selectedDuration.duration;
      postData.period = selectedPeriod!.days;
      postData.startDate = postAssessmentController.programStartDate.toString();

      SubscriptionCheckResponse? response = await SubscriptionService()
          .postSubscription(globalUserIdDetails!.userId!, postData);

      print("POST SUBSCRIPTION RESPONSE");
      print(response == null ? "NULL" : json.encode(response));

      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;

        //can start program default will be false if null
        subscriptionCheckResponse!.subscriptionDetails!.canStartProgram =
            subscriptionCheckResponse!.subscriptionDetails!.canStartProgram ??
                false;

        UserIdentificationController userIdentificationController =
            Get.put(UserIdentificationController());
        await userIdentificationController.updateUserIdentificationId(
            "Initial Assessment",
            diseaseDetailsRequest,
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!);

        /* EventsService().sendEvent("Aayu_Healing_Program_Started", {
          "user_id": globalUserIdDetails.userId,
          "program_name": response.subscriptionDetails!.programName ?? "",
          "disease_name": response.subscriptionDetails!.diseaseName ?? "",
          "day_number": 0,
          "status": "Incomplete",
          "program_start_date": response.subscriptionDetails!.startDate,
          "program_end_date": response.subscriptionDetails!.expiryDate
        }); */

        dynamic eventData = {
          "user_id": globalUserIdDetails!.userId,
          "disease_id": selectedDiseaseId,
          "disease_name": selectedDisease,
          "program_type":
              postData.disease!.length == 1 ? "Single" : "Personal Care",
          "program_name": response.subscriptionDetails!.programName ?? "",
          "time_duration": selectedDuration.duration ?? "",
          "time_period": selectedPeriod.month ?? "",
          "program_start_date": response.subscriptionDetails!.startDate,
          "program_end_date": response.subscriptionDetails!.expiryDate
        };

        EventsService().sendEvent("Program_Subscribed", eventData);

        isSubscribed = true;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }

    return isSubscribed;
  }

  Future<bool> postAayuSubscription(String orderId, String subscribeVia,
      dynamic selectedSubscriptionPackage) async {
    bool isSubscribed = false;

    try {
      dynamic postData = {
        "subscribeVia": subscribeVia,
        "packageType": selectedSubscriptionPackage["packageType"],
        "paymentDetails": {
          "orderId": orderId,
          "subscriptionCharges":
              selectedSubscriptionPackage["subscriptionCharges"],
          "isPercentage": selectedSubscriptionPackage["isPercentage"],
          "discount": selectedSubscriptionPackage["discount"],
          "purchaseAmount": selectedSubscriptionPackage["purchaseAmount"],
        },
        "selectedPackage": {
          "subscriptionPackageId":
              selectedSubscriptionPackage["subscriptionPackageId"],
          "country": selectedSubscriptionPackage["country"],
          "sessions": {
            "doctor": selectedSubscriptionPackage["sessions"]["doctor"],
            "therapist": selectedSubscriptionPackage["sessions"]["therapist"]
          }
        }
      };
      SubscriptionCheckResponse? response = await SubscriptionService()
          .postAayuSubscription(globalUserIdDetails!.userId!, postData);

      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;
        isSubscribed = true;
        if (selectedSubscriptionPackage["sessions"]["doctor"] > 0) {
          DoctorSessionController doctorSessionController = Get.find();
          doctorSessionController.getUpcomingSessions();
          doctorSessionController.getSessionSummary();
        }
        if (selectedSubscriptionPackage["sessions"]["therapist"] > 0) {
          TrainerSessionController trainerSessionController = Get.find();
          trainerSessionController.getUpcomingSessions();
          trainerSessionController.getSessionSummary();
        }

        dynamic eventData = {
          "user_id": globalUserIdDetails!.userId,
          "orderId": orderId,
          "subscribe_via": subscribeVia,
          "subscription_charges":
              selectedSubscriptionPackage["subscriptionCharges"],
          "is_percentage": selectedSubscriptionPackage["isPercentage"],
          "discount": selectedSubscriptionPackage["discount"],
          "purchase_amount": selectedSubscriptionPackage["purchaseAmount"],
          "package_type": selectedSubscriptionPackage["packageType"],
        };
        EventsService().sendEvent("Aayu_Subscription_Completed", eventData);
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }

    return isSubscribed;
  }

  Future<bool> startProgram() async {
    bool isSubscribed = false;

    try {
      HealingListController healingListController = Get.find();
      PostAssessmentController postAssessmentController = Get.find();

      ProgramDurationPeriodResponseDuration? selectedDuration;
      ProgramDurationPeriodResponseDurationPeriod? selectedPeriod;

      for (var element
          in postAssessmentController.programDurationDetails.value!.duration!) {
        if (element!.isSelected == true) {
          selectedDuration = element;
          selectedDuration.period!.last!.isSelected = true;
          selectedPeriod = selectedDuration.period!.last;
          break;
        }
      }

      String selectedDiseaseId = "";
      String selectedDisease = "";

      DiseaseDetailsRequest diseaseDetailsRequest = DiseaseDetailsRequest();
      diseaseDetailsRequest.disease = [];
      SubscriptionPostData postData = SubscriptionPostData();
      postData.programId = selectedDuration!.programId;
      postData.disease = [];
      for (var element
          in healingListController.selectedDiseaseDetailsRequest.disease!) {
        if (selectedDiseaseId.isEmpty) {
          selectedDiseaseId = element!.diseaseId!;
        } else {
          selectedDiseaseId = "$selectedDiseaseId, ${element!.diseaseId!}";
        }

        if (selectedDisease.isEmpty) {
          selectedDisease = element.diseaseName!;
        } else {
          selectedDisease = "$selectedDisease, ${element.diseaseName!}";
        }

        postData.disease!
            .add(SubscriptionPostDataDisease.fromJson(element.toJson()));

        diseaseDetailsRequest.disease!
            .add(DiseaseDetailsRequestDisease(diseaseId: element.diseaseId));
      }
      postData.duration = selectedDuration.duration;
      postData.period = selectedPeriod!.days;
      postData.startDate = postAssessmentController.programStartDate.toString();

      SubscriptionCheckResponse? response = await SubscriptionService()
          .startProgram(
              globalUserIdDetails!.userId!,
              subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
              postData,
              false);

      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;
        isSubscribed = true;

        //GET USER IDENTIFICATION AND UPDATE SUBSCRIPTION ID AGAINS IT
        UserIdentificationController userIdentificationController =
            Get.put(UserIdentificationController());
        await userIdentificationController.getUserIdentificationId(
            "Initial Assessment",
            diseaseDetailsRequest,
            response.subscriptionDetails!.subscriptionId!);
        await userIdentificationController.updateUserIdentificationId(
            "Initial Assessment",
            diseaseDetailsRequest,
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!);

        dynamic eventData = {
          "user_id": globalUserIdDetails!.userId,
          "disease_id": selectedDiseaseId,
          "disease_name": selectedDisease,
          "program_type":
              postData.disease!.length == 1 ? "Single" : "Personal Care",
          "program_name": response.subscriptionDetails!.programName ?? "",
          "time_duration": selectedDuration.duration ?? "",
          "time_period": selectedPeriod.month ?? "",
          "program_start_date": response.subscriptionDetails!.startDate,
          "program_end_date": response.subscriptionDetails!.expiryDate
        };

        EventsService().sendEvent("Program_Subscribed", eventData);
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }

    return isSubscribed;
  }

  Future<bool> startRecommendedProgram() async {
    bool isSubscribed = false;
    SubscriptionPostData postData = SubscriptionPostData();
    DiseaseDetailsRequest diseaseDetailsRequest = DiseaseDetailsRequest();

    try {
      ProgramRecommendationController programRecommendationController =
          Get.find();
      if (programRecommendationController
              .recommendation.value!.recommendation!.programType ==
          "SINGLE DISEASE") {
        //Single Disease

      } else {
        //Multiple Disease

        diseaseDetailsRequest.disease = [];
        postData.programId = programRecommendationController
                .recommendation.value!.recommendation!.programId ??
            "";
        postData.disease = [];

        for (var element in programRecommendationController
            .recommendation.value!.recommendation!.disease!) {
          postData.disease!.add(SubscriptionPostDataDisease.fromJson({
            "diseaseId": element!.diseaseId ?? "",
            "diseaseName": element.diseaseName ?? ""
          }));

          diseaseDetailsRequest.disease!.add(
              DiseaseDetailsRequestDisease(diseaseId: element.diseaseId ?? ""));
        }

        postData.duration = programRecommendationController
                .recommendation.value!.recommendation!.duration ??
            "";
        postData.period = programRecommendationController
                .recommendation.value!.recommendation!.period ??
            "";
        postData.startDate =
            DateTime.now().add(const Duration(days: 1)).toString();
      }

      SubscriptionCheckResponse? response = await SubscriptionService()
          .startProgram(
              globalUserIdDetails!.userId!,
              subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
              postData,
              true);

      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;
        isSubscribed = true;

        //GET USER IDENTIFICATION AND UPDATE SUBSCRIPTION ID AGAINS IT
        UserIdentificationController userIdentificationController =
            Get.put(UserIdentificationController());
        await userIdentificationController.getUserIdentificationId(
            "Initial Assessment",
            diseaseDetailsRequest,
            response.subscriptionDetails!.subscriptionId!);
        await userIdentificationController.updateUserIdentificationId(
            "Initial Assessment",
            diseaseDetailsRequest,
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!);

        dynamic eventData = {
          "user_id": globalUserIdDetails!.userId,
          "disease_id": postData.disease!
              .map((e) => e!.diseaseId ?? "")
              .toList()
              .join(','),
          "disease_name": postData.disease!
              .map((e) => e!.diseaseName ?? "")
              .toList()
              .join(','),
          "program_type":
              postData.disease!.length == 1 ? "Single" : "Personal Care",
          "program_name": response.subscriptionDetails!.programName ?? "",
          "time_duration": postData.duration ?? "",
          "time_period": postData.period ?? "",
          "program_start_date": response.subscriptionDetails!.startDate,
          "program_end_date": response.subscriptionDetails!.expiryDate
        };

        EventsService().sendEvent("Recommended_Program_Subscribed", eventData);
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }

    return isSubscribed;
  }

  Future<bool> switchProgram(bool isRecommended) async {
    bool isSubscribed = false;

    try {
      DiseaseDetailsController diseaseDetailsController = Get.find();
      PostAssessmentController postAssessmentController = Get.find();

      ProgramDurationPeriodResponseDuration? selectedDuration;
      ProgramDurationPeriodResponseDurationPeriod? selectedPeriod;

      for (var element
          in postAssessmentController.programDurationDetails.value!.duration!) {
        if (element!.isSelected == true) {
          selectedDuration = element;
          selectedDuration.period!.last!.isSelected = true;
          selectedPeriod = selectedDuration.period!.last;
          break;
        }
      }

      DiseaseDetailsRequest diseaseDetailsRequest = DiseaseDetailsRequest();
      diseaseDetailsRequest.disease = [];
      SubscriptionPostData postData = SubscriptionPostData();
      postData.programId = selectedDuration!.programId;
      postData.disease = [];

      String selectedDiseaseId =
          diseaseDetailsController.diseaseDetails.value!.details!.diseaseId ??
              "";
      String selectedDisease =
          diseaseDetailsController.diseaseDetails.value!.details!.disease ?? "";

      postData.disease!.add(SubscriptionPostDataDisease.fromJson(
          {"diseaseId": selectedDiseaseId, "diseaseName": selectedDisease}));

      diseaseDetailsRequest.disease!
          .add(DiseaseDetailsRequestDisease(diseaseId: selectedDiseaseId));
      postData.duration = selectedDuration.duration;
      postData.period = selectedPeriod!.days;
      postData.startDate = postAssessmentController.programStartDate.toString();

      SubscriptionCheckResponse? response = await SubscriptionService()
          .switchProgram(
              globalUserIdDetails!.userId!,
              subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
              postData,
              isRecommended);

      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;
        isSubscribed = true;

        //GET USER IDENTIFICATION AND UPDATE SUBSCRIPTION ID AGAINS IT
        UserIdentificationController userIdentificationController =
            Get.put(UserIdentificationController());
        await userIdentificationController.getUserIdentificationId(
            "Initial Assessment",
            diseaseDetailsRequest,
            response.subscriptionDetails!.subscriptionId!);
        await userIdentificationController.updateUserIdentificationId(
            "Initial Assessment",
            diseaseDetailsRequest,
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!);

        dynamic eventData = {
          "user_id": globalUserIdDetails!.userId,
          "disease_id": selectedDiseaseId,
          "disease_name": selectedDisease,
          "program_type":
              postData.disease!.length == 1 ? "Single" : "Personal Care",
          "program_name": response.subscriptionDetails!.programName ?? "",
          "time_duration": selectedDuration.duration ?? "",
          "time_period": selectedPeriod.month ?? "",
          "program_start_date": response.subscriptionDetails!.startDate,
          "program_end_date": response.subscriptionDetails!.expiryDate
        };

        EventsService().sendEvent("Program_Switched", eventData);
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }

    return isSubscribed;
  }

  Future<bool> switchRecommendedProgram(String packageType) async {
    bool isSubscribed = false;
    SwitchRecommendeProgramPostData postData =
        SwitchRecommendeProgramPostData();
    DiseaseDetailsRequest diseaseDetailsRequest = DiseaseDetailsRequest();

    try {
      ProgramRecommendationController programRecommendationController =
          Get.find();
      if (programRecommendationController
              .recommendation.value!.recommendation!.programType ==
          "SINGLE DISEASE") {
        //Single Disease
        PostAssessmentController postAssessmentController = Get.find();

        ProgramDurationPeriodResponseDuration? selectedDuration;
        ProgramDurationPeriodResponseDurationPeriod? selectedPeriod;

        for (var element in postAssessmentController
            .programDurationDetails.value!.duration!) {
          if (element!.isSelected == true) {
            selectedDuration = element;
            selectedDuration.period!.last!.isSelected = true;
            selectedPeriod = selectedDuration.period!.last;
            break;
          }
        }

        diseaseDetailsRequest.disease = [];
        postData.programId = selectedDuration!.programId;
        postData.disease = [];

        String selectedDiseaseId = programRecommendationController
                .recommendation.value!.recommendation!.disease![0]!.diseaseId ??
            "";
        String selectedDisease = programRecommendationController.recommendation
                .value!.recommendation!.disease![0]!.diseaseName ??
            "";

        postData.disease!.add(SwitchRecommendeProgramPostDataDisease.fromJson(
            {"diseaseId": selectedDiseaseId, "diseaseName": selectedDisease}));

        diseaseDetailsRequest.disease!
            .add(DiseaseDetailsRequestDisease(diseaseId: selectedDiseaseId));
        postData.duration = selectedDuration.duration;
        postData.period = selectedPeriod!.days;
        postData.startDate =
            postAssessmentController.programStartDate.toString();
        postData.packageType = packageType;
      } else {
        //Multiple Disease
        PostAssessmentController postAssessmentController = Get.find();
        ProgramDurationPeriodResponseDuration? selectedDuration;
        ProgramDurationPeriodResponseDurationPeriod? selectedPeriod;

        for (var element in postAssessmentController
            .programDurationDetails.value!.duration!) {
          if (element!.isSelected == true) {
            selectedDuration = element;
            selectedDuration.period!.last!.isSelected = true;
            selectedPeriod = selectedDuration.period!.last;
            break;
          }
        }

        diseaseDetailsRequest.disease = [];
        postData.programId = selectedDuration!.programId;
        postData.disease = [];

        for (var element in programRecommendationController
            .recommendation.value!.recommendation!.disease!) {
          postData.disease!.add(
              SwitchRecommendeProgramPostDataDisease.fromJson({
            "diseaseId": element!.diseaseId ?? "",
            "diseaseName": element.diseaseName ?? ""
          }));

          diseaseDetailsRequest.disease!.add(
              DiseaseDetailsRequestDisease(diseaseId: element.diseaseId ?? ""));
        }

        postData.duration = programRecommendationController
                .recommendation.value!.recommendation!.duration ??
            "";
        postData.period = programRecommendationController
                .recommendation.value!.recommendation!.period ??
            "";
        postData.startDate =
            postAssessmentController.programStartDate.toString();
        postData.packageType = packageType;
      }

      SubscriptionCheckResponse? response = await SubscriptionService()
          .switchRecommendedProgram(
              globalUserIdDetails!.userId!,
              subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
              postData);

      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;
        isSubscribed = true;
        // init Hive Service for Switched Successfully POPUP
        HiveService().initSwitchProgramToPersonalPopup();

        //GET USER IDENTIFICATION AND UPDATE SUBSCRIPTION ID AGAINS IT
        UserIdentificationController userIdentificationController =
            Get.put(UserIdentificationController());
        await userIdentificationController.getUserIdentificationId(
            "Initial Assessment",
            diseaseDetailsRequest,
            response.subscriptionDetails!.subscriptionId!);
        await userIdentificationController.updateUserIdentificationId(
            "Initial Assessment",
            diseaseDetailsRequest,
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!);

        dynamic eventData = {
          "user_id": globalUserIdDetails!.userId,
          "disease_id": postData.disease!
              .map((e) => e!.diseaseId ?? "")
              .toList()
              .join(','),
          "disease_name": postData.disease!
              .map((e) => e!.diseaseName ?? "")
              .toList()
              .join(','),
          "program_type":
              postData.disease!.length == 1 ? "Single" : "Personal Care",
          "program_name": response.subscriptionDetails!.programName ?? "",
          "time_duration": postData.duration ?? "",
          "time_period": postData.period ?? "",
          "program_start_date": response.subscriptionDetails!.startDate,
          "program_end_date": response.subscriptionDetails!.expiryDate
        };

        EventsService().sendEvent("Program_Recommended_Switched", eventData);
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }

    return isSubscribed;
  }

  Future<bool> postAayuRenewal(String orderId, String subscriptionId,
      dynamic selectedRenewalPackage, String renewalVia) async {
    bool isRenewed = false;
    try {
      dynamic postData = {
        "packageType": selectedRenewalPackage["packageType"],
        "isActiveSubscription":
            renewalVia == "PREVIOUS_SUBSCRIPTION" ? false : true,
        "paymentDetails": {
          "orderId": orderId,
          "subscriptionCharges": selectedRenewalPackage["subscriptionCharges"],
          "isPercentage": selectedRenewalPackage["isPercentage"],
          "discount": selectedRenewalPackage["discount"],
          "purchaseAmount": selectedRenewalPackage["purchaseAmount"],
        },
        "selectedPackage": {
          "subscriptionPackageId":
              selectedRenewalPackage["subscriptionPackageId"],
          "country": selectedRenewalPackage["country"],
          "sessions": {
            "doctor": selectedRenewalPackage["sessions"]["doctor"],
            "therapist": selectedRenewalPackage["sessions"]["therapist"]
          }
        }
      };
      SubscriptionCheckResponse? response = await SubscriptionService()
          .postAayuRenewal(
              globalUserIdDetails!.userId!, subscriptionId, postData);

      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;
        isRenewed = true;
        if (selectedRenewalPackage["sessions"]["doctor"] > 0) {
          DoctorSessionController doctorSessionController = Get.find();
          doctorSessionController.getUpcomingSessions();
          doctorSessionController.getSessionSummary();
        }
        if (selectedRenewalPackage["sessions"]["therapist"] > 0) {
          TrainerSessionController trainerSessionController = Get.find();
          trainerSessionController.getUpcomingSessions();
          trainerSessionController.getSessionSummary();
        }
        dynamic eventData = {
          "subscription_id":
              subscriptionCheckResponse!.subscriptionDetails!.subscriptionId,
          "user_id": globalUserIdDetails!.userId,
          "orderId": orderId,
          "subscription_charges": selectedRenewalPackage["subscriptionCharges"],
          "is_percentage": selectedRenewalPackage["isPercentage"],
          "discount": selectedRenewalPackage["discount"],
          "purchase_amount": selectedRenewalPackage["purchaseAmount"],
        };
        EventsService().sendEvent("Aayu_Renewal_Completed", eventData);
      }
    } catch (exp) {
      print(exp);
    } finally {
      update();
    }

    return isRenewed;
  }

  Future<bool> postAayuUpgradePlan(String orderId, String subscriptionId,
      dynamic selectedUpgradePlanPackage) async {
    bool isUpgraded = false;
    try {
      dynamic postData = {
        "packageType": selectedUpgradePlanPackage["packageType"],
        "paymentDetails": {
          "orderId": orderId,
          "subscriptionCharges":
              selectedUpgradePlanPackage["subscriptionCharges"],
          "isPercentage": selectedUpgradePlanPackage["isPercentage"],
          "discount": selectedUpgradePlanPackage["discount"],
          "purchaseAmount": selectedUpgradePlanPackage["purchaseAmount"],
        },
        "selectedPackage": {
          "subscriptionPackageId":
              selectedUpgradePlanPackage["subscriptionPackageId"],
          "country": selectedUpgradePlanPackage["country"],
          "sessions": {
            "doctor": selectedUpgradePlanPackage["sessions"]["doctor"],
            "therapist": selectedUpgradePlanPackage["sessions"]["therapist"]
          }
        }
      };
      SubscriptionCheckResponse? response = await SubscriptionService()
          .postAayuUpgradePlan(
              globalUserIdDetails!.userId!, subscriptionId, postData);

      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;
        isUpgraded = true;
        if (selectedUpgradePlanPackage["sessions"]["doctor"] > 0) {
          DoctorSessionController doctorSessionController = Get.find();
          doctorSessionController.getUpcomingSessions();
          doctorSessionController.getSessionSummary();
        }
        if (selectedUpgradePlanPackage["sessions"]["therapist"] > 0) {
          TrainerSessionController trainerSessionController = Get.find();
          trainerSessionController.getUpcomingSessions();
          trainerSessionController.getSessionSummary();
        }
        dynamic eventData = {
          "subscription_id":
              subscriptionCheckResponse!.subscriptionDetails!.subscriptionId,
          "user_id": globalUserIdDetails!.userId,
          "orderId": orderId,
          "subscription_charges":
              selectedUpgradePlanPackage["subscriptionCharges"],
          "is_percentage": selectedUpgradePlanPackage["isPercentage"],
          "discount": selectedUpgradePlanPackage["discount"],
          "purchase_amount": selectedUpgradePlanPackage["purchaseAmount"],
        };
        EventsService().sendEvent("Aayu_Upgrade_Plan_Completed", eventData);
      }
    } catch (exp) {
      print(exp);
    } finally {
      update();
    }

    return isUpgraded;
  }

  getPreviousSubscriptionDetails() async {
    try {
      isLoading.value = true;
      SubscriptionDetailsResponse? response = await SubscriptionService()
          .getPreviousSubscriptionDetails(globalUserIdDetails!.userId!);
      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        previousSubscriptionDetails.value = response;
      } else {
        previousSubscriptionDetails.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  checkHealingAccess() async {
    bool blockHealingAccess = true;
    try {
      blockHealingAccess = await SubscriptionService()
          .checkHealingAccess(globalUserIdDetails!.userId!);
    } catch (exp) {
      print(exp);
    } finally {}
    return blockHealingAccess;
  }

  blockHealingAccess(String sessionId) async {
    bool isBlocked = false;
    try {
      isBlocked = await SubscriptionService()
          .blockHealingAccess(globalUserIdDetails!.userId!, sessionId);
    } catch (exp) {
      print(exp);
    } finally {}
    return isBlocked;
  }

  fetchBackgroundData() async {
    try {
      ProgrammeController programmeController = Get.put(ProgrammeController(
          subscriptionCheckResponse!.subscriptionDetails!.canStartProgram!));
      if (subscriptionCheckResponse!.subscriptionDetails!.canStartProgram ==
          true) {
        await programmeController.getDayWiseProgramContent();
      } else {
        await programmeController.getDayZeroContent();
        programmeController.sendProgramStartedEvent(0);
        programmeController.setShowPopupAssessment(true);
      }
      HomeTopSectionController homeTopSectionController = Get.find();
      homeTopSectionController.getHomePageTopSectionContent();
      MyRoutineController myRoutineController = Get.find();
      myRoutineController.getData();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> extendExpiryDate(
      String orderId, String subscriptionId, dynamic selectedPackage) async {
    bool isUpdated = false;
    try {
      dynamic postData = {
        "packageType": selectedPackage["packageType"],
        "paymentDetails": {
          "orderId": orderId,
          "subscriptionCharges": selectedPackage["subscriptionCharges"],
          "isPercentage": selectedPackage["isPercentage"],
          "discount": selectedPackage["discount"],
          "purchaseAmount": selectedPackage["purchaseAmount"],
        },
        "selectedPackage": {
          "subscriptionPackageId": selectedPackage["subscriptionPackageId"],
          "country": selectedPackage["country"],
          "sessions": {
            "doctor": selectedPackage["sessions"]["doctor"],
            "therapist": selectedPackage["sessions"]["therapist"]
          }
        }
      };
      SubscriptionCheckResponse? response = await SubscriptionService()
          .extendExpiryDate(
              globalUserIdDetails!.userId!, subscriptionId, postData);

      if (response != null &&
          response.subscriptionDetails != null &&
          response.subscriptionDetails!.subscriptionId!.isNotEmpty) {
        subscriptionCheckResponse = response;
        isUpdated = true;
        if (selectedPackage["sessions"]["doctor"] > 0) {
          DoctorSessionController doctorSessionController = Get.find();
          doctorSessionController.getUpcomingSessions();
        }
        if (selectedPackage["sessions"]["therapist"] > 0) {
          TrainerSessionController trainerSessionController = Get.find();
          trainerSessionController.getUpcomingSessions();
        }
        EventsService().sendEvent("Extend_Expiry_Date", {
          "package_type": selectedPackage["packageType"],
          "subscription_d": subscriptionId,
          "order_id": orderId,
          "subscription_charges": selectedPackage["subscriptionCharges"],
          "isPercentage": selectedPackage["isPercentage"],
          "discount": selectedPackage["discount"],
          "purchase_amount": selectedPackage["purchaseAmount"],
        });
      }
    } catch (exp) {
      print(exp);
    }
    return isUpdated;
  }
}
