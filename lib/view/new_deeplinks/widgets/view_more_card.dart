import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewMoreCard extends StatefulWidget {
  final List<Widget> children;
  const ViewMoreCard({Key? key, required this.children}) : super(key: key);

  @override
  State<ViewMoreCard> createState() => _ViewMoreCardState();
}

class _ViewMoreCardState extends State<ViewMoreCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        height: expanded ? null : 322.h,
        margin: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 30.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 16,
                offset: Offset(1, 8),
                color: Color.fromRGBO(91, 112, 129, 0.08),
              )
            ]),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
            width: double.infinity,
            child: Column(
              children: widget.children,
              mainAxisSize: MainAxisSize.min,
            ),
          ),
        ),
      ),
      if (!expanded)
        Container(
          margin: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 30.h),
          height: 120,
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
              gradient: LinearGradient(
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.22),
                    Color.fromRGBO(255, 255, 255, 1)
                  ])),
        ),
      if (!expanded)
        Positioned(
          bottom: 30,
          child: TextButton(
              onPressed: () {
                setState(() {
                  expanded = true;
                });
              },
              child: Text(
                'READ_MORE'.tr,
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    decoration: TextDecoration.underline),
              )),
        ),
    ]);
  }
}
