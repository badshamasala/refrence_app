import 'package:aayu/controller/subscription/offers_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/subscription/offers/widgets/offers_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../shared/shared.dart';

class AayuOffers extends StatelessWidget {
  final String offerOn;
  const AayuOffers({Key? key, required this.offerOn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var focusNode = FocusNode();
    OffersController offersController = Get.isRegistered<OffersController>()
        ? Get.find<OffersController>()
        : Get.put(OffersController());
    offersController.getPromoCodeDetails(offerOn);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
        ),
        body: Obx(() {
          if (offersController.isLoading.value == true) {
            return showLoading();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                child: Text(
                  'Aayu Offers',
                  style: TextStyle(
                    fontFamily: 'Baskerville',
                    fontWeight: FontWeight.w400,
                    color: AppColors.bottomNavigationLabelColor,
                    fontSize: 26.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              GetBuilder<OffersController>(
                builder: (controller) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 26.w),
                      padding: EdgeInsets.only(
                          left: 14.w, right: 25.w, top: 5.h, bottom: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(64, 117, 205, 0.08),
                            offset: Offset(0, 10),
                            blurRadius: 20,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            Images.applyOfferPercentImage,
                            width: 29.w,
                            fit: BoxFit.fitWidth,
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: focusNode,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                              ],
                              controller:
                                  offersController.applyOfferEditingController,
                              style: AppTheme.inputEditProfileTextStyle,
                              onChanged: ((value) {
                                controller.update();
                              }),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(
                                        143, 157, 168, 0.7)),
                                errorStyle: AppTheme.errorTextStyle,
                                hintText: 'Type coupon code here',
                                labelStyle: AppTheme.hintTextStyle,
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                isDense: true,
                                filled: true,
                                fillColor: AppColors.whiteColor,
                                focusColor: AppColors.whiteColor,
                                hoverColor: AppColors.whiteColor,
                              ),
                            ),
                          ),
                          offersController.isApplyOfferLoading.value
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.h,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : TextButton(
                                  onPressed: offersController
                                          .applyOfferEditingController.text
                                          .trim()
                                          .isNotEmpty
                                      ? () {
                                          focusNode.unfocus();
                                          EventsService().sendEvent(
                                              "Promo_Code_Searched", {
                                            "offer_on": offerOn,
                                            "promo_code": offersController
                                                .applyOfferEditingController
                                                .text
                                                .trim()
                                          });
                                          offersController
                                              .postCouponCodeText(offerOn);
                                        }
                                      : null,
                                  child: Text(
                                    'APPLY',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: offersController
                                                .applyOfferEditingController
                                                .text
                                                .trim()
                                                .isNotEmpty
                                            ? const Color(0xFFFF7B7B)
                                            : const Color(0xFF9C9EB9)),
                                  ))
                        ],
                      ),
                    ),
                    if (offersController.errorMessage.isNotEmpty)
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40.w),
                            height: 3.h,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Color(0xFFF16366),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 9.h,
                          ),
                          Text(
                            offersController.errorMessage,
                            style: TextStyle(
                                color: const Color(0xFFF16366),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      activeOffers(offersController),
                      otherOffers(offersController)
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }

  activeOffers(OffersController offersController) {
    if (offersController.promoCodeDetails.value == null) {
      return noOffersAvailable();
    } else if (offersController.promoCodeDetails.value!.active == null) {
      return noOffersAvailable();
    } else if (offersController.promoCodeDetails.value!.active!.isEmpty) {
      return noOffersAvailable();
    }
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: offersController.promoCodeDetails.value!.active!.length,
        itemBuilder: (context, index) {
          return OffersTile(
            active: true,
            promoCode: offersController.promoCodeDetails.value!.active![index],
            offerOn: offerOn,
          );
        });
  }

  noOffersAvailable() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
        child: Text(
          'No active offers available',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: AppColors.blueGreyAssessmentColor),
        ),
      ),
    );
  }

  otherOffers(OffersController offersController) {
    if (offersController.promoCodeDetails.value == null) {
      return const Offstage();
    } else if (offersController.promoCodeDetails.value!.moreOffers == null) {
      return const Offstage();
    } else if (offersController.promoCodeDetails.value!.moreOffers!.isEmpty) {
      return const Offstage();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 26.w, top: 26.h),
          child: Text(
            'Other Offers',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: AppColors.blackLabelColor),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount:
                offersController.promoCodeDetails.value!.moreOffers!.length,
            itemBuilder: (context, index) {
              return OffersTile(
                active: false,
                promoCode:
                    offersController.promoCodeDetails.value!.moreOffers![index],
                offerOn: offerOn,
              );
            }),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
