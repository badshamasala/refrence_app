import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssessmentQuestion extends StatelessWidget {
  final int index;
  final String? question;
  const AssessmentQuestion(
      {Key? key, required this.index, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      question!.trim(),
      textAlign: TextAlign.left,
      style: TextStyle(
        color: AppColors.aayuUserChatTextColor,
        fontFamily: 'Circular Std',
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        height: 1.42.h,
      ),
    );
    /* child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56.w,
            height: 56.h,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.029999999329447746),
                  offset: Offset(5, 4),
                  blurRadius: 8,
                )
              ],
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  color: const Color(0XFFA5ECD1),
                  fontFamily: 'Circular Std',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Text(
              question!.trim(),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.aayuUserChatTextColor,
                fontFamily: 'Circular Std',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                height: 1.42.h,
              ),
            ),
          ),
        ],
      ), */
  }
}
