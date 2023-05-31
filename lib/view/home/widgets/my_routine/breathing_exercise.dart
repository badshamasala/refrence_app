import 'dart:async';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class BreathingExercise extends StatefulWidget {
  final int timer;
  const BreathingExercise({Key? key, this.timer = 60}) : super(key: key);

  @override
  State<BreathingExercise> createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _isInit = true;
  bool _isLoading = true;
  Timer breathTimer = Timer(Duration.zero, () {});
  late int timeRemaining = 60;
  late final AnimationController _controller;
  LottieComposition? _composition;

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  bool showPlayButton = true;
  @override
  void initState() {
    super.initState();
    timeRemaining = widget.timer;
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        startTimer();
        break;
      case AppLifecycleState.inactive:
        stopTimer();
        break;
      case AppLifecycleState.paused:
        stopTimer();
        break;
      case AppLifecycleState.detached:
        stopTimer();
        break;
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
      await assetsAudioPlayer.open(
        Playlist(audios: [
          Audio(
            'assets/audio/flower_audio.mp3',
          )
        ], startIndex: 0),
        showNotification: false,
        loopMode: LoopMode.playlist,
        autoStart: false,
      );

      setState(() {
        _isLoading = false;
      });
      _isInit = false;
    }
  }

  void startTimer() {
    _controller
      ..duration = _composition!.duration
      ..repeat();
    assetsAudioPlayer.play();

    const oneSec = Duration(seconds: 1);
    breathTimer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (timeRemaining < 1) {
            timer.cancel();
            stopTimer();
            timeRemaining = 60;

            showPlayButton = true;

            EventsService().sendEvent("Aayu_Breathe_Completed", {
              "is_completed": "Yes",
            });
          } else {
            showPlayButton = false;
            timeRemaining = timeRemaining - 1;
          }
        },
      ),
    );
  }

  void stopTimer() {
    _controller
      ..duration = _composition!.duration
      ..stop();
    assetsAudioPlayer.pause();

    if (breathTimer.isActive) {
      breathTimer.cancel();
    }
  }

  @override
  void dispose() {
    // stopTimer();
    if (breathTimer.isActive) {
      breathTimer.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        assetsAudioPlayer.stop();
        assetsAudioPlayer.dispose();
        _controller.stop();
        _controller.dispose();

        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEDF5F3),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.blackLabelColor,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 43.h,
                  ),
                  Text(
                    '0${timeRemaining ~/ 60}:${(timeRemaining % 60 < 10) ? "0${timeRemaining % 60}" : '${timeRemaining % 60}'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF8AD8C3),
                      fontFamily: 'Circular Std',
                      fontSize: 20.sp,
                      letterSpacing: 5.5.w,
                      fontWeight: FontWeight.w400,
                      height: 1.2.h,
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  SizedBox(
                    height: 350.h,
                    child: Lottie.asset(Images.flowerAnimation,
                        controller: _controller, onLoaded: (composition) {
                      _composition = composition;
                      startTimer();
                    }),
                  ),
                  const Spacer(),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        showPlayButton = !showPlayButton;
                      });
                      if (!showPlayButton) {
                        startTimer();
                        EventsService().sendEvent("Aayu_Breathe", {
                          "play": "Yes",
                        });
                      } else {
                        EventsService().sendEvent("Aayu_Breathe", {
                          "play": "No",
                        });
                        stopTimer();
                      }
                    },
                    child: Icon(
                      showPlayButton
                          ? Icons.play_circle
                          : Icons.pause_circle_filled_sharp,
                      color: const Color(0xFFA6EAB4),
                      size: 56,
                    ),
                  ),
                  const Spacer()
                ],
              ),
      ),
    );
  }
}
