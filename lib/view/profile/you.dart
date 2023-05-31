// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/healing/consultant/sessions/doctor_sessions.dart';
import 'package:aayu/view/profile/activation_code/activate_code.dart';
import 'package:aayu/view/profile/help_and_support.dart';
import 'package:aayu/view/profile/manage_notification.dart';
import 'package:aayu/view/profile/payment_history.dart';
import 'package:aayu/view/profile/reminders.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:aayu/controller/you/you_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/onboarding/onboarding.dart';
import 'package:aayu/view/profile/edit_profile.dart';
import 'package:aayu/view/profile/experts_i_follow.dart';
import 'package:aayu/view/profile/favourites.dart';
import 'package:aayu/view/profile/my_subscriptions.dart';
import 'package:aayu/view/profile/settings.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shimmer/shimmer.dart';

class YouPage extends StatefulWidget {
  const YouPage({Key? key}) : super(key: key);

  @override
  State<YouPage> createState() => _YouPageState();
}

class _YouPageState extends State<YouPage> {
  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  late YouController youController;

  @override
  initState() {
    youController = Get.find<YouController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: true,
            floating: true,
            centerTitle: true,
            title: null,
            titleSpacing: 0,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 252.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage(Images.planSummaryBGImage),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(185.w),
                        bottomRight: Radius.circular(185.w),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 113.h,
                    child: Obx(() {
                      if (youController.userDetails.value == null) {
                        return const Offstage();
                      } else if (youController.userDetails.value!.userDetails ==
                          null) {
                        return const Offstage();
                      }
                      return Text(
                        "${youController.userDetails.value!.userDetails!.firstName ?? ""} ${youController.userDetails.value!.userDetails!.lastName ?? ""}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: "Baskerville",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    }),
                  ),
                  Positioned(
                    top: 163.2.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            showImagePickerBottomSheet();
                          },
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                width: 137.18.w,
                                height: 137.18.h,
                                decoration: const BoxDecoration(
                                  color: AppColors.whiteColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Obx(
                                  () {
                                    if (youController.userDetails.value ==
                                        null) {
                                      return showDefaultProfileImage();
                                    } else if (youController
                                            .userDetails.value!.userDetails ==
                                        null) {
                                      return showDefaultProfileImage();
                                    } else if (youController.userDetails.value!
                                        .userDetails!.profilePic!.isEmpty) {
                                      return showDefaultProfileImage();
                                    }

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(400),
                                      child: ShowNetworkImage(
                                        imgPath:
                                            "${youController.userDetails.value!.userDetails!.profilePic!}?${DateTime.now().toIso8601String()}", //added so that image is not cached when changed
                                        imgWidth: 137.18.h,
                                        imgHeight: 137.18.h,
                                        boxFit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 108.71.h,
                                left: 100.7.w,
                                child: Container(
                                  width: 23.w,
                                  height: 23.h,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    AppIcons.editSVG,
                                    color: AppColors.whiteColor,
                                    width: 11.03.w,
                                    height: 11.16.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        InkWell(
                          onTap: () async {
                            if (globalUserIdDetails?.userId == null) {
                              userLoginDialog({"screenName": "YOU"});
                              return;
                            }
                            String? updated = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => const EditProfile(),
                            ));

                            if (updated != null && updated.isNotEmpty) {
                              youController.showUpdatedProfile();
                            }
                          },
                          child: Text(
                            globalUserIdDetails?.userId == null
                                ? "LOGIN".tr
                                : "EDIT_MY_PROFILE".tr,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              decoration: TextDecoration.underline,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              collapseMode: CollapseMode.parallax,
              centerTitle: true,
            ),
            expandedHeight: (272 + 48.19).h,
            backgroundColor: const Color.fromRGBO(255, 248, 248, 0.8),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color.fromRGBO(255, 248, 248, 0.8),
              padding: EdgeInsets.only(top: 24.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  minutesSummary(),
                  // const LoyaltyPoints(),
                  SizedBox(
                    height: 26.h,
                  ),
                  buildLinks(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showDefaultProfileImage() {
    if (imageFile == null) {
      String genderImage = Images.maleImage;

      if (youController.userDetails.value != null &&
          youController.userDetails.value!.userDetails != null &&
          youController.userDetails.value!.userDetails!.gender!.isNotEmpty) {
        if (youController.userDetails.value!.userDetails!.gender!
                .toUpperCase() ==
            "MALE") {
          genderImage = Images.maleImage;
        } else if (youController.userDetails.value!.userDetails!.gender!
                .toUpperCase() ==
            "FEMALE") {
          genderImage = Images.femaleImage;
        } else {
          genderImage = Images.nonBinaryImage;
        }
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.asset(
          genderImage,
          width: 137.18.w,
          height: 137.18.h,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.file(
          imageFile!,
          width: 137.18.w,
          height: 137.18.h,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Future<void> changePhoto(ImageSource imageSource) async {
    final image = await _picker.pickImage(
      source: imageSource,
      preferredCameraDevice: CameraDevice.front,
      maxHeight: 1500,
      maxWidth: 1500,
    );
    if (image != null) {
      final path = image.path;
      final File? croppedFile = await ImageCropper().cropImage(
          sourcePath: path,
          cropStyle: CropStyle.circle,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          androidUiSettings: const AndroidUiSettings(
            showCropGrid: false,
            backgroundColor: Colors.black,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            toolbarTitle: 'Move and Scale',
          ),
          iosUiSettings: const IOSUiSettings(
            title: 'Move and Scale',
          ));

      if (croppedFile != null) {
        imageFile = croppedFile;
        buildShowDialog(context);
        bool isUploaded = await youController.uploadProfileImage(imageFile!);
        Navigator.pop(context);
        if (isUploaded == true) {
          youController.showUpdatedProfile();
          setState(() {});
        }
      }
    }
  }

  showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      )),
      builder: (context) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 48.h,
            ),
            Text(
              'PROFILE_PHOTO'.tr,
              style: AppTheme.secondarySmallFontTitleTextStyle,
            ),
            SizedBox(
              height: 41.h,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                changePhoto(ImageSource.camera);
              },
              child: mainButton('CAMERA'.tr),
            ),
            SizedBox(
              height: 17.h,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                changePhoto(ImageSource.gallery);
              },
              child: mainButton('GALLERY'.tr),
            ),
            SizedBox(
              height: 20.h,
            ),
            TextButton(
                onPressed: () async {
                  buildShowDialog(context);
                  bool isRemoved = await youController.removeProfileImage();
                  Navigator.pop(context);
                  if (isRemoved == true) {
                    youController.showUpdatedProfile();
                    Navigator.pop(context);
                  } else {
                    showGetSnackBar("UNABLE_TO_REMOVE_PROFILE_PHOTO".tr,
                        SnackBarMessageTypes.Error);
                  }
                },
                child: Text(
                  'DELETE'.tr,
                  style: skipButtonTextStyle(),
                )),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  buildLinks() {
    bool isSubscribed = false;

    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null) {
      isSubscribed = true;
    }

    return GetBuilder<YouController>(
      builder: (linksController) {
        if (linksController.linksData.links == null) {
          return const Offstage();
        } else if (linksController.linksData.links!.isEmpty) {
          return const Offstage();
        }

        return Container(
          padding: EdgeInsets.symmetric(vertical: 62.h, horizontal: 28.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.w),
              topRight: Radius.circular(32.w),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              linksController.linksData.links!.length,
              (index) {
                if (isSubscribed == false &&
                    (linksController.linksData.links![index]!.title ==
                        "Reminders")) {
                  return const Offstage();
                }
                if (Platform.isIOS &&
                    linksController.linksData.links![index]!.title ==
                        "Rate App") {
                  return const Offstage();
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        EventsService().sendEvent("You_Options_Clicked", {
                          "option":
                              linksController.linksData.links![index]!.title
                        });

                        handleClick(
                            linksController.linksData.links![index]!.title!);
                      },
                      child: ListTile(
                        isThreeLine: false,
                        dense: false,
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        leading: SvgPicture.asset(
                          linksController.linksData.links![index]!.icon!,
                          color: AppColors.primaryColor,
                          width:
                              linksController.linksData.links![index]!.width!.w,
                          height: linksController
                              .linksData.links![index]!.height!.h,
                        ),
                        title: Text(
                          linksController.linksData.links![index]!.title!,
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
                    Visibility(
                      visible: (index !=
                          linksController.linksData.links!.length - 1),
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                        child: Divider(
                          height: 1,
                          color: const Color(0xFFA4B1B9).withOpacity(0.3),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  handleClick(String title) async {
    switch (title) {
      case "Experts I Follow":
        if (globalUserIdDetails?.userId == null) {
          userLoginDialog({"screenName": "YOU"});
          return;
        }
        EventsService().sendClickNextEvent(
            "YouPage", "Experts I Follow", "ExpertsIFollow");
        Get.to(const ExpertsIFollow())!.then((value) {
          EventsService()
              .sendClickBackEvent("ExpertsIFollow", "Back", "YouPage");
        });
        break;
      case "Favourites":
        if (globalUserIdDetails?.userId == null) {
          userLoginDialog({"screenName": "YOU"});
          return;
        }
        EventsService()
            .sendClickNextEvent("YouPage", "Favourites", "Favourites");
        Get.to(const Favourites())!.then((value) {
          EventsService().sendClickBackEvent("Favourites", "Back", "YouPage");
        });
        break;
      case "My Subscriptions":
        if (globalUserIdDetails?.userId == null) {
          userLoginDialog({"screenName": "YOU"});
          return;
        }
        EventsService().sendClickNextEvent(
            "YouPage", "My Subscriptions", "MySubscriptions");
        Get.to(const MySubscriptions())!.then((value) {
          EventsService()
              .sendClickBackEvent("MySubscriptions", "Back", "YouPage");
        });
        break;
      case "Manage Notifications":
        Get.to(ManageNotification());
        break;
      case "Doctor Sessions":
        if (globalUserIdDetails?.userId == null) {
          userLoginDialog({"screenName": "YOU"});
          return;
        }
        EventsService()
            .sendClickNextEvent("YouPage", "Doctor Sessions", "DoctorSessions");
        Get.to(const DoctorSessions())!.then((value) {
          EventsService()
              .sendClickBackEvent("DoctorSessions", "Back", "YouPage");
        });
        break;
      case "Settings":
        EventsService().sendClickNextEvent("YouPage", "Settings", "Settings");
        Get.to(const Settings())!.then((value) {
          EventsService().sendClickBackEvent("Settings", "Back", "YouPage");
        });
        break;
      case "Help and Support":
        if (globalUserIdDetails?.userId == null) {
          userLoginDialog({"screenName": "YOU"});
          return;
        }
        EventsService().sendClickNextEvent(
            "YouPage", "Help and Support", "HelpAndSupport");
        Get.to(const HelpAndSupport())!.then((value) {
          EventsService()
              .sendClickBackEvent("HelpAndSupport", "Back", "YouPage");
        });
        break;
      case "Reminders":
        if (globalUserIdDetails?.userId == null) {
          userLoginDialog({"screenName": "YOU"});
          return;
        }
        EventsService().sendClickNextEvent("YouPage", "Reminders", "Reminders");
        Get.to(const Reminders())!.then((value) {
          EventsService().sendClickBackEvent("Reminders", "Back", "YouPage");
        });
        break;
      case "Edit My Preferences":
        if (globalUserIdDetails?.userId == null) {
          userLoginDialog({"screenName": "YOU"});
          return;
        }
        EventsService()
            .sendClickNextEvent("YouPage", "Edit my Preferences", "Onboarding");
        Get.to(const Onboarding(
          showSkip: false,
        ))!
            .then((value) {
          EventsService().sendClickBackEvent("Onboarding", "Back", "YouPage");
        });
        break;
      case "Share App":
        buildShowDialog(context);
        await ShareService().shareApp();
        Navigator.pop(context);
        break;
      case "Payment History":
        Get.to(const PaymentHistory());
        break;
      case "Enter Activation Code":
        Get.to(const ActivationCode());
        break;
      case "Rate App":
        try {
          LaunchReview.launch();
        } catch (error) {
          rethrow;
        }
        break;
    }
  }

  Widget minutesLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerColorDark,
      highlightColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          3,
          (index) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              color: AppColors.shimmerColorDark,
            ),
            margin:
                index == 2 ? EdgeInsets.zero : const EdgeInsets.only(right: 8),
            height: 130.h,
            width: 102.w,
          ),
        ),
      ),
    );
  }

  minutesSummary() {
    return GetBuilder<YouController>(
      builder: (summaryController) {
        if (summaryController.isMinutesSummaryLoading.value == true) {
          return minutesLoading();
        } else if (summaryController.minutesSummary.value == null) {
          return const Offstage();
        } else if (summaryController.minutesSummary.value!.summary == null) {
          return const Offstage();
        } else if (summaryController.minutesSummary.value!.summary!.isEmpty) {
          return const Offstage();
        }

        return SizedBox(
          width: 322.49.w,
          height: 177.37.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              summaryController.minutesSummary.value!.summary!.length,
              (index) {
                return Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: (index ==
                              summaryController
                                      .minutesSummary.value!.summary!.length -
                                  1)
                          ? EdgeInsets.zero
                          : EdgeInsets.only(right: 8.w),
                      height: 130.h,
                      width: 102.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E4),
                        borderRadius: BorderRadius.circular(16.w),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40.5.h,
                          ),
                          Text(
                            summaryController
                                .minutesSummary.value!.summary![index]!.count
                                .toString(),
                            style: TextStyle(
                              color: AppColors.blackLabelColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          SizedBox(
                            height: 50.h,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                summaryController.minutesSummary.value!
                                    .summary![index]!.section!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: summaryController.minutesSummary.value!
                          .summary![index]!.postion!.top!.h,
                      child: Image(
                        image: AssetImage(
                          summaryController.minutesSummary.value!
                              .summary![index]!.image!.imageUrl!,
                        ),
                        width: summaryController.minutesSummary.value!
                            .summary![index]!.image!.width!.w,
                        height: summaryController.minutesSummary.value!
                            .summary![index]!.image!.height!.h,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
