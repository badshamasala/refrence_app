// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/chat_agora/chat_agora_controller.dart';
import 'package:aayu/controller/consultant/nutrition/nutrition_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/chat_agora/chat_screen.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class NavigationGrid extends StatelessWidget {
  const NavigationGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NutritionController nutritionController = Get.find();
    List activeTracker = [
      {
        "name": "Activity Tracker",
        "desp": "Track your daily\nactivities here.",
        "icon": "assets/images/nutrition/your-progress.png",
        "button_name": "Check now",
        "color": "#FBF7E7"
      },
      {
        "name": "Chat Now",
        "desp": "Your Nutritionist\nHere",
        "icon": "assets/images/nutrition/chaticon.png",
        "button_name": "Chat Now",
        "color": "#FFBEBA"
      }
    ];
    return GridView.builder(
      padding: pageHorizontalPadding(),
      shrinkWrap: true,
      primary: false,
      itemCount: activeTracker.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 130.h,
        crossAxisCount: 2,
        mainAxisSpacing: 30.w,
        crossAxisSpacing: 30.h,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.sp),
              shape: BoxShape.rectangle,
              color: HexColor(activeTracker[index]["color"]).withOpacity(0.3)),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30.h, left: 20.h),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeTracker[index]["name"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xff7B8C99),
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                          height: 1.18.h,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        activeTracker[index]["desp"],
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: const Color(0xff7B8C99),
                          fontSize: 13.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                          height: 1.16.h,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                foregroundColor: const Color(0xff3E3A93),
                                elevation: 0,
                                padding: EdgeInsets.only(right: 10.w),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () async {
                                if (activeTracker[index]["button_name"] ==
                                    "Chat Now") {
                                  EventsService().sendClickNextEvent(
                                      "NutritionHome", "Chat", "ChatScreen");
                                  ChatAgoraController chatAgoraController =
                                      Get.put(ChatAgoraController());
                                  buildShowDialog(context);
                                  await chatAgoraController.initSDK();
                                  await chatAgoraController.signIn();
                                  chatAgoraController.setConvId(
                                      nutritionController.userNutritionDetails
                                              .value?.currentTrainer?.coachId ??
                                          "");
                                  await chatAgoraController.getOldChat();
                                  chatAgoraController.addChatListener();
                                  Navigator.of(context).pop();
                                  Get.to(ChatScreen(
                                    coachName: nutritionController
                                            .userNutritionDetails
                                            .value
                                            ?.currentTrainer
                                            ?.coachName ??
                                        "",
                                    profilePhoto: nutritionController
                                            .userNutritionDetails
                                            .value
                                            ?.currentTrainer
                                            ?.profilePhoto ??
                                        "",
                                  ))!
                                      .then((value) {
                                    chatAgoraController.signOut();
                                  });
                                }
                              },
                              child: Text(
                                activeTracker[index]["button_name"],
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w700,
                                    height: 1.18.h,
                                    decoration: TextDecoration.underline),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: -20.h,
                  left: 90.w,
                  child: Image(
                    image: AssetImage(
                      activeTracker[index]["icon"],
                    ),
                    width: 40.w,
                    height: 40.h,
                  ))
            ],
          ),
        );
      },
    );
  }
}
