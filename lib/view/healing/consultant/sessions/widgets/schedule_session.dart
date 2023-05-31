import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleSession extends StatelessWidget {
  final String sessionType;
  const ScheduleSession(
      {Key? key, required this.sessionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: pageHorizontalPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (sessionType == "Doctor")
                ? Image(
                    image: const AssetImage(Images.doctorConsultant2Image),
                    width: 76.w,
                    height: 96.h,
                    fit: BoxFit.contain,
                  )
                : Image(
                    image: const AssetImage(Images.personalTrainingImageBlue),
                    width: 154.w,
                    height: 108.h,
                    fit: BoxFit.contain,
                  ),
            SizedBox(
              height: 24.h,
            ),
            SizedBox(
              width: (sessionType == "Doctor") ? 305.w : 266.w,
              child: Text(
                (sessionType == "Doctor")
                    ? "You don’t have any past doctor consults session."
                    : "You don’t have any past yoga therapist session.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF8C98A5),
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1.4285714285714286.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
