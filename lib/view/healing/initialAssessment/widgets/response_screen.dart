import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponseScreen extends StatelessWidget {
  final String generalResponse;
  final Function nextAction;
  const ResponseScreen(
      {Key? key, required this.generalResponse, required this.nextAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  Images.assessmentBGImage,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage(
                    Images.assessmentResponseImage,
                  ),
                  width: 229.8.w,
                  height: 149.8.h,
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: 293.w,
                  child: Text(
                    generalResponse,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.5.h,
                    ),
                  ),
                ),
                SizedBox(
                  height: 54.h,
                ),
                InkWell(
                  onTap: () {
                    nextAction();
                  },
                  child: SizedBox(
                    width: 150.w,
                    child: mainButton("Next"),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 36.h,
            right: 26.h,
            child: IconButton(
              onPressed: () {
                nextAction();
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
