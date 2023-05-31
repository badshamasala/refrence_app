import 'package:aayu/controller/you/notification_controller.dart';
import 'package:aayu/model/you/notifications.model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<NotificationController>(
          builder: (controller) => Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 28.w,
                  ),
                  Text(
                    'NOTIFICATIONS'.tr,
                    style: AppTheme.secondarySmallFontTitleTextStyle,
                  ),
                  SizedBox(
                    width: 7.w,
                  ),
                  CircleAvatar(
                    radius: 12.h,
                    backgroundColor: const Color(0xFFF16366),
                    child: Text(
                      controller.notificationContent.value.data!.notOpened
                          .toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.blackLabelColor,
                      )),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                  child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.todaysList.isNotEmpty)
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.todaysList.length,
                          itemBuilder: (context, index) => NotificationTile(
                              category: index == 0 ? 'Today' : null,
                              data: controller.todaysList[index])),
                    if (controller.thisWeeksList.isNotEmpty)
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.thisWeeksList.length,
                          itemBuilder: (context, index) => NotificationTile(
                              category: index == 0 ? 'This week' : null,
                              data: controller.thisWeeksList[index])),
                    if (controller.lastWeeksList.isNotEmpty)
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.lastWeeksList.length,
                          itemBuilder: (context, index) => NotificationTile(
                              category: index == 0 ? 'Last week' : null,
                              data: controller.lastWeeksList[index])),
                    if (controller.thisMonthsList.isNotEmpty)
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.thisMonthsList.length,
                          itemBuilder: (context, index) => NotificationTile(
                              category: index == 0 ? 'This month' : null,
                              data: controller.thisMonthsList[index])),
                    if (controller.olderList.isNotEmpty)
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.olderList.length,
                          itemBuilder: (context, index) => NotificationTile(
                              category: index == 0 ? 'Older' : null,
                              data: controller.olderList[index]))
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationsModelDataList data;
  final String? category;
  const NotificationTile({Key? key, required this.data, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: data.opened! ? const Color(0xFFFFF8F8) : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 19.h,
                ),
                if (category != null)
                  SizedBox(
                    height: 11.h,
                  ),
                if (category != null)
                  Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text(
                      category!,
                      style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Circular Std"),
                    ),
                  ),
                if (category != null)
                  SizedBox(
                    height: 43.h,
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(width: 28.w),
                    SizedBox(
                      height: 60.h,
                      width: 60.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: ShowNetworkImage(
                          imgPath: data.displayPicture!,
                          imgHeight: 60.h,
                          boxFit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 17.w,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.content!,
                            textAlign: TextAlign.left,
                            maxLines: null,
                            style: TextStyle(
                                color: AppColors.secondaryLabelColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Circular Std"),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            DateFormat("EEE, dd MMM, yyyy")
                                .format(DateTime.parse(data.date!)),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(141, 155, 153, 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (data.image != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 12.w,
                          ),
                          SizedBox(
                            height: 70.h,
                            width: 105.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ShowNetworkImage(
                                imgPath: data.image!,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    SizedBox(
                      width: 20.w,
                    )
                  ],
                ),
                SizedBox(
                  height: 19.h,
                )
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFEBEBEB),
            height: 0,
            thickness: 1,
          )
        ],
      ),
      if (!data.opened!)
        Positioned(
          bottom: 23.h,
          right: 24.w,
          child: CircleAvatar(
            radius: 4.h,
            backgroundColor: const Color(0xFFF16366),
          ),
        )
    ]);
  }
}
