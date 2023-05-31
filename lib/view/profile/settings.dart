import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/controller/payment/juspay_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/controller/you/settings_controller.dart';
import 'package:aayu/services/hive.service.dart';
import 'package:aayu/services/onboarding.service.dart';
import 'package:aayu/services/subscription.service.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = Get.put(SettingsController());
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              width: 25.w,
            ),
            Text(
              'SETTINGS'.tr,
              style: AppTheme.secondarySmallFontTitleTextStyle,
            ),
          ]),
          buildLinks(),
          Obx(() {
            return (settingsController.showCheatLinks.value == true)
                ? Column(
                    children: [
                      buildDeleteProgramSubscription(
                          context, settingsController.mobileNumber.value),
                      buildDeleteAccount(
                          context, settingsController.mobileNumber.value)
                    ],
                  )
                : const Offstage();
          }),
          SizedBox(
            height: 50.h,
          ),
          Obx(() {
            return Text(
              "Version: ${settingsController.buildNumber.value}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: AppColors.secondaryLabelColor.withOpacity(0.2),
                height: 1.h,
              ),
            );
          }),
          const Spacer(),
          if (globalUserIdDetails?.userId != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: buildTile('Log Out', AppIcons.lockLogoutSVG, () {
                logout(context);
              }, false),
            ),
          SizedBox(
            height: 26.h,
          ),
        ],
      ),
    );
  }

  Future<void> logout(context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Container(
          padding:
              EdgeInsets.only(top: 32.h, bottom: 24.h, left: 24.w, right: 24.w),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LOGOUT'.tr,
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Circular Std"),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                'WOULD_YOU_LIKE_TO_SIGN_OUT_OF_AAYU_TXT'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Circular Std"),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromRGBO(86, 103, 137, 0.26),
                                  width: 1),
                              borderRadius: BorderRadius.circular(100)),
                          padding: EdgeInsets.symmetric(vertical: 9.h)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CANCEL'.tr,
                        style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          padding: EdgeInsets.symmetric(vertical: 9.h)),
                      onPressed: () async {
                        JuspayController juspayController = Get.find();
                        await juspayController.terminateHyperSDK();
                        await HiveService().clearAllCachedData();
                        await Get.deleteAll(force: true);
                        globalUserIdDetails = null;
                        EventsService().sendClickNextEvent(
                            "Settings", "Logout", "SplashScreen");
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(
                              fromLogout: true,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'YES'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  buildLinks() {
    return Container(
      padding: EdgeInsets.only(top: 50.h, left: 28.w, right: 28.w),
      width: double.infinity,
      color: AppColors.whiteColor,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTile('Privacy Policy', AppIcons.privacySVG, () {
              launchCustomUrl("https://www.resettech.in/privacy-policy.html");
            }, true),
            buildTile('Terms and Conditions', AppIcons.tAndCSVG, () {
              launchCustomUrl("https://www.resettech.in/terms-of-use.html");
            }, true),
            buildTile('Disclaimer', AppIcons.disclaimerSVG, () {
              launchCustomUrl("https://www.resettech.in/disclaimer.html");
            }, true),

            /* GetBuilder<SettingsController>(
              builder: (controller) => InkWell(
                onTap: () {},
                child: ListTile(
                    isThreeLine: false,
                    dense: false,
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    leading: SvgPicture.asset(
                      AppIcons.notificationSVG,
                      color: AppColors.primaryColor,
                      width: 22.w,
                      fit: BoxFit.fitWidth,
                    ),
                    title: Text(
                      'Notifications',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: AppColors.secondaryLabelColor,
                        height: 1.h,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                      value: controller.showNotification.value,
                      onChanged: (val) {
                        controller.switchNotification();
                      },
                      activeColor: AppColors.primaryColor,
                    )),
              ),
            ), */
          ]),
    );
  }

  buildTile(String title, String image, Function function, bool showUnderLine) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            function();
          },
          child: ListTile(
            isThreeLine: false,
            dense: false,
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            leading: SvgPicture.asset(
              image,
              color: AppColors.primaryColor,
              width: 22.w,
              fit: BoxFit.fitWidth,
            ),
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: AppColors.secondaryLabelColor,
                height: 1.h,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFCDCEDC),
              size: 16,
            ),
          ),
        ),
        if (showUnderLine) buildUnderliner()
      ],
    );
  }

  buildUnderliner() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
      child: Divider(
        height: 1,
        color: const Color(0xFFA4B1B9).withOpacity(0.3),
      ),
    );
  }

  buildDeleteProgramSubscription(BuildContext context, String mobileNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          ListTile(
            isThreeLine: false,
            dense: false,
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            leading: const Icon(
              Icons.delete_outline,
              color: AppColors.primaryColor,
            ),
            title: Text(
              'Delete Program Subscription',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: AppColors.secondaryLabelColor,
                height: 1.h,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFCDCEDC),
              size: 16,
            ),
            onTap: () {
              confirmDeleteProgramSubscription(context, mobileNumber);
            },
          ),
          buildUnderliner()
        ],
      ),
    );
  }

  buildDeleteAccount(BuildContext context, String mobileNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          ListTile(
            isThreeLine: false,
            dense: false,
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            leading: const Icon(
              Icons.delete_forever_outlined,
              color: AppColors.primaryColor,
            ),
            title: Text(
              'Delete Account',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: AppColors.secondaryLabelColor,
                height: 1.h,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFCDCEDC),
              size: 16,
            ),
            onTap: () {
              confirmDeleteAccount(context, mobileNumber);
            },
          ),
          buildUnderliner()
        ],
      ),
    );
  }

  confirmDeleteProgramSubscription(
      BuildContext context, String mobileNumber) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Container(
          padding:
              EdgeInsets.only(top: 32.h, bottom: 24.h, left: 24.w, right: 24.w),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete Program Subscription',
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Circular Std"),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                'Would you like to delete program subscription?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Circular Std",
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromRGBO(86, 103, 137, 0.26),
                                  width: 1),
                              borderRadius: BorderRadius.circular(100)),
                          padding: EdgeInsets.symmetric(vertical: 9.h)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CANCEL'.tr,
                        style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          padding: EdgeInsets.symmetric(vertical: 9.h)),
                      onPressed: () async {
                        buildShowDialog(context);
                        bool isDeleted = await SubscriptionService()
                            .deleteSubscription(mobileNumber);
                        Navigator.pop(context);
                        Navigator.pop(context);

                        if (isDeleted == true) {
                          SubscriptionController subscriptionController =
                              Get.find();
                          subscriptionController.checkSubscription();
                          MyRoutineController myRoutineController = Get.find();
                          myRoutineController.getData();
                          showCustomSnackBar(
                              context, "Subscription has been deleted!");
                          Navigator.pop(context);
                        } else {
                          showCustomSnackBar(
                              context, "Failed To Delete Subscription");
                        }
                      },
                      child: Text(
                        'YES'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Circular Std",
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  confirmDeleteAccount(BuildContext context, String mobileNumber) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Container(
          padding:
              EdgeInsets.only(top: 32.h, bottom: 24.h, left: 24.w, right: 24.w),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete Account',
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Circular Std"),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                'Would you like to delete Account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Circular Std",
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromRGBO(86, 103, 137, 0.26),
                                  width: 1),
                              borderRadius: BorderRadius.circular(100)),
                          padding: EdgeInsets.symmetric(vertical: 9.h)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CANCEL'.tr,
                        style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        padding: EdgeInsets.symmetric(vertical: 9.h),
                      ),
                      onPressed: () async {
                        buildShowDialog(context);
                        bool isDeleted =
                            await OnboardingService().deleteUser(mobileNumber);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        if (isDeleted == true) {
                          JuspayController juspayController = Get.find();
                          await juspayController.terminateHyperSDK();
                          await HiveService().clearAllCachedData();
                          await Get.deleteAll(force: true);
                          EventsService().sendClickNextEvent(
                              "Settings", "Delete Account", "SplashScreen");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SplashScreen(
                                fromLogout: true,
                              ),
                            ),
                          );
                        } else {
                          showCustomSnackBar(
                              context, "Failed To Delete Account");
                        }
                      },
                      child: Text(
                        'YES'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
