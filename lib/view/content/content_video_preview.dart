import 'package:aayu/controller/player/content_preview_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:aayu/view/subscription/previous_subscription.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:path/path.dart' as path;

class ContentVideoPreview extends StatefulWidget {
  final Content content;

  const ContentVideoPreview({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  State<ContentVideoPreview> createState() => _ContentVideoPreviewState();
}

class _ContentVideoPreviewState extends State<ContentVideoPreview> {
  late BetterPlayerController betterPlayerController;
  late BetterPlayerConfiguration betterPlayerConfiguration;
  Color activeColor = const Color(0xFFAAFDB4);

  @override
  void initState() {
    try {
      print(
          "--------Video Player Content--------\nContent Id - ${widget.content.contentId}\nContent Name - ${widget.content.contentName}\nContent Path - ${widget.content.contentPath}\nArtist Name - ${widget.content.artist!.artistName}");
      initializeBetterPlayer();
    } catch (exp) {}
    super.initState();
  }

  initializeBetterPlayer() async {
    try {
      betterPlayerConfiguration = BetterPlayerConfiguration(
        fit: BoxFit.contain,
        autoPlay: true,
        aspectRatio: 16 / 9,
        showPlaceholderUntilPlay: false,
        autoDetectFullscreenAspectRatio: false,
        autoDetectFullscreenDeviceOrientation: false,
        fullScreenByDefault: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        controlsConfiguration: BetterPlayerControlsConfiguration(
          controlBarColor: Colors.black38,
          enablePip: true,
          enableProgressBarDrag: true,
          enableProgressBar: true,
          showControlsOnInitialize: false,
          iconsColor: activeColor,
          enablePlaybackSpeed: false,
          loadingColor: activeColor,
          enableFullscreen: true,
          enableSkips: false,
          enableMute: false,
          controlBarHeight: 24.h,
          progressBarPlayedColor: activeColor,
          enableOverflowMenu: false,
          enablePlayPause: false,
          enableQualities: false,
          enableRetry: false,
          progressBarBackgroundColor: AppColors.whiteColor.withOpacity(0.4),
          enableSubtitles: false,
          enableAudioTracks: false,
          overflowMenuCustomItems: [],
        ),
        allowedScreenSleep: false,
        autoDispose: true,
      );
      betterPlayerController =
          BetterPlayerController(betterPlayerConfiguration);
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, widget.content.contentPath!,
          useAsmsSubtitles: false, overriddenDuration: Duration(seconds: 120));

      if (path.extension(widget.content.contentPath!) == ".m3u8") {
        dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network, widget.content.contentPath!,
            videoFormat: BetterPlayerVideoFormat.hls,
            useAsmsSubtitles: false,
            overriddenDuration: Duration(seconds: 120));
      } else {
        dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network, widget.content.contentPath!,
            useAsmsSubtitles: false,
            overriddenDuration: Duration(seconds: 120));
      }
      betterPlayerController.setupDataSource(dataSource);
      betterPlayerController.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
          ContentPreviewController contentPreviewController = Get.find();
          betterPlayerController.exitFullScreen();
          if (!(subscriptionCheckResponse != null &&
                  subscriptionCheckResponse!.subscriptionDetails != null &&
                  subscriptionCheckResponse!
                      .subscriptionDetails!.subscriptionId!.isNotEmpty) &&
              widget.content.metaData!.isPremium == true) {
            handleSubscriptionFlow(contentPreviewController);
          } else {
            contentPreviewController.stopContentPreview();
          }
        } else if (event.betterPlayerEventType ==
            BetterPlayerEventType.initialized) {}
      });
    } catch (error) {}
  }

  @override
  void dispose() {
    try {
      betterPlayerController.dispose();
    } catch (error) {
      print("Video_Player_Exception => $error");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(
      controller: betterPlayerController,
    );
  }

  handleSubscriptionFlow(
      ContentPreviewController contentPreviewController) async {
    buildShowDialog(context);
    SubscriptionController subscriptionController = Get.find();
    await subscriptionController.getPreviousSubscriptionDetails();
    Navigator.pop(context);
    contentPreviewController.stopContentPreview();
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
          SubscribeToAayu(subscribeVia: "CONTENT", content: widget.content),
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
        );
      }
    }
  }
}