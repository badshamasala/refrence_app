import 'package:aayu/controller/player/audio_player_controller.dart';
import 'package:aayu/controller/player/content_preview_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/previous_subscription.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ContentAudioPreview extends StatefulWidget {
  final Content content;
  final double width;
  final double height;
  const ContentAudioPreview(
      {Key? key,
      required this.content,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  State<ContentAudioPreview> createState() => _ContentAudioPreviewState();
}

class _ContentAudioPreviewState extends State<ContentAudioPreview> {
  late AssetsAudioPlayer audioPlayer;
  bool showPlay = true;
  bool audioFinshed = false;
  bool userWantToExit = false;
  late AudioPlayerController audioPlayerController;
  DateTime startDate = DateTime.now();
  int playDuration = 60;

  @override
  void initState() {
    try {
      audioPlayerController = Get.put(AudioPlayerController());
      audioPlayerController.resetOptions();
      audioPlayer = AssetsAudioPlayer.newPlayer();
      audioPlayer.open(
        Audio.network(
          widget.content.contentPath!,
          metas: Metas(
            id: widget.content.contentId,
            title: widget.content.contentName,
            artist: widget.content.artist!.artistName!,
            image: MetasImage.network(
              widget.content.contentImage!,
            ),
          ),
        ),
        autoStart: true,
        showNotification: true,
        playInBackground: PlayInBackground.disabledRestoreOnForeground,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      );
      audioPlayer.playlistFinished.listen((event) {
        audioFinshed = event;
      });
    } catch (exp) {
      print("Exp => $exp");
      EventsService()
          .sendEvent("Audio_Player_Exception" + widget.content.contentType!, {
        "content_id": widget.content.contentId,
        "content_name": widget.content.contentName,
        "content_type": widget.content.contentType,
        "artist_name": widget.content.artist!.artistName!,
        "content_duration": widget.content.metaData!.duration,
        "exception": exp.toString()
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: widget.width.w,
          height: widget.height.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color.fromRGBO(0, 0, 0, 1).withOpacity(0.3),
                const Color.fromRGBO(0, 0, 0, 0).withOpacity(0.3),
              ],
            ),
          ),
        ),
        Center(
          child: Text(
            "You’re listening to a preview\nof the Premium version",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp),
          ),
        ),
        Positioned(
          bottom: 8.h,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              audioPlayer.builderRealtimePlayingInfos(
                builder: (context, RealtimePlayingInfos? infos) {
                  if (infos == null) {
                    return const Offstage();
                  }
                  if (infos.currentPosition.inMilliseconds >=
                      (playDuration * 1000)) {
                    audioPlayer.stop();
                    Future.delayed(Duration.zero, () {
                      ContentPreviewController contentPreviewController =
                          Get.find();
                      if (!(subscriptionCheckResponse != null &&
                              subscriptionCheckResponse!.subscriptionDetails !=
                                  null &&
                              subscriptionCheckResponse!.subscriptionDetails!
                                  .subscriptionId!.isNotEmpty) &&
                          widget.content.metaData!.isPremium == true) {
                        handleSubscriptionFlow(contentPreviewController);
                      } else {
                        contentPreviewController.stopContentPreview();
                      }
                    });
                    return const Offstage();
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFFAAFDB4),
                            inactiveTrackColor: const Color.fromRGBO(
                                196, 196, 196, 0.30000001192092896),
                            trackShape: const RoundedRectSliderTrackShape(),
                            trackHeight: 2.0,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6.0),
                            thumbColor: const Color(0xFFAAFDB4),
                            overlayColor: Colors.transparent,
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 8.0),
                            tickMarkShape: const RoundSliderTickMarkShape(),
                            activeTickMarkColor: AppColors.whiteColor,
                            inactiveTickMarkColor: Colors.black26,
                            valueIndicatorShape:
                                const PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: AppColors.whiteColor,
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            activeColor: const Color(0xFFAAFDB4),
                            inactiveColor:
                                AppColors.whiteColor.withOpacity(0.5),
                            value: infos.currentPosition.inSeconds.toDouble(),
                            min: 0,
                            max: (playDuration).toDouble(),
                            onChanged: (double value) {
                              audioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.ms().format(
                                DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  0,
                                  0,
                                  0,
                                  infos.currentPosition.inMilliseconds,
                                ),
                              ),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: const Color(0xFFD4DCE7),
                                fontFamily: 'Circular Std',
                                fontSize: 12.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              DateFormat.ms().format(
                                DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  0,
                                  0,
                                  0,
                                  (playDuration * 1000),
                                ),
                              ),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: const Color(0xFFD4DCE7),
                                fontFamily: 'Circular Std',
                                fontSize: 12.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
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
