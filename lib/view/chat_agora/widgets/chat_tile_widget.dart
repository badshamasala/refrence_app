import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/chat_agora/widgets/chat_image_widget.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ChatTileWidget extends StatelessWidget {
  final ChatMessage? chatMessage;
  final bool self;
  final double width;

  const ChatTileWidget(
      {Key? key, this.chatMessage, required this.self, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chatMessage == null) {
      return const Offstage();
    }
    switch (chatMessage!.body.type) {
      case MessageType.IMAGE:
        return Row(
          mainAxisAlignment:
              self ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    constraints:
                        BoxConstraints(maxWidth: width * 0.65, minWidth: 85.w),
                    margin:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: self ? Colors.white : const Color(0xffFCAFAF)),
                    padding: EdgeInsets.only(
                        bottom: 17.h,
                        right: self ? 15.w : 7.w,
                        top: 8.h,
                        left: self ? 7.w : 15.w),
                    child: ChatImageWidget(
                        body: (chatMessage!.body as ChatImageMessageBody),
                        self: self)),
                Positioned(
                  bottom: 5.h,
                  right: 5.h,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Text(returnDate(chatMessage!.serverTime),
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 10.sp)),
                  ),
                )
              ],
            )
          ],
        );
      case MessageType.TXT:
        return Row(
          mainAxisAlignment:
              self ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                    constraints:
                        BoxConstraints(maxWidth: width * 0.65, minWidth: 85.w),
                    margin:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: self ? Colors.white : const Color(0xffFCAFAF)),
                    padding: EdgeInsets.only(
                        bottom: 17.h,
                        right: self ? 15.w : 7.w,
                        top: 8.h,
                        left: self ? 7.w : 15.w),
                    child: Text(
                        (chatMessage!.body as ChatTextMessageBody).content,
                        style: TextStyle(
                            color: AppColors.blackLabelColor,
                            fontSize: 14.sp))),
                Positioned(
                  bottom: 5.h,
                  right: 5.h,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Text(returnDate(chatMessage!.serverTime),
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 10.sp)),
                  ),
                )
              ],
            ),
          ],
        );

      default:
        return Row(
          mainAxisAlignment:
              self ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                    constraints:
                        BoxConstraints(maxWidth: width * 0.65, minWidth: 85.w),
                    margin:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: self ? Colors.white : const Color(0xffFCAFAF)),
                    padding: EdgeInsets.only(
                        bottom: 17.h,
                        right: self ? 15.w : 7.w,
                        top: 8.h,
                        left: self ? 7.w : 15.w),
                    child: Text(
                        (chatMessage!.body as ChatTextMessageBody).content,
                        style: TextStyle(
                            color: AppColors.blackLabelColor,
                            fontSize: 14.sp))),
                Positioned(
                  bottom: 5.h,
                  right: 5.h,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Text(returnDate(chatMessage!.serverTime),
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 10.sp)),
                  ),
                )
              ],
            ),
          ],
        );
    }
  }

  String returnDate(int time) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
    DateTime now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return DateFormat('hh:mm a').format(date);
    }

    return DateFormat('dd MMM, hh:mm a').format(date);
  }
}
