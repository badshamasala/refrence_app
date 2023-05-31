import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/content_details/content_details.dart';
import 'package:aayu/view/content/widgets/premium_content.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/previous_subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../subscription/subscribe_to_aayu.dart';

class RecommendedContent extends StatelessWidget {
  final Content contentData;
  final String heroTag;
  const RecommendedContent(
      {Key? key, required this.contentData, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!(subscriptionCheckResponse != null &&
                subscriptionCheckResponse!.subscriptionDetails != null &&
                subscriptionCheckResponse!
                    .subscriptionDetails!.subscriptionId!.isNotEmpty) &&
            contentData.metaData!.isPremium == true) {
          buildShowDialog(context);
          SubscriptionController subscriptionController = Get.find();
          await subscriptionController.getPreviousSubscriptionDetails();
          Navigator.pop(context);
          if (subscriptionController.previousSubscriptionDetails.value !=
                  null &&
              subscriptionController
                      .previousSubscriptionDetails.value!.subscriptionDetails !=
                  null) {
            EventsService()
                .sendClickNextEvent("Content", "Play", "PreviousSubscription");
            Get.bottomSheet(
              const PreviousSubscription(),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
            );
          } else {
            bool isAllowed = await checkIsPaymentAllowed("GROW");
            if (isAllowed == true) {
              EventsService()
                  .sendClickBackEvent("Content", "Details", "SubscribeToAayu");
              Get.bottomSheet(
                SubscribeToAayu(subscribeVia: "CONTENT", content: contentData),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            }
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContentDetails(
                source: "",
                heroTag: heroTag,
                contentId: contentData.contentId!,
                categoryContent: [contentData],
              ),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.w),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Hero(
              tag: heroTag,
              child: ShowNetworkImage(
                imgPath: contentData.contentImage!,
                imgWidth: double.infinity.w,
                imgHeight: 360.h,
                boxFit: BoxFit.cover,
                placeholderImage: "assets/images/placeholder/default_home.jpg",
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 270.h,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 1),
                      Color.fromRGBO(0, 0, 0, 0)
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40.h,
              child: Text(
                "RECOMMENDED_FOR_YOU".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontFamily: 'Circular Std',
                  fontSize: 12.sp,
                  letterSpacing: 1.5.w,
                  fontWeight: FontWeight.w400,
                  height: 1.16.h,
                ),
              ),
            ),
            Positioned(
              bottom: 26.h,
              child: Padding(
                padding: pageHorizontalPadding(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PremiumContent(
                      color: Colors.white,
                      isPremiumContent: contentData.metaData!.isPremium!,
                    ),
                    Visibility(
                      visible: contentData.metaData!.isPremium == true,
                      child: SizedBox(
                        height: 14.h,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 60.w,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 27.w),
                        child: Text(
                          contentData.contentName!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: 'Baskerville',
                            fontSize: 24.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1.16.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Visibility(
                      visible:
                          appProperties.content!.display!.artistName == true,
                      child: Text(
                        contentData.artist!.artistName ?? "",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: 'Circular Std',
                          fontSize: 12.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.6666666666666667.h,
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          appProperties.content!.display!.contentTag == true,
                      child: Text(
                        contentData.metaData!.contentTag ?? "",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: 'Circular Std',
                          fontSize: 12.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.6666666666666667.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    SizedBox(
                      width: 120.w,
                      height: 36.h,
                      child: growButton("Explore"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
