import 'package:aayu/model/model.dart';
import 'package:aayu/services/nutrition.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';

class NutritionController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<UserNutritionDetailsModel?> userNutritionDetails =
      UserNutritionDetailsModel().obs;

  UserNutritionDietPlanModel? userNutritionDietPlans;

  List<Map<String, String>> navigationOtions = [
    // {
    //   "displayText": "Your Progess",
    //   "navigation": "YOUR_PROGESS",
    //   "icon": Images.yourProgressIcon,
    //   "actionText": "View"
    // },
    {
      "displayText": "Food Plan",
      "navigation": "FOOD_PLAN",
      "icon": Images.foodPlansIcon,
      "actionText": "View"
    },
    {
      "displayText": "Chat With Nutritionist",
      "navigation": "CHAT",
      "icon": Images.chatWithNutritionistIcon,
      "actionText": "View"
    },
    {
      "displayText": "Enter Body Weight",
      "navigation": "BODY_WEIGHT",
      "icon": Images.enterWeightIcon,
      "actionText": "Enter"
    },
  ];

  getUserNutritionDetails() async {
    try {
      isLoading(true);
      UserNutritionDetailsModel? response = await NutritionService()
          .getUserNutritionDetails(globalUserIdDetails?.userId ?? "");
      if (response != null && response.selectedPackage != null) {
        userNutritionDetails.value = response;
      } else {
        userNutritionDetails.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
    }
  }

  startUserNutrition(
      String coachId, String packageId, String paymentOrderId) async {
    bool isStarted = false;
    try {
      dynamic postData = {
        "coachId": coachId,
        "selectedPackage": {
          "packageId": packageId,
          "paymentOrderId": paymentOrderId
        }
      };
      isStarted = await NutritionService()
          .startUserNutrition(globalUserIdDetails?.userId ?? "", postData);
    } catch (exp) {
      print(exp);
    } finally {}
    return isStarted;
  }

  extendNutritionPlan(
      String coachId, String packageId, String paymentOrderId) async {
    bool isExtended = false;
    try {
      dynamic postData = {
        "coachId": coachId,
        "selectedPackage": {
          "packageId": packageId,
          "paymentOrderId": paymentOrderId
        }
      };
      isExtended = await NutritionService()
          .extendNutritionPlan(globalUserIdDetails?.userId ?? "", postData);
    } catch (exp) {
      print(exp);
    } finally {}
    return isExtended;
  }

  getDietPlans() async {
    try {
      isLoading(true);
      UserNutritionDietPlanModel? response = await NutritionService()
          .getDietPlanDetails(globalUserIdDetails?.userId ?? "");
      if (response != null && response.dietPlans != null) {
        userNutritionDietPlans = response;
      } else {
        userNutritionDietPlans = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
      update(["FoodPlanWidget", "FoodPlanList"]);
    }
  }
}
