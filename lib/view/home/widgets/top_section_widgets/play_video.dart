import 'dart:async';
import 'package:aayu/theme/theme.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

class PlayVideo extends StatefulWidget {
  final String contentPath;
  const PlayVideo({Key? key, required this.contentPath}) : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> with WidgetsBindingObserver {
  late BetterPlayerController betterPlayerController;
  late BetterPlayerConfiguration betterPlayerConfiguration;
  Color activeColor = const Color(0xFFAAFDB4);

  @override
  void initState() {
    try {
      WidgetsBinding.instance.addObserver(this);
      initializeBetterPlayer();
      setLandscape();
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
        placeholderOnTop: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePip: false, //used for PIP Mode
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
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ],
        autoDispose: true,
      );
      betterPlayerController =
          BetterPlayerController(betterPlayerConfiguration);

      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.contentPath,
        useAsmsSubtitles: false,
      );
      betterPlayerController.setupDataSource(dataSource);
    } catch (error) {
      print("Video_Player_Exception => $error");
    }
  }

  @override
  void dispose() {
    try {
      setAllOrientations();
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

  Future setLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future setAllOrientations() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BetterPlayer(
        controller: betterPlayerController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.cancel,
          size: 30,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
