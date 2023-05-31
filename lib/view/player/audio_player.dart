import 'dart:io';

import 'package:aayu/controller/player/audio_player_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wakelock/wakelock.dart';

class AudioPlayer extends StatefulWidget {
  final String heroTag;
  final Content content;
  final int? day;
  final String? growCategoryName;
  const AudioPlayer(
      {Key? key,
      required this.heroTag,
      required this.content,
      this.day = -1,
      this.growCategoryName})
      : super(key: key);

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> with WidgetsBindingObserver {
  late AssetsAudioPlayer audioPlayer;
  bool showPlay = true;
  bool audioFinshed = false;
  late AudioPlayerController audioPlayerController;
  DateTime startDate = DateTime.now();
  TextEditingController commentsTextController = TextEditingController();
  bool showRatingPopup = true;
  @override
  void initState() {
    try {
      print(
          "--------Audio Player Content--------\nContent Id - ${widget.content.contentId}\nContent Name - ${widget.content.contentName}\nContent Path - ${widget.content.contentPath}\nBG Image - ${widget.content.playBGImage}\nArtist Name - ${widget.content.artist!.artistName}");
      WidgetsBinding.instance.addObserver(this);

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
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      );

      audioPlayer.isPlaying.listen((event) {
        if (mounted) {
          setState(() {
            showPlay = event;
          });
        }
      });

      audioPlayer.playlistFinished.listen((event) {
        audioFinshed = event;
        print("-----------audioFinshed------------");
        print(audioFinshed);
        if (event == true) {
          if (audioPlayerController.contentRatingAvailable.value == false) {
            if (showRatingPopup == true) {
              if (mounted) {
                showContentRatingPopUp();
                setState(() {
                  showRatingPopup = false;
                });
              }
            }
          }
          if (mounted) {
            EventsService()
                .sendEvent("Content_Completed_${widget.content.contentType!}", {
              "content_id": widget.content.contentId,
              "content_name": widget.content.contentName,
              "content_type": widget.content.contentType,
              "artist_name": widget.content.artist!.artistName!,
              "content_duration": widget.content.metaData!.duration,
            });
            audioPlayerController.postContentCompletion(
                widget.content.contentId!, widget.day!);
          }
        }
      });
      if (widget.day == -1) {
        audioPlayerController.postRecentContent(widget.content.contentId!);
      }
      Wakelock.enable();
      audioPlayerController.updateContentRating(-1);
      audioPlayerController.getContentRating(widget.content.contentId!);
    } catch (exp) {
      print("Exp => $exp");
      EventsService()
          .sendEvent("Audio_Player_Exception${widget.content.contentType!}", {
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
    Wakelock.disable();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        sendContentCompletedEvent();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: null,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              size: 20,
              color: AppColors.whiteColor,
            ),
          ),
          actions: [
            InkWell(
              child: SvgPicture.asset(
                AppIcons.shareSVG,
                width: 17.w,
                height: 17.h,
                color: AppColors.whiteColor,
              ),
              onTap: () async {
                buildShowDialog(context);
                await ShareService().shareContent(
                    widget.content.contentId!, widget.content.contentImage!);
                EventsService().sendEvent("Grow_Content_Share", {
                  "content_id": widget.content.contentId!,
                  "content_name": widget.content.contentName!,
                  "artist_name": widget.content.artist!.artistName!,
                  "content_type": widget.content.contentType!,
                });
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 26.w,
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                tag: widget.heroTag,
                child: ShowNetworkImage(
                  imgPath: widget.content.playBGImage!,
                  imgWidth: MediaQuery.of(context).size.width,
                  imgHeight: MediaQuery.of(context).size.height,
                  boxFit: BoxFit.cover,
                  placeholderImage:
                      "assets/images/placeholder/default_player_screen.jpg",
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
              Positioned(
                bottom: 48.h,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        widget.content.contentName!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: 'Baskerville',
                          fontSize: 24.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.1666666666666667.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 13.h,
                    ),
                    Visibility(
                      visible: widget.content.artist!.artistName != null &&
                          widget.content.artist!.artistName!.isNotEmpty,
                      child: SizedBox(
                        height: 43.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 32.w,
                            ),
                            Expanded(
                              child: Text(
                                widget.content.artist!.artistName ?? "",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.whiteColor.withOpacity(0.5),
                                  fontFamily: 'Circular Std',
                                  fontSize: 12.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1.3333333333333333.h,
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40.w),
                              child: ShowNetworkImage(
                                imgWidth: 40.h,
                                imgHeight: 40.h,
                                imgPath: widget.content.artist!.artistImage!,
                                boxFit: BoxFit.cover,
                                placeholderImage:
                                    "assets/images/placeholder.jpg",
                              ),
                            ),
                            SizedBox(
                              width: 32.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    audioPlayer.builderRealtimePlayingInfos(
                      builder: (context, RealtimePlayingInfos? infos) {
                        if (infos == null) {
                          return const Offstage();
                        } else if (audioFinshed == true) {
                          return const Offstage();
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 26.w),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: const Color(0xFFAAFDB4),
                                  inactiveTrackColor: const Color.fromRGBO(
                                      196, 196, 196, 0.30000001192092896),
                                  trackShape:
                                      const RoundedRectSliderTrackShape(),
                                  trackHeight: 2.0,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8.0),
                                  thumbColor: const Color(0xFFAAFDB4),
                                  overlayColor: Colors.transparent,
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 8.0),
                                  tickMarkShape:
                                      const RoundSliderTickMarkShape(),
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
                                  value: infos.currentPosition.inSeconds
                                      .toDouble(),
                                  min: 0,
                                  max: infos.duration.inSeconds.toDouble() +
                                      1, //added 0.1 to avoid slider error
                                  onChanged: (double value) {
                                    audioPlayer
                                        .seek(Duration(seconds: value.toInt()));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      fontSize: 14.sp,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w700,
                                      height: 1.6.h,
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
                                        infos.duration.inMilliseconds,
                                      ),
                                    ),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: const Color(0xFFD4DCE7),
                                      fontFamily: 'Circular Std',
                                      fontSize: 14.sp,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w700,
                                      height: 1.6.h,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: SvgPicture.asset(
                              AppIcons.refreshSVG,
                              width: 24.w,
                              height: 24.h,
                              color: const Color(0xFFAAFDB4),
                            ),
                            onTap: () {
                              audioPlayer.seek(const Duration(seconds: 0),
                                  force: true);
                            },
                          ),
                          SizedBox(
                            width: 40.w,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (showPlay == false) {
                                  showPlay = true;
                                  if (audioFinshed == true) {
                                    showRatingPopup = true;
                                  }
                                  audioPlayer.play();
                                } else {
                                  showPlay = false;
                                  audioPlayer.pause();
                                }
                              });
                            },
                            child: (showPlay == true)
                                ? Container(
                                    height: 54.h,
                                    width: 54.w,
                                    padding: EdgeInsets.zero,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFAAFDB4),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.pause,
                                      size: 24,
                                      color: AppColors.blackColor,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    AppIcons.playSVG,
                                    width: 54.w,
                                    height: 54.h,
                                    color: const Color(0xFFAAFDB4),
                                  ),
                          ),
                          SizedBox(
                            width: 40.w,
                          ),
                          InkWell(
                            child: SvgPicture.asset(
                              widget.content.isFavourite == true
                                  ? AppIcons.favouriteFillSVG
                                  : AppIcons.favouriteSVG,
                              width: 24.w,
                              height: 24.h,
                              color: const Color(0xFFAAFDB4),
                            ),
                            onTap: () async {
                              EventsService().sendEvent(
                                  widget.content.isFavourite! == true
                                      ? "Grow_Content_Unfavourite"
                                      : "Grow_Content_Favourite",
                                  {
                                    "content_id": widget.content.contentId!,
                                    "content_name": widget.content.contentName!,
                                    "artist_name":
                                        widget.content.artist!.artistName!,
                                    "content_type": widget.content.contentType!,
                                  });

                              buildShowDialog(context);
                              bool isFavourite =
                                  await audioPlayerController.favouriteContent(
                                      widget.content.contentId!,
                                      !widget.content.isFavourite!);
                              Navigator.pop(context);

                              if (isFavourite == true) {
                                setState(() {
                                  widget.content.isFavourite =
                                      !widget.content.isFavourite!;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 23.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showContentRatingPopUp() {
    Get.bottomSheet(
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 10.h,
              top: 40.h,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'HOW_WAS_IT_FOR_YOU'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: 'Circular Std',
                    fontSize: 20,
                    letterSpacing: 0.20000000298023224,
                    fontWeight: FontWeight.normal,
                    height: 1.2.h,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                      GetBuilder<AudioPlayerController>(builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) {
                          return InkWell(
                            onTap: () async {
                              controller.updateContentRating(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 18),
                              child: SvgPicture.asset(
                                (index <= controller.contentRating)
                                    ? AppIcons.ratingFilledSVG
                                    : AppIcons.ratingUnfilledSVG,
                                width: 40,
                                height: 40,
                                color: const Color(0xFFAAFDB4),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, top: 5.h, bottom: 5.h),
                  margin: EdgeInsets.only(
                    left: 40.w,
                    right: 40.w,
                    bottom: 26.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(64, 117, 205, 0.08),
                        offset: Offset(0, 10),
                        blurRadius: 20,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: commentsTextController,
                    style: AppTheme.inputEditProfileTextStyle,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      hintStyle: AppTheme.hintTextStyle,
                      errorStyle: AppTheme.errorTextStyle,
                      hintText: 'Review',
                      labelStyle: AppTheme.hintTextStyle,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.whiteColor,
                      focusColor: AppColors.whiteColor,
                      hoverColor: AppColors.whiteColor,
                      errorBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.errorColor, width: 3),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                GetBuilder<AudioPlayerController>(builder: (buttonController) {
                  return InkWell(
                    onTap: buttonController.contentRating >= 0
                        ? () async {
                            await audioPlayerController.postContentRating(
                                widget.content.contentId!,
                                commentsTextController.text);

                            EventsService()
                                .sendEvent("Content_Rating_Clicked", {
                              "content_id": widget.content.contentId,
                              "content_name": widget.content.contentName,
                              "content_type": widget.content.contentType,
                              "artist_name": widget.content.artist!.artistName!,
                              "content_duration":
                                  widget.content.metaData!.duration,
                              "content_rating":
                                  audioPlayerController.contentRating + 1,
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        : null,
                    child: SizedBox(
                      width: 200.w,
                      child: Container(
                        height: 54.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: buttonController.contentRating >= 0
                              ? const Color(0xFFAAFDB4)
                              : const Color(0xFFAAFDB4).withOpacity(0.5),
                          boxShadow: buttonController.contentRating >= 0
                              ? const [
                                  BoxShadow(
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.07000000029802322),
                                      offset: Offset(-5, 10),
                                      blurRadius: 20),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blackLabelColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                              fontFamily: "Circular Std",
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 70.h,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  audioPlayer.play();
                },
                child: SvgPicture.asset(
                  AppIcons.replaySVG,
                  width: 54,
                  height: 54,
                  color: const Color(0xFFAAFDB4),
                ),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
    );
  }

  sendContentCompletedEvent() {
    int playDuration = DateTime.now().difference(startDate).inSeconds;
    dynamic eventData = {
      "user_id": globalUserIdDetails?.userId,
      "content_id": widget.content.contentId,
      "content_name": widget.content.contentName,
      "content_type": widget.content.contentType,
      "content_duration": widget.content.metaData!.duration!,
      "artist_id": widget.content.artist!.artistId!,
      "artist_name": widget.content.artist!.artistName!,
      "play_duration": playDuration,
      "content_finished": audioFinshed,
      "grow_category": widget.growCategoryName,
    };

    EventsService().sendEvent("Grow_Content_Viewed", eventData);
  }
}
