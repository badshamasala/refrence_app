import 'dart:async';
import 'package:aayu/theme/theme.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import 'package:path/path.dart' as path;

class PlayAnyVideo extends StatefulWidget {
  final String videoUrl;

  const PlayAnyVideo({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<PlayAnyVideo> createState() => _PlayAnyVideoState();
}

class _PlayAnyVideoState extends State<PlayAnyVideo>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late BetterPlayerController betterPlayerController;
  late BetterPlayerConfiguration betterPlayerConfiguration;
  bool videoFinished = false;
  Color activeColor = const Color(0xFFAAFDB4);

  late AnimationController animationController;
  bool isInitialzed = false;
  DateTime startDate = DateTime.now();

  @override
  void initState() {
    try {
      print(widget.videoUrl);

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
        widget.videoUrl,
        useAsmsSubtitles: false,
      );

      if (path.extension(widget.videoUrl) == ".m3u8") {
        dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.videoUrl,
          videoFormat: BetterPlayerVideoFormat.hls,
          useAsmsSubtitles: false,
        );
      } else {
        dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.videoUrl,
          useAsmsSubtitles: false,
        );
      }

      betterPlayerController.setupDataSource(dataSource);

      betterPlayerController.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
          setState(() {
            videoFinished = true;
          });
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
    } else {
      completer.complete(true);
      Navigator.of(context).pop({"videoFinished": videoFinished});
    }
    return completer.future;
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
