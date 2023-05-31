import 'package:aayu/view/payment/payment_pop_ups/wigets/personal_care_subscription_payment_success.dart';
import 'package:flutter/material.dart';
import 'wigets/content_payment_success.dart';
import 'wigets/healing_payment_success.dart';
import 'wigets/personal_care_payment_success.dart';

class SubscriptionPaymentSuccess extends StatelessWidget {
  final dynamic customData;
  const SubscriptionPaymentSuccess({Key? key, required this.customData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (customData["subscribeVia"]) {
      case "HEALING":
        return const HealingPaymentSuccess(
          isFreeSubscription: false,
        );
      case "RECOMMENDED_PROGRAM":
        if (customData["multipleProgram"] != null &&
            customData["multipleProgram"] == true) {
          return const PersonalCareSubscriptionPaymentSuccess();
        } else {
          return const HealingPaymentSuccess(
            isFreeSubscription: false,
          );
        }
      case "LIVE_EVENT":
        return ContentPaymentSuccess(subscribeVia: customData["subscribeVia"]);
      case "PERSONAL_CARE":
        return const PersonalCarePaymentSuccess();
      case "MY_SUBSCRIPTION":
        return ContentPaymentSuccess(subscribeVia: customData["subscribeVia"]);
      default:
        return ContentPaymentSuccess(subscribeVia: customData["subscribeVia"]);
    }
  }
}
