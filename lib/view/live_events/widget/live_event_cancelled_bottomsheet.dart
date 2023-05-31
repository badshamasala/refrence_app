import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveEventCancelledBottomSheet extends StatelessWidget {
  const LiveEventCancelledBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 35.w, right: 25.w),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'We are sorry!',
                style: TextStyle(
                    color: AppColors.blueGreyAssessmentColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackLabelColor,
                  ))
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            'Due to some unavoidable circumstances this live event had to be cancelled. We apologise for the inconvenience and we look forward to hosting an event like this for you, soon.',
            style: TextStyle(
                color: const Color.fromRGBO(91, 112, 129, 0.8),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 35.h,
          )
        ],
      ),
    );
  }
}
