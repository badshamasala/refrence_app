import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/theme.dart';
import '../../shared/ui_helper/images.dart';

class FreeDoctorConsultFloating extends StatefulWidget {
  final Function freeDoctorConsultFunction;
  const FreeDoctorConsultFloating(
      {Key? key, required this.freeDoctorConsultFunction})
      : super(key: key);
  static final GlobalKey<_FreeDoctorConsultFloatingState> globalKey =
      GlobalKey();

  @override
  State<FreeDoctorConsultFloating> createState() =>
      _FreeDoctorConsultFloatingState();
}

class _FreeDoctorConsultFloatingState extends State<FreeDoctorConsultFloating> {
  bool showBigFreeDoctor = false;
  Timer? timer;
  Timer? timer2;
  bool hideBookDoctor = false;
  bool showText = false;

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  void start() {
    setState(() {
      if (timer != null) {
        timer!.cancel();
      }
      if (timer2 != null) {
        timer2!.cancel();
      }
      showBigFreeDoctor = false;
      showText = false;
    });
  }

  void end() {
    timer = Timer(const Duration(milliseconds: 800), () {
      setState(() {
        showBigFreeDoctor = true;
      });
      timer2 = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          showText = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return hideBookDoctor
        ? const SizedBox()
        : InkWell(
            onTap: () {
              widget.freeDoctorConsultFunction();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 35.w),
              child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topLeft,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFE7E7),
                          borderRadius: BorderRadius.circular(300),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(1, 8),
                              blurRadius: 16,
                              color: Color.fromRGBO(91, 112, 129, 0.08),
                            )
                          ]),
                      height: 72.h,
                      width: showBigFreeDoctor
                          ? MediaQuery.of(context).size.width
                          : 90.w,
                      padding: showBigFreeDoctor
                          ? EdgeInsets.only(
                              top: 16.h, bottom: 11.h, right: 15.w, left: 93.w)
                          : EdgeInsets.zero,
                      child: !showText
                          ? const SizedBox()
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Book a Free\nDoctor Consultation',
                                    style: TextStyle(
                                      height: 1.25,
                                      fontFamily: 'Baskerville',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                      color: AppColors.blueGreyAssessmentColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hideBookDoctor = true;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: AppColors.blueGreyAssessmentColor,
                                      size: 25,
                                    )),
                              ],
                            ),
                    ),
                    Positioned(
                      left: 20.w,
                      right: showBigFreeDoctor ? null : 20.w,
                      bottom: 15.h,
                      child: Image.asset(
                        Images.doctorConsultant3Image,
                        height: 66.h,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  ]),
            ));
  }
}
