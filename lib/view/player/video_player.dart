import 'dart:async';
import 'package:aayu/controller/player/video_player_controller.dart';
import 'package:aayu/controller/program/programme_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import 'package:path/path.dart' as path;

import '../../controller/casting/cast_controller.dart';

class VideoPlayer extends StatefulWidget {
  final String source;
  final Content content;
  final String? growCategoryName;
  final int? day;

  const VideoPlayer({
    Key? key,
    this.source = "Grow",
    this.growCategoryName,
    required this.content,
    this.day = -1,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late BetterPlayerController betterPlayerController;
  late BetterPlayerConfiguration betterPlayerConfiguration;
  late VideoPlayerController videoPlayerController;
  bool videoFinished = false;
  Color activeColor = const Color(0xFFAAFDB4);

  late AnimationController animationController;
  bool isInitialzed = false;
  DateTime startDate = DateTime.now();

  List<Map<String, Object>> exitOptions = [
    {
      "text": "I am in discomfort",
      "selected": false,
      "popPage": true,
    },
    {
      "text": "Something urgent came up",
      "selected": false,
      "popPage": true,
    },
    {
      "text": "The program can be better",
      "selected": false,
      "popPage": true,
    },
    {
      "text": "Resume playing",
      "selected": false,
      "popPage": false,
    }
  ];

  TextEditingController commentsTextController = TextEditingController();

  @override
  void initState() {
    try {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 28),
      );

      print(
          "--------Video Player Content--------\nContent Id - ${widget.content.contentId}\nContent Name - ${widget.content.contentName}\nContent Path - ${widget.content.contentPath}\nArtist Name - ${widget.content.artist!.artistName}");
      WidgetsBinding.instance.addObserver(this);
      videoPlayerController = Get.put(VideoPlayerController());
      initializeBetterPlayer();
      if (widget.day == -1) {
        videoPlayerController.postRecentContent(widget.content.contentId!);
      }
      Wakelock.enable();
      videoPlayerController.updateContentRating(-1);
      videoPlayerController.getContentRating(widget.content.contentId!);
    } catch (exp) {
      print("Video_Player_Exception => $exp");
      EventsService()
          .sendEvent("Video_Player_Exception_${widget.content.contentType!}", {
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

  handleCasting(CastController castController) {
    castController.switchShowControls(false);
    castController.searchCastDevices();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Obx(() {
          if (castController.isSearching.value == true) {
            return Container(
              height: 100,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Finding Nearby Devices',
                    style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const LinearProgressIndicator(),
                ],
              ),
            );
          }
          if (castController.showControls.value == true) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          castController.minus10();
                        },
                        icon: const Icon(Icons.replay_10, size: 30)),
                    IconButton(
                        onPressed: () {
                          castController.pauseVideo();
                        },
                        icon: Icon(
                          castController.playerState.value ==
                                  PlayerState.PLAYING
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {
                          castController.plus10();
                        },
                        icon: const Icon(Icons.forward_10, size: 30)),
                  ],
                ),
              ],
            );
          }
          return Stack(children: [
            Container(
              constraints: const BoxConstraints(minHeight: 100),
              child: castController.listCastdDevices!.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        const Text(
                          'No Devices Found',
                          style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 9.h)),
                                onPressed: () async {
                                  castController.switchShowControls(false);
                                  castController.searchCastDevices();
                                },
                                child: const Text(
                                  'Scan Again',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Circular Std"),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: castController.listCastdDevices!.map((device) {
                        return ListTile(
                          title: Text(device.name),
                          onTap: () {
                            castController
                                .connectAndPlayMedia(
                                    context,
                                    device,
                                    widget.content,
                                    widget.day == null || widget.day == -1
                                        ? null
                                        : "${subscriptionCheckResponse!.subscriptionDetails!.diseaseName ?? ""} - Day ${widget.day ?? 0}")
                                .then((value) {
                              castController.switchShowControls(true);
                            });
                          },
                        );
                      }).toList()),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackAssessmentColor,
                    size: 25,
                  )),
            )
          ]);
        }),
      ),
    ).then((value) {
      castController.closeSession();
    });
  }

  initializeBetterPlayer() async {
    CastController castController = Get.put(CastController());
    try {
      betterPlayerConfiguration = BetterPlayerConfiguration(
        fit: BoxFit.contain,
        autoPlay: true,
        aspectRatio: 16 / 9,
        showPlaceholderUntilPlay: false,
        autoDetectFullscreenAspectRatio: true,
        autoDetectFullscreenDeviceOrientation: true,
        fullScreenByDefault: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        routePageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, provider) {
          return BetterPlayerCustomRoute(
            handlecasting: () {
              handleCasting(castController);
            },
            animation: animation,
            provider: provider,
            activeColor: activeColor,
            popFunction: () {
              if (widget.source == "Healing Program" && widget.day! > 0) {
                _willPop(context, true);
              } else {
                betterPlayerController.exitFullScreen();
                Navigator.pop(context);
              }
            },
          );
        },
        controlsConfiguration: BetterPlayerControlsConfiguration(
          controlBarColor: Colors.black38,
          enablePip: true, //used for PIP Mode
          showControlsOnInitialize: false,
          iconsColor: activeColor,
          enablePlaybackSpeed: true,
          loadingColor: activeColor,
          enableFullscreen: true,
          enableSkips: true,
          progressBarPlayedColor: activeColor,
          progressBarBackgroundColor: AppColors.whiteColor.withOpacity(0.4),
          enableSubtitles: false,
          enableAudioTracks: false,

          overflowMenuCustomItems: [
            BetterPlayerOverflowMenuItem(
              Icons.cancel_rounded,
              "EXIT_PLAYING".tr,
              () {
                if (widget.source == "Healing Program" && widget.day! > 0) {
                  _willPop(context, true);
                } else {
                  betterPlayerController.exitFullScreen();
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
        allowedScreenSleep: false,
        autoDispose: true,
      );
      betterPlayerController =
          BetterPlayerController(betterPlayerConfiguration);

      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.content.contentPath!,
        useAsmsSubtitles: false,
      );

      if (path.extension(widget.content.contentPath!) == ".m3u8") {
        dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.content.contentPath!,
          videoFormat: BetterPlayerVideoFormat.hls,
          useAsmsSubtitles: false,
        );
      } else {
        dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.content.contentPath!,
          useAsmsSubtitles: false,
        );
      }

      betterPlayerController.setupDataSource(dataSource);

      betterPlayerController.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
          setState(() {
            String programId = "";
            if (subscriptionCheckResponse != null &&
                subscriptionCheckResponse!.subscriptionDetails != null) {
              programId =
                  subscriptionCheckResponse!.subscriptionDetails!.programId!;
            }

            videoFinished = true;
            videoPlayerController.postContentCompletion(
                widget.content.contentId!, widget.day!, programId);

            if (widget.source == "Healing Program" && widget.day == 0) {
              //Dont ask for rating.
            } else {
              if (videoPlayerController.contentRatingAvailable.value == false) {
                showContentRatingPopUp();
              }
            }

            if (widget.source == "Healing Program") {
              videoPlayerController.updateContentViewStatus(
                subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
                programId,
                widget.day.toString(),
              );
            }
          });

          sendContentViewEvent();
        } else if (event.betterPlayerEventType ==
            BetterPlayerEventType.initialized) {
          betterPlayerController.enterFullScreen();
          setState(() {
            isInitialzed = true;
          });
        }
      });
    } catch (error) {
      print("Video_Player_Exception => $error");
      EventsService()
          .sendEvent("Video_Player_Exception${widget.content.contentType!}", {
        "content_id": widget.content.contentId,
        "content_name": widget.content.contentName,
        "content_type": widget.content.contentType,
        "artist_name": widget.content.artist!.artistName!,
        "content_duration": widget.content.metaData!.duration,
        "exception": error.toString()
      });
    }
  }

  @override
  void dispose() {
    try {
      Wakelock.disable();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      WidgetsBinding.instance.removeObserver(this);
    } catch (error) {
      print("Video_Player_Exception => $error");
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        betterPlayerController.play();

        break;
      case AppLifecycleState.inactive:
        betterPlayerController.pause();

        break;
      case AppLifecycleState.paused:
        betterPlayerController.pause();

        break;
      case AppLifecycleState.detached:
        betterPlayerController.pause();

        break;
    }
  }

  showContentRatingPopUp() {
    Get.bottomSheet(
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: 26,
              top: 26,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.of(context).pop({"videoFinished": true});
                },
                child: const Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                  size: 32,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
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
                    child: GetBuilder<VideoPlayerController>(
                        builder: (controller) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 18),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await controller.updateContentRating(index);
                                },
                                child: SvgPicture.asset(
                                  (index <= controller.contentRating)
                                      ? AppIcons.ratingFilledSVG
                                      : AppIcons.ratingUnfilledSVG,
                                  width: 40,
                                  height: 40,
                                  color: activeColor,
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
                  InkWell(
                    onTap: () async {
                      await videoPlayerController.postContentRating(
                          widget.content.contentId!,
                          commentsTextController.text);
                      EventsService().sendEvent("Content_Rating_Clicked", {
                        "content_id": widget.content.contentId,
                        "content_name": widget.content.contentName,
                        "content_type": widget.content.contentType,
                        "artist_name": widget.content.artist!.artistName!,
                        "content_duration": widget.content.metaData!.duration,
                        "content_rating":
                            videoPlayerController.contentRating + 1,
                      });
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.of(context).pop({"videoFinished": true});
                    },
                    child: SizedBox(
                      width: 200,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: activeColor,
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(
                                    0, 0, 0, 0.07000000029802322),
                                offset: Offset(-5, 10),
                                blurRadius: 20),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blackLabelColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              fontFamily: "Circular Std",
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 32,
              bottom: 32,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    startDate = DateTime.now();
                    videoFinished = false;
                    Navigator.pop(context);
                    betterPlayerController.seekTo(const Duration(seconds: 0));
                    betterPlayerController.play();
                  });
                },
                child: SvgPicture.asset(
                  AppIcons.replaySVG,
                  width: 54,
                  height: 54,
                  color: activeColor,
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPop(context, false),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BetterPlayer(
          controller: betterPlayerController,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: (isInitialzed == true)
            ? IconButton(
                onPressed: () {
                  _willPop(context, true);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: activeColor,
                ),
              )
            : null,
      ),
    );
  }

  Future<bool> _willPop(BuildContext context, removePopUp) async {
    final completer = Completer<bool>();

    if (videoFinished == true) {
      completer.complete(true);
      Navigator.of(context).pop({"videoFinished": true});
    } else if (widget.source == "Healing Program" && widget.day == 0) {
      completer.complete(true);
      sendContentViewEvent();
      Navigator.of(context).pop({"videoFinished": videoFinished});
    } else if (widget.source == "Healing Program" && widget.day! > 0) {
      betterPlayerController.pause();
      Get.bottomSheet(
        Center(
          child: Container(
            padding: EdgeInsets.zero,
            width: 318,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'LEAVING_MIDWAY'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: 'Circular Std',
                    fontSize: 20,
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.normal,
                    height: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                Text(
                  'PLEASE_TELL_US_WHY'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF1F1F1),
                    fontFamily: 'Circular Std',
                    fontSize: 14,
                    letterSpacing: 0.20000000298023224,
                    fontWeight: FontWeight.normal,
                    height: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    exitOptions.length,
                    (index) {
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () async {
                          if (exitOptions[index]["popPage"] == true) {
                            EventsService().sendEvent("Leaving_Midway_Video", {
                              "content_id": widget.content.contentId,
                              "content_name": widget.content.contentName,
                              "content_type": widget.content.contentType,
                              "artist_name": widget.content.artist!.artistName!,
                              "content_duration":
                                  widget.content.metaData!.duration,
                              "reason": exitOptions[index]["text"],
                            });

                            betterPlayerController.exitFullScreen();
                            completer.complete(
                                exitOptions[index]["popPage"] as bool);
                            sendContentViewEvent();

                            if (removePopUp == true) {
                              Navigator.of(context).pop();
                            }
                            Navigator.of(context).pop({"videoFinished": false});
                            //});
                          } else {
                            betterPlayerController.play();
                            completer.complete(
                                exitOptions[index]["popPage"] as bool);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          height: 48,
                          width: 286,
                          margin: EdgeInsets.only(bottom: 10.h),
                          decoration: (exitOptions[index]["popPage"] == false)
                              ? null
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.w),
                                  color: exitOptions[index]["selected"] == true
                                      ? activeColor
                                      : const Color(0xFFDADADD),
                                ),
                          child: Center(
                            child: Text(
                              exitOptions[index]["text"].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: exitOptions[index]["selected"] == true
                                    ? AppColors.whiteColor
                                    : exitOptions[index]["popPage"] == false
                                        ? activeColor
                                        : AppColors.secondaryLabelColor,
                                fontFamily: 'Circular Std',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
      );
    } else {
      completer.complete(true);
      sendContentViewEvent();
      Navigator.of(context).pop({"videoFinished": videoFinished});
    }

    return completer.future;
  }

  sendContentViewEvent() {
    if (widget.source == "Healing Program") {
      ProgrammeController programmeController = Get.find();
      programmeController.sendProgramContentViewEvent(
          widget.day!, widget.content, videoFinished, startDate);
    } else {
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
        "content_finished": videoFinished,
        "grow_category": widget.growCategoryName
      };

      EventsService().sendEvent("Grow_Content_Viewed", eventData);
    }
  }
}

class BetterPlayerCustomRoute extends StatefulWidget {
  final Animation<double> animation;
  final BetterPlayerControllerProvider provider;
  final Function popFunction;
  final Color activeColor;
  final Function? handlecasting;

  const BetterPlayerCustomRoute({
    Key? key,
    required this.animation,
    required this.provider,
    required this.popFunction,
    required this.activeColor,
    required this.handlecasting,
  }) : super(key: key);

  @override
  _BetterPlayerCustomRouteState createState() =>
      _BetterPlayerCustomRouteState();
}

class _BetterPlayerCustomRouteState extends State<BetterPlayerCustomRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animation,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(children: [
              Container(
                alignment: Alignment.center,
                child: widget.provider,
              ),
              Positioned(
                  top: 26.h,
                  left: 26.h,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: widget.activeColor,
                    ),
                    onPressed: () {
                      widget.popFunction();
                    },
                  )),
              Positioned(
                  right: 70.h,
                  top: 0.h,
                  child: IconButton(
                    icon: Icon(
                      Icons.cast_rounded,
                      color: widget.activeColor,
                    ),
                    onPressed: () {
                      if (widget.handlecasting != null) {
                        widget.handlecasting!();
                      }
                    },
                  )),
            ]),
          );
        });
  }
}
