// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/psychologist/psychology_recommened_content_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/content_details/content_details.dart';
import 'package:aayu/view/player/audio_play_list.dart';
import 'package:aayu/view/player/video_player.dart';
import 'package:aayu/view/search/widgets/content_search_tile.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/previous_subscription.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecommendedPsychologistContent extends StatelessWidget {
  const RecommendedPsychologistContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PsychologyRecommendedContentController>(
        id: "recommendedContent",
        builder: (controller) {
          if (controller.recommendedContent.value == null) {
            return const Offstage();
          } else if (controller.recommendedContent.value?.content == null) {
            return const Offstage();
          } else if (controller.recommendedContent.value!.content!.isEmpty) {
            return const Offstage();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 26.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Complete any two activities",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      PsychologyRecommendedContentController
                          psychologyRecommendedContentController = Get.find();
                      psychologyRecommendedContentController.shuffleContent();
                    },
                    child: Text(
                      "Shuffle",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF94E79F),
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  )
                ],
              ),
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.recommendedContent.value!.content!.length,
                itemBuilder: (BuildContext context, index) {
                  return ContentSearchTile(
                      onTapFunction: () {
                        if (!(subscriptionCheckResponse != null &&
                                subscriptionCheckResponse!
                                        .subscriptionDetails !=
                                    null &&
                                subscriptionCheckResponse!.subscriptionDetails!
                                    .subscriptionId!.isNotEmpty) &&
                            controller.recommendedContent.value!
                                    .content![index]!.metaData!.isPremium ==
                                true) {
                          handleSubscriptionFlow(
                              context,
                              controller
                                  .recommendedContent.value!.content![index]!);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContentDetails(
                                source: "",
                                heroTag:
                                    "SearchResult_${controller.recommendedContent.value!.content![index]!.contentId!}",
                                contentId: controller.recommendedContent.value!
                                    .content![index]!.contentId!,
                                categoryContent: controller
                                    .recommendedContent.value!.content!,
                              ),
                            ),
                          ).then((value) {
                            EventsService().sendClickBackEvent(
                                "ContentDetails", "Back", "Favourites");
                          });
                        }
                      },
                      content:
                          controller.recommendedContent.value!.content![index]!,
                      favouriteAction: null,
                      playAction: () {
                        bool isSubscribed = false;
                        if (subscriptionCheckResponse != null &&
                            subscriptionCheckResponse!.subscriptionDetails !=
                                null &&
                            subscriptionCheckResponse!.subscriptionDetails!
                                .subscriptionId!.isNotEmpty) {
                          isSubscribed = true;
                        }

                        if (controller.recommendedContent.value!
                                    .content![index]!.metaData!.isPremium ==
                                true &&
                            isSubscribed == false) {
                          handleSubscriptionFlow(
                              context,
                              controller
                                  .recommendedContent.value!.content![index]!);
                        } else {
                          if (controller.recommendedContent.value!
                                  .content![index]!.contentType ==
                              "Video") {
                            if (controller.recommendedContent.value!
                                        .content![index]!.contentPath !=
                                    null &&
                                controller.recommendedContent.value!
                                    .content![index]!.contentPath!.isNotEmpty) {
                              EventsService().sendClickNextEvent(
                                  "Favourites", "Play", "VideoPlayer");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayer(
                                    content: controller.recommendedContent
                                        .value!.content![index]!,
                                  ),
                                ),
                              ).then((value) {
                                EventsService().sendClickBackEvent(
                                    "VideoPlayer", "Back", "Favourites");
                              });
                            } else {
                              showGetSnackBar("CONTENT_NOT_AVAIALBLE".tr,
                                  SnackBarMessageTypes.Info);
                            }
                          } else if (controller.recommendedContent.value!
                                      .content![index]!.contentType ==
                                  "Audio" ||
                              controller.recommendedContent.value!
                                      .content![index]!.contentType ==
                                  "Music") {
                            if (controller.recommendedContent.value!
                                        .content![index]!.contentPath !=
                                    null &&
                                controller.recommendedContent.value!
                                    .content![index]!.contentPath!.isNotEmpty) {
                              EventsService().sendClickNextEvent(
                                  "Favourites", "Play", "AudioPlayer");

                              List<Content?> audioPlayList = [];
                              if (subscriptionCheckResponse != null &&
                                  subscriptionCheckResponse!
                                          .subscriptionDetails !=
                                      null) {
                                audioPlayList = controller
                                    .recommendedContent.value!.content!
                                    .where(
                                      (element) =>
                                          (element!.contentType == "Audio" ||
                                              element.contentType == "Music"),
                                    )
                                    .toList();
                              } else {
                                audioPlayList = controller
                                    .recommendedContent.value!.content!
                                    .where(
                                      (element) =>
                                          (element!.contentType == "Audio" ||
                                              element.contentType == "Music") &&
                                          element.metaData!.isPremium == false,
                                    )
                                    .toList();
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AudioPlayList(
                                    heroTag:
                                        "SearchResult_${controller.recommendedContent.value!.content![index]!.contentId}",
                                    playContentId: controller.recommendedContent
                                        .value!.content![index]!.contentId!,
                                    categoryContent: audioPlayList,
                                  ),
                                ),
                              ).then((value) {
                                EventsService().sendClickBackEvent(
                                    "AudioPlayList", "Back", "SearchResult");
                              });
                            } else {
                              showGetSnackBar("CONTENT_NOT_AVAIALBLE".tr,
                                  SnackBarMessageTypes.Info);
                            }
                          }
                        }
                      });
                },
                separatorBuilder: (BuildContext context, index) {
                  return const Divider(
                    thickness: 1,
                    height: 0,
                    color: Color.fromRGBO(196, 196, 196, 0.3),
                  );
                },
              )
            ],
          );
        });
  }

  handleSubscriptionFlow(BuildContext context, Content content) async {
    buildShowDialog(context);
    SubscriptionController subscriptionController = Get.find();
    await subscriptionController.getPreviousSubscriptionDetails();
    Navigator.pop(context);
    if (subscriptionController.previousSubscriptionDetails.value != null &&
        subscriptionController
                .previousSubscriptionDetails.value!.subscriptionDetails !=
            null) {
      EventsService()
          .sendClickNextEvent("Content", "Play", "PreviousSubscription");
      Get.bottomSheet(
        const PreviousSubscription(),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
      );
    } else {
      bool isAllowed = await checkIsPaymentAllowed("GROW");
      if (isAllowed == true) {
        EventsService()
            .sendClickNextEvent("Content", "Play", "SubscribeToAayu");
        Get.bottomSheet(
          SubscribeToAayu(subscribeVia: "CONTENT", content: content),
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
        );
      }
    }
  }
}
