import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  sendEvent(String event, Map<String, dynamic>? params) {
    try {
      if (params == null) {
        analytics.logEvent(name: event);
      } else {
        analytics.logEvent(name: event, parameters: params);
      }
    } catch (e) {
      print(
          "-----------FirebaseAnalyticsService | sendEvent Exception-----------");
      print(e);
    }
  }

  sendPurchaseEvent(String orderId, String paymentType, String currency,
      double totalPayment) {
    try {
      analytics.logEvent(name: "purchase", parameters: {
        "transaction_id": orderId,
        "currency": currency,
        "value": totalPayment,
        "item_id": paymentType,
      });
      FacebookAppEvents().logPurchase(
          amount: totalPayment,
          currency: currency,
          parameters: {"paymentType": paymentType, "orderId": orderId});
    } catch (e) {
      print(
          "-----------FirebaseAnalyticsService | sendPurchaseEvent Exception-----------");
      print(e);
    }
  }
}
