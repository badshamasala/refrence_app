import 'package:aayu/controller/you/switch_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';

class ManageNotification extends StatelessWidget {
  ManageNotification({Key? key}) : super(key: key);

  UserPnSwitchController getController = Get.put(UserPnSwitchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.sp),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Manage Notifications",
                  style: TextStyle(
                      fontFamily: "Baskerville",
                      color: AppColors.blackLabelColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 24.sp),
                ),
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
            Obx(
              () => ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 20.h,
                    );
                  },
                  itemCount: getController
                          .getPnSwitchList.value?.data?.choices?.length ??
                      0,
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.network(
                          getController.getPnSwitchList.value?.data
                                  ?.choices?[index]?.icon ??
                              "",
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(
                          width: 16.sp,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${getController.getPnSwitchList.value?.data?.choices?[index]?.displayText}",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.blueGreyAssessmentColor),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                getController.getPnSwitchList.value?.data
                                        ?.choices?[index]?.desc ??
                                    "",
                                maxLines: null,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF768897)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Obx(
                          () => Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                                activeColor: AppColors.primaryColor,
                                value: getController.getPnSwitchList.value?.data
                                        ?.choices?[index]?.enabled ??
                                    false,
                                onChanged: (value) async {
                                  await getController.checkBoolean(index);
                                  await getController.getUserPnSwitch();
                                }),
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
