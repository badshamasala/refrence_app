import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/theme.dart';

class ActivationCodeApplied extends StatelessWidget {
  const ActivationCodeApplied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.pageBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.w),
                topRight: Radius.circular(30.w),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 82.h,
                ),
                Text(
                  'Congratulations!',
                  style: TextStyle(
                    color: const Color.fromRGBO(91, 112, 129, 0.8),
                    fontFamily: 'Baskerville',
                    fontWeight: FontWeight.w400,
                    fontSize: 30.sp,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  'You Have Successfully Activated Your Plan. Start Your Welbeing Journey.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(91, 112, 129, 0.5),
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: 240.h,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(
                        navState.currentState!.context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(
                            selectedTab: 0,
                          ),
                        ),
                      );
                    },
                    child: mainButton('Start'),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            )),
        Positioned(
          top: -98.h,
          child: Image.asset(
            Images.welcomeBackImage,
            height: 166.h,
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned(
            top: 10.h,
            right: 10.h,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.blackLabelColor,
                  size: 25,
                ))),
      ],
    );
  }
}
