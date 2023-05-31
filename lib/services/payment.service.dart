import 'package:aayu/model/model.dart';
import 'package:aayu/model/subscription/promo.code.model.dart';
import 'package:aayu/services/hive.service.dart';
import 'package:aayu/services/request.id.service.dart';
import 'package:aayu/view/shared/constants.dart';

import '../view/shared/ui_helper/ui_helper.dart';
import 'http.service.dart';

const String paymentServiceName = "payment-service";

enum ProgramType { SINGLEDISEASE, PERSONALCARE }

enum ProgramPurchaseType { SUBSCRIBE, RENEWAL }

class PaymentService {
  Future<ConsultingPackagesModel?> getAllConsultingPackages() async {
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
    dynamic response = await httpGet(paymentServiceName,
        'v1/user/consulting/packages?country=$country&requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      ConsultingPackagesModel consultingPackagesModel =
          ConsultingPackagesModel();
      consultingPackagesModel =
          ConsultingPackagesModel.fromJson(response["data"]);
      return consultingPackagesModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SupcriptionPackagesModel?> getSubscriptionPackages(
      String subscriptionType, String purchaseType) async {
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
    dynamic response = await httpGet(paymentServiceName,
        'v1/user/subscription/packages/$purchaseType/${Uri.encodeComponent(subscriptionType)}?country=$country&requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      SupcriptionPackagesModel supcriptionPackagesModel =
          SupcriptionPackagesModel();
      supcriptionPackagesModel =
          SupcriptionPackagesModel.fromJson(response["data"]);
      return supcriptionPackagesModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SupcriptionPackagesModel?> getUpgradeSubscriptionPackages() async {
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
    dynamic response = await httpGet(paymentServiceName,
        'v1/user/subscription/packages/upgrade?country=$country&requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      SupcriptionPackagesModel supcriptionPackagesModel =
          SupcriptionPackagesModel();
      supcriptionPackagesModel =
          SupcriptionPackagesModel.fromJson(response["data"]);
      return supcriptionPackagesModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<dynamic> createJuspaySession(dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/payment/juspay/session?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      return response["data"];
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<dynamic> getJuspayOrderStatus(String orderId) async {
    dynamic response = await httpGet(paymentServiceName,
        'v1/payment/juspay/order/status/$orderId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      return response["data"];
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<dynamic> postJuspayTransaction(dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/payment/juspay/transaction?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      return response["data"];
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<dynamic> postConsultingPackageEntry(dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/user/consulting/packages?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      return response["data"];
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<PromoCodesModel?> getPromoCodes(String offerOn) async {
    String country = "";
    UserDetailsResponse? userDetailsResponse =
        await HiveService().getUserDetails();

    if (userDetailsResponse?.userDetails?.location != null &&
        userDetailsResponse!.userDetails!.location!.isNotEmpty) {
      country = userDetailsResponse.userDetails!.location!.first!.country ?? "";
    }

    dynamic response = await httpGet(paymentServiceName,
        'v1/user/promoCodes/$country/$offerOn?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      PromoCodesModel promoCodesModel = PromoCodesModel();
      promoCodesModel = PromoCodesModel.fromJson(response['data']);
      return promoCodesModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> applyPromoCode(String promoCodeId) async {
    String country = "";
    UserDetailsResponse? userDetailsResponse =
        await HiveService().getUserDetails();

    if (userDetailsResponse?.userDetails?.location != null &&
        userDetailsResponse!.userDetails!.location!.isNotEmpty) {
      country = userDetailsResponse.userDetails!.location!.first!.country ?? "";
    }

    dynamic response = await httpGet(paymentServiceName,
        'v1/user/promoCodes/apply/$country/$promoCodeId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      if (response['data']['isValid'] == true) {
        return true;
      } else {
        showGreenSnackBar(null, response['data']['errorMessage']);
        return false;
      }
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<dynamic> postPromoCodeTransaction(dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/user/promoCodes/transaction?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      return response["data"];
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<PromoCodesModelPromoCodes?> postCouponCodeText(
      dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/user/promoCodes/search?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      if (response['data'] != null && response['data']['promoCode'] != null) {
        PromoCodesModelPromoCodes promoCodesModelPromoCodes =
            PromoCodesModelPromoCodes();
        promoCodesModelPromoCodes =
            PromoCodesModelPromoCodes.fromJson(response['data']['promoCode']);
        return promoCodesModelPromoCodes;
      } else {
        return null;
      }
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<PromoCodesModelPromoCodes?> validateCouponText(
      dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/user/promoCodes/validate?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      if (response['data'] != null && response['data']['promoCode'] != null) {
        PromoCodesModelPromoCodes promoCodesModelPromoCodes =
            PromoCodesModelPromoCodes();
        promoCodesModelPromoCodes =
            PromoCodesModelPromoCodes.fromJson(response['data']['promoCode']);
        return promoCodesModelPromoCodes;
      } else {
        return null;
      }
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionCommunicationModel?>
      getSubscriptionCommunicationDetails() async {
    dynamic response = await httpGet(paymentServiceName,
        'v1/user/subscription/packages/communications?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      SubscriptionCommunicationModel? subscriptionCommunicationModel =
          SubscriptionCommunicationModel();
      subscriptionCommunicationModel =
          SubscriptionCommunicationModel.fromJson(response['data']);
      return subscriptionCommunicationModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionTestimonialModel?>
      getSubscriptionTestimonialDetails() async {
    dynamic response = await httpGet(paymentServiceName,
        'v1/user/subscription/packages/testimonials?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      SubscriptionTestimonialModel? subscriptionTestimonialModel =
          SubscriptionTestimonialModel();
      subscriptionTestimonialModel =
          SubscriptionTestimonialModel.fromJson(response['data']);
      return subscriptionTestimonialModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<NutritionStaringPlansModel?> getNutritionStartingPlans(
      dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/user/nutrition/packages/starting?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      NutritionStaringPlansModel nutritionPlans = NutritionStaringPlansModel();
      nutritionPlans = NutritionStaringPlansModel.fromJson(response["data"]);
      return nutritionPlans;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<NutritionPlansModel?> getNutritionPlans(dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/user/nutrition/packages/get?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      NutritionPlansModel nutritionPlans = NutritionPlansModel();
      nutritionPlans = NutritionPlansModel.fromJson(response["data"]);
      return nutritionPlans;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<PaymentInvoiceModel?> getInvoices() async {
    dynamic response = await httpGet(
        paymentServiceName, 'v1/user/invoices?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      PaymentInvoiceModel? paymentInvoiceResponse = PaymentInvoiceModel();
      paymentInvoiceResponse = PaymentInvoiceModel.fromJson(response['data']);
      return paymentInvoiceResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ActivationCodeVailidateModel?> validateActivationCode(
      String activationCode, String country) async {
    dynamic response = await httpPost(paymentServiceName,
        'v1/user/activationCode/validate?requestId=${getRequestId()}', {
      "data": {
        "activationCode": activationCode,
        "country": country,
      }
    },
        customHeaders: {
          "x-user-id": globalUserIdDetails?.userId
        });
    if (response != null && response["success"] == true) {
      ActivationCodeVailidateModel? activationCodeVailidateResponse =
          ActivationCodeVailidateModel();
      activationCodeVailidateResponse =
          ActivationCodeVailidateModel.fromJson(response['data']);
      return activationCodeVailidateResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> activateActivationCode(
      String activationCode, String country) async {
    dynamic response = await httpPost(paymentServiceName,
        'v1/user/activationCode/activate?requestId=${getRequestId()}', {
      "data": {
        "activationCode": activationCode,
        "country": country,
      }
    },
        customHeaders: {
          "x-user-id": globalUserIdDetails?.userId
        });
    if (response != null && response["success"] == true) {
      if (response['data']['activated'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      showError(response["error"]);
      return false;
    }
  }

  //Psychology
  Future<PsychologyStartingPlansModel?> getPsychologyStartingPlans(
      dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/user/psychologist/packages/starting?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      PsychologyStartingPlansModel psychologyPlans =
          PsychologyStartingPlansModel();
      psychologyPlans = PsychologyStartingPlansModel.fromJson(response["data"]);
      return psychologyPlans;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<PsychologyPlansModel?> getPsychologyPlans(dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/user/psychologist/packages/get?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      PsychologyPlansModel psychologyPlans = PsychologyPlansModel();
      psychologyPlans = PsychologyPlansModel.fromJson(response["data"]);
      return psychologyPlans;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SpecialOfferModel?> getSpecialOffer(
      String source, String offerOn) async {
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
    dynamic response = await httpGet(paymentServiceName,
        'v1/user/specialOffer/${Uri.encodeComponent(source)}/$country/${Uri.encodeComponent(offerOn)}?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      SpecialOfferModel specialOfferModel = SpecialOfferModel();
      specialOfferModel = SpecialOfferModel.fromJson(response["data"]);
      return specialOfferModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> postSpecialOfferTransaction(dynamic postData) async {
    dynamic response = await httpPost(
        paymentServiceName,
        'v1/user/specialOffer/transaction?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }
}
