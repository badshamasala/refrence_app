import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallTimerWidget extends StatefulWidget {
  final int secondRemaining;

  const CallTimerWidget({Key? key, required this.secondRemaining})
      : super(key: key);

  @override
  State<CallTimerWidget> createState() => _CallTimerWidgetState();
}

class _CallTimerWidgetState extends State<CallTimerWidget> {
  int seconds = 0;

  Timer? timer;
  @override
  void initState() {
    super.initState();

    seconds = widget.secondRemaining;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 1) {
        timer.cancel();
      } else {
        setState(() {
          seconds = seconds - 1;
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
      "${returnTime((seconds / 60).floor())}:${returnTime((seconds % 60))}",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.sp),
    );
  }
}
