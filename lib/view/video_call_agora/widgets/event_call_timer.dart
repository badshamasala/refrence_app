import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventCallTimer extends StatefulWidget {
  final int secondRemaining;
  final int timeLapsed;

  const EventCallTimer(
      {Key? key, required this.secondRemaining, required this.timeLapsed})
      : super(key: key);

  @override
  State<EventCallTimer> createState() => _EventCallTimerState();
}

class _EventCallTimerState extends State<EventCallTimer> {
  int completedSeconds = 0;
  int remainingSeconds = 0;

  Timer? timer;
  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.secondRemaining;
    completedSeconds = widget.timeLapsed;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 1) {
        timer.cancel();
      } else {
        setState(() {
          remainingSeconds = remainingSeconds - 1;
          completedSeconds = completedSeconds + 1;
        });
      }
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  String returnTime(int number) {
    if (number < 10) {
      return '0$number';
    } else {
      return number.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${returnTime((completedSeconds / 60).floor())}:${returnTime((completedSeconds % 60))}",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 16.sp,
      ),
    );
  }
}
