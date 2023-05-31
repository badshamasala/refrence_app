import 'dart:async';
import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/grow/grow_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/controller/you/you_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalisingYourSpace extends StatefulWidget {
  final bool isSkiped;
  const PersonalisingYourSpace({Key? key, this.isSkiped = false})
      : super(key: key);

  @override
  State<PersonalisingYourSpace> createState() => _PersonalisingYourSpaceState();
}

class _PersonalisingYourSpaceState extends State<PersonalisingYourSpace> {
  @override
  initState() {
    fetchBackgroundData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SingularDeepLinkController singularDeepLinkController = Get.find();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 175.h,
            ),
            Image(
              width: 152.w,
              height: 294.h,
              image: const AssetImage(Images.flowerGIFImage),
            ),
            SizedBox(
              width: 250.w,
              child: Column(
                children: [
                  if (singularDeepLinkController.deepLinkDataContinued == null)
                    Text(
                      "THANK_YOU_FOR_REGISTERING".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Baskerville',
                        fontSize: 22.h,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.1818181818181819.h,
                      ),
                    ),
                  Text(
                    (widget.isSkiped == true)
                        ? "GIVE_US_A_MOMENT_SET_UP_SPACE".tr
                        : "GIVE_US_A_MOMENT_PERSONALIZE_SPACE".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Baskerville',
                      fontSize: 22.h,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.1818181818181819.h,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        )),
      ),
    );
  }

  fetchBackgroundData() async {
    try {
      //Healing Diease List
      Get.put(HealingListController());
      //Grow Page Categories with 1st Category Content
      Get.put(GrowController());
      YouController youController = Get.put(YouController(), permanent: true);
      SubscriptionController subscriptionController =
          Get.put(SubscriptionController());
      await Future.wait([
        //You Page Minutes Summary
        youController.getMinutesSummary(),
        //Check Subscription
        subscriptionController.checkSubscription()
      ]);
    } finally {
      Timer(const Duration(seconds: 3), () {
        EventsService()
            .sendClickNextEvent("OnBoarding", "OnBoarding complete", "Home");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const MainPage(
                      selectedTab: 0,
                    )),
            (Route<dynamic> route) => false);
      });
    }
  }
}
