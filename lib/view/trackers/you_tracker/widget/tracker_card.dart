import 'package:aayu/model/you_tracker/you_tracker_model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrackerListCard extends StatelessWidget {
  final UserTrackersDataActiveTrackers tracker;
  final String operation;
  final Function action;
  const TrackerListCard(
      {Key? key,
      required this.tracker,
      required this.action,
      required this.operation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.sp),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            offset: Offset(0, 5),
                            blurRadius: 5,
                          )
                        ],
                      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network(
            tracker.icon ?? "",
            height: 32.h,
            width: 32.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            tracker.displayText ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: "Circular Std",
              fontSize: 16.sp,
              color: AppColors.blackLabelColor,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              action();
            },
            icon: operation == "ADD"
                ? const Icon(
                    Icons.add,
                    color: AppColors.primaryColor,
                  )
                : const Icon(
                    Icons.remove,
                    color: AppColors.primaryColor,
                  ),
          )
        ],
      ),
    );
  }
}
