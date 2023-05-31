import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/live_events/live_events_feedback.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import 'package:path/path.dart' as path;

class LiveEventPlayer extends StatefulWidget {
  final PastLiveEventsModelPastEvents? liveEvent;
  const LiveEventPlayer({
    Key? key,
    required this.liveEvent,
  }) : super(key: key);

  @override
  State<LiveEventPlayer> createState() => _LiveEventPlayerState();
}

class _LiveEventPlayerState extends State<LiveEventPlayer>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late BetterPlayerController betterPlayerController;
  late BetterPlayerConfiguration betterPlayerConfiguration;
  Color activeColor = const Color(0xFFAAFDB4);

  late AnimationController animationController;
  bool isInitialzed = false;
  DateTime startDate = DateTime.now();

  TextEditingController commentsTextController = TextEditingController();

  @override
  void initState() {
    try {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 28),
      );
      WidgetsBinding.instance.addObserver(this);
      initializeBetterPlayer();
      Wakelock.enable();
    } catch (exp) {
      print("Video_Player_Exception => $exp");
    }

    super.initState();
  }

  initializeBetterPlayer() async {
    try {
      betterPlayerConfiguration = BetterPlayerConfiguration(
        fit: BoxFit.contain,
        deviceOrientationsAfterFullScreen: const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown
        ],
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
            animation: animation,
            provider: provider,
            activeColor: activeColor,
            popFunction: () {
              betterPlayerController.exitFullScreen();
              Navigator.pop(context);
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
          enableFullscreen: false,
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
                betterPlayerController.exitFullScreen();
                Navigator.pop(context);
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
        widget.liveEvent!.recording!.rawUrl!,
        useAsmsSubtitles: false,
      );

      if (path.extension(widget.liveEvent!.recording!.rawUrl!) == ".m3u8") {
        dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.liveEvent!.recording!.rawUrl!,
          videoFormat: BetterPlayerVideoFormat.hls,
          useAsmsSubtitles: false,
        );
      } else {
        dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.liveEvent!.recording!.rawUrl!,
          useAsmsSubtitles: false,
        );
      }
      betterPlayerController.setupDataSource(dataSource);
      betterPlayerController.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LiveEventFeedback(
                liveEventId: widget.liveEvent!.liveEventId!,
                liveEventPreview: widget.liveEvent!.eventImages!.preview!,
              ),
            ),
          );
        } else if (event.betterPlayerEventType ==
            BetterPlayerEventType.initialized) {
          setState(() {
            isInitialzed = true;
          });
        }
      });
    } catch (error) {
      print("Video_Player_Exception => $error");
    }
  }

  @override
  void dispose() {
    try {
      Wakelock.disable();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BetterPlayer(
        controller: betterPlayerController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: (isInitialzed == true)
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: activeColor,
              ),
            )
          : null,
    );
  }
}

class BetterPlayerCustomRoute extends StatefulWidget {
  final Animation<double> animation;
  final BetterPlayerControllerProvider provider;
  final Function popFunction;
  final Color activeColor;

  const BetterPlayerCustomRoute({
    Key? key,
    required this.animation,
    required this.provider,
    required this.popFunction,
    required this.activeColor,
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
            ]),
          );
        });
  }
}
