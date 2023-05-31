// import 'package:aayu/controller/sleep_tracker/sleep_tracker_calendar_controller.dart';
// import 'package:aayu/theme/app_colors.dart';
// import 'package:aayu/theme/app_theme.dart';
// import 'package:aayu/view/sleep_tracking/widget/sleep_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:intl/intl.dart';

// class ViewSleepcardFordayBottomSheet extends StatelessWidget {
//   final DateTime selectedDate;
//   const ViewSleepcardFordayBottomSheet({Key? key, required this.selectedDate})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SleepTrackerCalenderController>(
//       builder: (sleepTrackerCalenderController) =>
//           Stack(alignment: Alignment.topRight, children: [
//         Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(32),
//                 topRight: Radius.circular(32),
//               ),
//               color: AppColors.sleepTrackerBackgroundLight),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 54.h,
//               ),
//               Text(
//                 DateFormat('d MMM, yyyy').format(selectedDate),
//                 style: AppTheme.secondarySmallFontTitleTextStyleSleeptracker,
//               ),
//               SizedBox(
//                 height: 61.h,
//               ),
//               SleepCard(
//                 howWasSleep: sleepTrackerCalenderController
//                     .viewSleepCheckInForDay.value.checkIns![0]!.quality!,
//                 inTime: sleepTrackerCalenderController
//                     .viewSleepCheckInForDay.value.checkIns![0]!.inTime!,
//                 outTime: sleepTrackerCalenderController
//                     .viewSleepCheckInForDay.value.checkIns![0]!.outTime!,
//                 listReasons: sleepTrackerCalenderController
//                     .viewSleepCheckInForDay.value.checkIns![0]!.affected!,
//               ),
//               SizedBox(
//                 height: 25.h,
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           top: 20.h,
//           right: 20.w,
//           child: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: const Icon(
//                 Icons.close,
//                 color: Colors.white,
//               )),
//         )
//       ]),
//     );
//   }
// }
