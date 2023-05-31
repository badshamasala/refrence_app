import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentDesc extends StatelessWidget {
  final String description;
  const ContentDesc({ Key? key, required this.description }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.w,
      child: Text(
        description,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: const Color(0xFF768897),
          fontFamily: 'Circular Std',
          fontSize: 14.sp,
          letterSpacing: 0,
          fontWeight: FontWeight.normal,
          height: 1.5.h,
        ),
      ),
    );
  }
}