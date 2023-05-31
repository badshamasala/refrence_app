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
  }
}
