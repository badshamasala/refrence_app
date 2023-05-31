import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/services/third-party/firestore.service.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../shared/ui_helper/images.dart';

class LiveEventReaction extends StatefulWidget {
  final String liveEventId;
  final String doctorName;
  final String drGender;
  const LiveEventReaction(
      {Key? key,
      required this.liveEventId,
      required this.doctorName,
      required this.drGender})
      : super(key: key);

  @override
  State<LiveEventReaction> createState() => _LiveEventReactionState();
}

class _LiveEventReactionState extends State<LiveEventReaction>
    with SingleTickerProviderStateMixin {
  bool sendingSmile = false;
  int currentCount = 0;
  bool _isInit = true;
  late final AnimationController _controller;
  var _compostion;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  Future<void> playAnimation(int number) async {
    _controller
      ..duration = _compostion.duration
      ..forward(from: 0).then((value) {
        _controller
          ..duration = _compostion.duration
          ..forward(from: 0)
          ..animateTo(0);

        currentCount = currentCount + 1;
        if (currentCount < number) {
          playAnimation(number);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.h,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("liveEvents")
            .doc(widget.liveEventId)
            .snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as DocumentSnapshot;
            int number = data['smileCount'] ?? 0;
            if (_isInit) {
              currentCount = number;
              _isInit = false;
            } else {
              if (number > currentCount) {
                playAnimation(number);
              }
            }

            return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100.w,
                    height: 400.h,
                    child: Lottie.asset(
                      Images.liveStreamReactionLottie,
                      controller: _controller,
                      onLoaded: (composition) {
                        _compostion = composition;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 29.w),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        if (sendingSmile == false) {
                          setState(() {
                            sendingSmile = true;
                          });
                          LiveEventsController liveEventsController =
                              Get.find();
                          liveEventsController.sendSmile(widget.liveEventId);

                          FirestoreService()
                              .sendSmile(widget.liveEventId)
                              .then((value) {
                            setState(() {
                              sendingSmile = false;
                            });
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.favorite_border_outlined,
                        color: AppColors.primaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 26.w),
                    child: SizedBox(
                      width: 150.w,
                      child: Text(
                        number == 0
                            ? 'Send a heart to ${widget.doctorName} for ${widget.drGender.toUpperCase() == "MALE" ? "his" : "her"} words of wisdom.'
                            : '$number hearts for\n${widget.doctorName}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color.fromRGBO(255, 255, 255, 0.8),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ]);
          }
          return const Offstage();
        },
      ),
    );
  }
}
