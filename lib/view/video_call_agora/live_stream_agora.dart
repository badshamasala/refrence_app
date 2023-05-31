import 'dart:async';
import 'package:aayu/services/third-party/firestore.service.dart';
import 'package:aayu/view/live_events/widget/live_event_reaction.dart';
import 'package:aayu/view/shared/constants.dart';

import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aayu/view/video_call_agora/settings_agora.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wakelock/wakelock.dart';

import '../../theme/app_colors.dart';
import '../live_events/widget/live_events_live_count.dart';
import '../shared/ui_helper/icons.dart';
import '../shared/ui_helper/images.dart';
import 'widgets/event_call_timer.dart';

class LiveStreamAgora extends StatefulWidget {
  final String? token;
  final String? channelName;
  final ClientRole? clientRole;
  final String drName;
  final String drGender;
  final int secondsRemaining;
  final int timeLapsed;
  const LiveStreamAgora({
    Key? key,
    this.channelName,
    this.clientRole,
    this.token,
    required this.drName,
    required this.secondsRemaining,
    required this.timeLapsed,
    required this.drGender,
  }) : super(key: key);

  @override
  State<LiveStreamAgora> createState() => _LiveStreamAgoraState();
}

class _LiveStreamAgoraState extends State<LiveStreamAgora> {
  final List<int> _users = [];
  final List<String> _infoStrings = [];
  bool muted = false;
  bool videoSwicth = false;
  bool viewPanel = false;
  RtcEngine? _engine;
  bool showDocVideo = true;
  bool showControls = true;
  bool enableBackground = false;
  bool leftChannel = false;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    initialize();
  }

  @override
  void dispose() async {
    FirestoreService().leaveChannel(widget.channelName ?? "");
    _users.clear();
    _engine!.leaveChannel();
    _engine!.destroy();

    Wakelock.disable();

    super.dispose();
  }

  Future<void> initialize() async {
    if (appIdAgora.isEmpty) {
      setState(() {
        _infoStrings.add('APPID is missing');
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    _engine = await RtcEngine.create(appIdAgora.trim());

    await _engine!.enableVideo();
    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine!.setClientRole(widget.clientRole!);
    await _engine!.setAudioProfile(
        AudioProfile.MusicHighQuality, AudioScenario.GameStreaming);

    _addAgoraEventHandlers();

    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920, height: 1080);
    await _engine!.setVideoEncoderConfiguration(configuration);
    await _engine!
        .joinChannel(widget.token!.trim(), widget.channelName!, null, 0);
  }

  void _addAgoraEventHandlers() {
    _engine!.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'Error $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'Join channel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('Leave channel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'User Joined: $uid ';
          _infoStrings.add(info);
          _users.add(uid);
        });
      },
      remoteVideoStateChanged: (uid, state, reason, elapsed) {
        if (state == VideoRemoteState.Stopped) {
          setState(() {
            showDocVideo = false;
          });
        }
        if (state == VideoRemoteState.Starting) {
          setState(() {
            showDocVideo = true;
          });
        }
        if ((reason == VideoRemoteStateReason.RemoteOffline) && uid == 1) {
          doctorLeft();
        }
      },
      userOffline: (uid, elapsed) {
        final info = 'User Offline: $uid';
        _infoStrings.add(info);
        if (uid == 1) {
          doctorLeft();
        }
        _users.remove(uid);
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = ' First Remote Video: $uid ${width}x$height';
          _infoStrings.add(info);
        });
      },
    ));
  }

  Widget _viewParticipant() {
    if (_users.isEmpty) {
      return Container();
    }
    if (showDocVideo == false) {
      return Column(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: const Text(
              'Video Feed disabled',
              style: TextStyle(color: Colors.white),
            ),
          ))
        ],
      );
    }
    return Column(
      children: [
        Expanded(
            child: rtc_remote_view.SurfaceView(
          uid: _users[0],
          channelId: widget.channelName!,
        ))
      ],
    );
  }

  Widget _viewSelf() {
    if (videoSwicth) {
      return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: 180.h,
          width: 120.w,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const Center(
                child: Text(
                  'Video sharing is disabled',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              )));
    }
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 180.h,
        width: 120.w,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const rtc_local_view.SurfaceView()));
  }

  Widget _viewRows() {
    final List<StatefulWidget> list = [];
    if (widget.clientRole == ClientRole.Broadcaster) {
      if (videoSwicth) {
        list.add(StatefulBuilder(
          builder: (context, setState) => Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 180.h,
              width: double.infinity,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const Center(
                    child: Text(
                      'Video sharing is disabled',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))),
        ));
      } else {
        list.add(const rtc_local_view.SurfaceView());
      }
    }
    if (_users.isEmpty) {
      list.add(StatefulBuilder(
        builder: (context, setState) => Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            'Waiting for the session to start',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp),
          ),
        ),
      ));
    }
    for (var uid in _users) {
      list.add(rtc_remote_view.SurfaceView(
        uid: uid,
        channelId: widget.channelName!,
      ));
    }
    if (showDocVideo == false) {
      return Column(
        children: [
          Expanded(
              child: Container(
            color: AppColors.blueGreyAssessmentColor,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                      width: 256.w,
                      height: 256.h,
                      fit: BoxFit.contain,
                      image: const AssetImage(
                        Images.pingCircleImage,
                      ),
                    ),
                    Center(
                      child: SvgPicture.asset(Images.aayuLogoSVGImage,
                          width: 68.25.w,
                          height: 126.3.h,
                          color: AppColors.secondaryLabelColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                const Text(
                  'Video Feed disabled',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ))
        ],
      );
    }
    final views = list;
    return Column(
      children:
          List.generate(views.length, (index) => Expanded(child: views[index])),
    );
  }

  Widget _toolBar() {
    if (widget.clientRole == ClientRole.Audience) {
      return const SizedBox();
    }
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RawMaterialButton(
            constraints: const BoxConstraints(minWidth: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              setState(() {
                muted = !muted;
              });

              _engine!.muteLocalAudioStream(muted);
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? const Color(0xFF374957) : Colors.white,
            padding: const EdgeInsets.all(15.0),
            // child: SvgPicture.asset(
            //   AppIcons.audioSwitchVideoCallSVG,
            //   color: muted ? Colors.white : const Color(0xFF374957),
            //   height: 20.h,
            //   width: 20.h,x
            // ),
            child: Icon(
              muted ? Icons.mic_off_rounded : Icons.mic,
              color: muted ? Colors.white : const Color(0xFF374957),
              size: 28.h,
            ),
          ),
          RawMaterialButton(
            constraints: const BoxConstraints(minWidth: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () => Navigator.of(context).pop(),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: const Color(0xFFF16366),
            padding: const EdgeInsets.all(19.0),
            child: SvgPicture.asset(
              AppIcons.endCallVideoCallSVG,
              color: Colors.white,
              height: 20.h,
              width: 20.h,
            ),
          ),
          RawMaterialButton(
            constraints: const BoxConstraints(minWidth: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              setState(() {
                videoSwicth = !videoSwicth;
              });

              _engine!.muteLocalVideoStream(videoSwicth);
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: videoSwicth ? const Color(0xFF374957) : Colors.white,
            padding: const EdgeInsets.all(15.0),
            // child: SvgPicture.asset(
            //   AppIcons.videoSwutchVideoCallSVG,
            //   color: videoSwicth ? Colors.white : const Color(0xFF374957),
            //   height: 16.h,
            //   width: 16.h,
            // ),
            child: Icon(
              videoSwicth
                  ? Icons.videocam_off_outlined
                  : Icons.videocam_outlined,
              color: videoSwicth ? Colors.white : const Color(0xFF374957),
              size: 28.h,
            ),
          ),
        ],
      ),
    );
  }

  doctorLeft() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                    'We hope you had an enjoyable session! We\'re here to help you again.'),
                SizedBox(
                  height: 30.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(width: 140.h, child: mainButton('Okay')),
                )
              ],
            ),
          );
        }).then((value) {
      _users.clear();
      _engine!.leaveChannel();
      _engine!.destroy();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          _engine!.switchCamera();
        },
        onTap: () {
          setState(() {
            showControls = !showControls;
          });
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Stack(
            children: [
              _viewRows(),
              AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: showControls ? -0 : -100,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: _toolBar(),
              ),
              Positioned(
                top: 57.h,
                left: 0,
                right: 0,
                child: EventCallTimer(
                  secondRemaining: widget.secondsRemaining,
                  timeLapsed: widget.timeLapsed,
                ),
              ),
              Positioned(
                top: 49.h,
                right: 26.w,
                left: 40.w,
                child: Row(
                  children: [
                    const Spacer(),
                    if (remoteConfigData != null &&
                        remoteConfigData!
                                .getBool("SHOW_LIVE_EVENT_USER_COUNT") ==
                            true)
                      LiveEventsLiveCount(
                          liveEventId: widget.channelName ?? ""),
                    SizedBox(
                      width: 12.w,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 16.h,
                        backgroundColor:
                            const Color.fromRGBO(255, 255, 255, 0.6),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.blackLabelColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: LiveEventReaction(
                  drGender: widget.drGender,
                  liveEventId: widget.channelName ?? "",
                  doctorName: widget.drName,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
