import 'package:aayu/controller/program/programme_controller.dart';
import 'package:aayu/controller/program/followup_assessment_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/view/healing/healing_list.dart';
import 'package:aayu/view/subscription/previous_subscription.dart';
import 'package:aayu/view/healing/programme/day_wise_programme.dart';
import 'package:aayu/view/healing/programme/day_zero.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Healing extends StatefulWidget {
  const Healing({Key? key}) : super(key: key);

  @override
  State<Healing> createState() => _HealingState();
}

class _HealingState extends State<Healing> {
  late Widget showWidget;
  @override
  void initState() {
    showWidget = showAayuHealing();
    checkProgrammeBuyed();
    super.initState();
  }

  checkProgrammeBuyed() async {
    try {
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        if (subscriptionCheckResponse!
            .subscriptionDetails!.programId!.isNotEmpty) {
          ProgrammeController programmeController = Get.put(ProgrammeController(
              subscriptionCheckResponse!.subscriptionDetails!.canStartProgram ??
                  false));
          if (subscriptionCheckResponse!.subscriptionDetails!.canStartProgram ==
              true) {
            if (programmeController.todaysContent.value == null ||
                programmeController.healingProgrammeContent.value == null) {
              await programmeController.getDayWiseProgramContent();
            }
            Get.put(FollowupAssessmentController());
            setState(() {
              showWidget = const DayWiseProgramme();
            });
          } else {
            if (programmeController.dayZeroContent.value == null) {
              await programmeController.getDayZeroContent();
            }
            setState(() {
              showWidget = const DayZero();
            });
          }
        } else {
          setState(() {
            showWidget = const HealingList();
          });
        }
      } else {
        //DONT REMOVE Future.delayed
        Future.delayed(Duration.zero, () async {
          SubscriptionController subscriptionController =
              Get.put(SubscriptionController());
          await subscriptionController.getPreviousSubscriptionDetails();
          if (subscriptionController.previousSubscriptionDetails.value !=
                  null &&
              subscriptionController
                      .previousSubscriptionDetails.value!.subscriptionDetails !=
                  null) {
            setState(() {
              showWidget = const PreviousSubscription(allowBackPress: false);
            });
          } else {
            setState(() {
              showWidget = const HealingList();
            });
          }
        });
      }
    } catch (e) {
      setState(() {
        showWidget = const HealingList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showWidget,
    );
  }
}
