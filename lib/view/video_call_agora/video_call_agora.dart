import 'dart:async';
import 'dart:io';

import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui';
import 'package:path/path.dart' as path;
import 'package:aayu/view/video_call_agora/settings_agora.dart';
import 'package:aayu/view/video_call_agora/widgets/call_timer.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wakelock/wakelock.dart';
import 'package:draggable_widget/draggable_widget.dart';

import '../shared/ui_helper/icons.dart';

class VideoCallAgora extends StatefulWidget {
  final String? token;
  final String? channelName;
  final ClientRole? clientRole;
  final String coachName;
  final int secondsRemaining;
  final String profession;

  const VideoCallAgora(
      {Key? key,
      this.channelName,
      this.clientRole,
      this.token,
      required this.coachName,
      required this.secondsRemaining,
      required this.profession})
      : super(key: key);

  @override
  State<VideoCallAgora> createState() => _VideoCallAgoraState();
}

class _VideoCallAgoraState extends State<VideoCallAgora> {
  final List<int> _users = [];
  final List<String> _infoStrings = [];
  bool muted = false;
  bool videoSwicth = false;
  bool viewPanel = false;
  RtcEngine? _engine;
  bool showDocVideo = true;
  bool showControls = true;
  final dragController = DragController();
  bool enableBackground = false;
  VideoCallLayout videoCallLayout = VideoCallLayout.DRAGGABLE;
  bool showDoctorClosedMeeting = false;
  bool showPoorNetworkConnection = false;
  NetworkType networkType = NetworkType.WIFI;
  String networkIcon = AppIcons.wifiConnectedSVG;
  Color networkColor = Colors.white;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    initialize();
  }

  @override
  void dispose() async {
    if (enableBackground) {
      await enableVirtualBackground();
    }
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

    _addAgoraEventHandlers();

    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920, height: 1080);
    await _engine!.setVideoEncoderConfiguration(configuration);
    await _engine!
        .joinChannel(widget.token!.trim(), widget.channelName!, null, 0);
  }

  Future<void> enableVirtualBackground() async {
    enableBackground = !enableBackground;
    ByteData data = await rootBundle
        .load("assets/images/video-call-background-bright.jpeg");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String p = path.join(appDocDir.path, 'video-call-background-bright.jpeg');
    final file = File(p);
    if (!(await file.exists())) {
      await file.create();
      await file.writeAsBytes(bytes);
    }
    await _engine!.enableVirtualBackground(
        enableBackground,
        VirtualBackgroundSource(
            blurDegree: VirtualBackgroundBlurDegree.High,
            backgroundSourceType: VirtualBackgroundSourceType.Img,
            source: p,
            color: 0xFFB6C1));
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
      networkTypeChanged: (type) {
        setState(() {
          networkType = type;
          switch (networkType) {
            case NetworkType.LAN:
            case NetworkType.WIFI:
              networkIcon = AppIcons.wifiConnectedSVG;
              break;
            case NetworkType.Mobile2G:
            case NetworkType.Mobile3G:
            case NetworkType.Mobile4G:
            case NetworkType.Mobile5G:
              networkIcon = AppIcons.netConnectedSVG;
              break;
            case NetworkType.Disconnected:
              networkIcon = AppIcons.netDisconnectedSVG;
              break;

            default:
              networkIcon = AppIcons.netConnectedSVG;
              break;
          }
        });
      },
      networkQuality: (uid, txQuality, rxQuality) {
        if (txQuality == NetworkQuality.Bad ||
            rxQuality == NetworkQuality.Bad ||
            txQuality == NetworkQuality.VBad ||
            txQuality == NetworkQuality.Down ||
            rxQuality == NetworkQuality.Down ||
            rxQuality == NetworkQuality.VBad) {
          setState(() {
            networkColor = const Color(0xFFFF7979);
          });
        }
        if (txQuality == NetworkQuality.Poor ||
            rxQuality == NetworkQuality.Poor) {
          setState(() {
            networkColor = const Color(0xFFE88566);
          });
        }
        if (txQuality == NetworkQuality.Good ||
            rxQuality == NetworkQuality.Good ||
            txQuality == NetworkQuality.Excellent ||
            rxQuality == NetworkQuality.Excellent) {
          setState(() {
            networkColor = const Color(0xFFAAFDB4);
          });
        }
        if (rxQuality == NetworkQuality.Unsupported ||
            txQuality == NetworkQuality.Unsupported) {
          setState(() {
            networkColor = Colors.white;
          });
        }
      },
    ));
  }

  Widget _viewParticipant() {
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
        _users.isEmpty
            ? Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    'Waiting for the ${widget.profession.toLowerCase()} to join',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp),
                  ),
                ),
              )
            : Expanded(
                child: rtc_remote_view.SurfaceView(
                uid: _users[0],
                channelId: widget.channelName!,
              ))
      ],
    );
  }

  Widget viewSelf() {
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
    if (_users.isEmpty) {
      list.add(StatefulBuilder(
        builder: (context, setState) => Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            'Waiting for the ${widget.profession.toLowerCase()} to join',
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
    if (widget.clientRole == ClientRole.Broadcaster &&
        videoCallLayout == VideoCallLayout.HALFHALF) {
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

    final views = list;
    return Column(
      children:
          List.generate(views.length, (index) => Expanded(child: views[index])),
    );
  }

  Widget _changeViewTools() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(
          opacity: videoCallLayout == VideoCallLayout.DRAGGABLE ? 1 : 0.6,
          child: RawMaterialButton(
            constraints: const BoxConstraints(minWidth: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              setState(() {
                videoCallLayout = VideoCallLayout.DRAGGABLE;
              });
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            child: SvgPicture.asset(
              videoCallLayout == VideoCallLayout.DRAGGABLE
                  ? AppIcons.draggableActiveSVG
                  : AppIcons.draggableSVG,
              height: 32.h,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Opacity(
          opacity: videoCallLayout == VideoCallLayout.HALFHALF ? 1 : 0.6,
          child: RawMaterialButton(
            constraints: const BoxConstraints(minWidth: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              setState(() {
                videoCallLayout = VideoCallLayout.HALFHALF;
              });
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            child: SvgPicture.asset(
              videoCallLayout == VideoCallLayout.HALFHALF
                  ? AppIcons.splitScreenActiveSVG
                  : AppIcons.splitScreenSVG,
              height: 32.h,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Opacity(
          opacity: videoCallLayout == VideoCallLayout.FULLDOC ? 1 : 0.6,
          child: RawMaterialButton(
            constraints: const BoxConstraints(minWidth: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              setState(() {
                videoCallLayout = VideoCallLayout.FULLDOC;
              });
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            child: SvgPicture.asset(
              videoCallLayout == VideoCallLayout.FULLDOC
                  ? AppIcons.fullScreenActiveSVG
                  : AppIcons.fullScreenSVG,
              height: 32.h,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showPoorNetworkConnection == true)
            Text(
              'Unstable internet connection',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp),
            ),
          Row(
            children: [
              const Spacer(),
              RawMaterialButton(
                constraints: BoxConstraints(minWidth: 150.w),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    enableDrag: true,
                    isDismissible: false,
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7),
                    isScrollControlled: true,
                    builder: (context) => Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Got all your\nqueries answered?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 22.sp),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        RawMaterialButton(
                          constraints: BoxConstraints(minWidth: 150.w),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          elevation: 2.0,
                          fillColor: const Color(0xFFF16366),
                          padding: const EdgeInsets.all(19.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                AppIcons.leaveCallSVG,
                                color: Colors.white,
                                height: 25.h,
                                width: 25.h,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Leave Call",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            radius: 28.h,
                            backgroundColor: Colors.black,
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        )
                      ],
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                elevation: 2.0,
                fillColor: const Color(0xFFF16366),
                padding: const EdgeInsets.all(19.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset(
                      AppIcons.leaveCallSVG,
                      color: Colors.white,
                      height: 25.h,
                      width: 25.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Leave Call",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
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
                fillColor: Colors.white,
                child: SvgPicture.asset(
                  muted ? AppIcons.muteCallSVG : AppIcons.unmuteCallSVG,
                  height: 56.h,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                width: 16.w,
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
                child: SvgPicture.asset(
                  videoSwicth
                      ? AppIcons.videoOffActiveSVG
                      : AppIcons.videoOnSVG,
                  height: 56.h,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const Spacer()
            ],
          ),
        ],
      ),
    );
  }

  doctorLeft() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
                '${toTitleCase(widget.profession.toLowerCase())} closed the meeting'),
          );
        }).then((value) {
      Navigator.of(context).pop();
    });
    Future.delayed(const Duration(seconds: 3), () {
      _users.clear();
      _engine!.leaveChannel();
      _engine!.destroy();
      MyRoutineController myRoutineController = Get.find();
      myRoutineController.getData();
    });
  }

  Widget _infoBar() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(0, 0, 0, 0.5),
            Color.fromRGBO(0, 0, 0, 0),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 30.h,
          child: Stack(clipBehavior: Clip.none, children: [
            AppBar(
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.coachName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  CallTimerWidget(
                    secondRemaining: widget.secondsRemaining,
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      _engine!.switchCamera();
                    },
                    child: SvgPicture.asset(
                      AppIcons.reverseCamSVG,
                      height: 30.h,
                      fit: BoxFit.fitHeight,
                    )),
              ],
            ),
            Positioned(
              bottom: -35,
              right: 16,
              child: SvgPicture.asset(
                networkIcon,
                color: networkColor,
                height: 32.h,
                fit: BoxFit.fitHeight,
              ),
            )
          ]),
        )
      ],
    );
  }

  Widget _panel() {
    return Visibility(
        visible: viewPanel,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 48,
              ),
              child: ListView.builder(
                  reverse: true,
                  itemCount: _infoStrings.length,
                  itemBuilder: (context, index) {
                    if (_infoStrings.isEmpty) {
                      return const Text('null');
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                              child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              _infoStrings[index],
                              style: const TextStyle(color: Colors.blueGrey),
                            ),
                          ))
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool allowLeaving = false;
        await showModalBottomSheet(
          context: context,
          enableDrag: true,
          isDismissible: false,
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.70),
          isScrollControlled: true,
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Got all your\nqueries answered?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 22.sp),
              ),
              SizedBox(
                height: 20.h,
              ),
              RawMaterialButton(
                constraints: BoxConstraints(minWidth: 150.w),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  Navigator.of(context).pop();
                  allowLeaving = true;
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                elevation: 2.0,
                fillColor: const Color(0xFFF16366),
                padding: const EdgeInsets.all(19.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppIcons.leaveCallSVG,
                      color: Colors.white,
                      height: 25.h,
                      width: 25.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Leave Call",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  radius: 28.h,
                  backgroundColor: Colors.black,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        );
        return allowLeaving;
      },
      child: Scaffold(
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
            child: videoCallLayout == VideoCallLayout.FULLDOC ||
                    videoCallLayout == VideoCallLayout.HALFHALF
                ? Stack(children: [
                    _viewRows(),
                    AnimatedPositioned(
                        left: 0,
                        right: 0,
                        bottom: showControls ? -0 : -100,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: _toolBar()),
                    AnimatedPositioned(
                        top: 0,
                        bottom: 0,
                        right: showControls ? 25 : -100,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: _changeViewTools()),
                    Positioned(top: 0, right: 0, left: 0, child: _infoBar()),
                  ])
                : Stack(
                    children: [
                      _viewParticipant(),
                      Positioned(top: 0, right: 0, left: 0, child: _infoBar()),
                      _panel(),
                      AnimatedPositioned(
                          left: 0,
                          right: 0,
                          bottom: showControls ? -0 : -100,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: _toolBar()),
                      AnimatedPositioned(
                          top: 0,
                          bottom: 0,
                          right: showControls ? 25 : -100,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: _changeViewTools()),
                      DraggableWidget(
                        bottomMargin: 130,
                        topMargin: 120,
                        draggingShadow:
                            const BoxShadow(color: Colors.transparent),
                        normalShadow:
                            const BoxShadow(color: Colors.transparent),
                        intialVisibility: true,
                        horizontalSpace: 20,
                        initialPosition: AnchoringPosition.bottomLeft,
                        dragController: dragController,
                        child: viewSelf(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

enum VideoCallLayout {
  DRAGGABLE,
  HALFHALF,
  FULLDOC,
}
