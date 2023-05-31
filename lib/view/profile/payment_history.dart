import 'package:aayu/controller/you/payment_history_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/profile/view_invoice_pdf.dart';
import 'package:aayu/view/shared/ui_helper/icons.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PaymentHistoryController paymentHistoryController =
        Get.put(PaymentHistoryController());
    paymentHistoryController.getPaymentHistory();
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
            const Text(
              "Payment History",
              style: AppTheme.secondarySmallFontTitleTextStyle,
            ),
          ]),
          Expanded(
            child: Obx(() {
              if (paymentHistoryController.isLoading.value == true) {
                return showLoading();
              } else if (paymentHistoryController.invoiceData.value == null) {
                return noInvoices();
              } else if (paymentHistoryController.invoiceData.value!.invoices ==
                  null) {
                return noInvoices();
              } else if (paymentHistoryController
                  .invoiceData.value!.invoices!.isEmpty) {
                return noInvoices();
              }
              return ListView.separated(
                itemCount: paymentHistoryController
                    .invoiceData.value!.invoices!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String invoicePath = paymentHistoryController
                          .invoiceData.value!.invoices![index]!.invoicePath ??
                      "";
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 26.w, vertical: 13.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                paymentHistoryController
                                        .invoiceData
                                        .value!
                                        .invoices![index]
                                        ?.purchaseDetails
                                        ?.first
                                        ?.perticular ??
                                    "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.h,
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                paymentHistoryController.invoiceData.value!
                                        .invoices![index]?.invoiceNumber ??
                                    "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.h,
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                "Amount - ${paymentHistoryController.invoiceData.value!.invoices![index]?.purchaseDetails?.first?.currency} ${paymentHistoryController.invoiceData.value!.invoices![index]?.totalAmount} paid on ${DateFormat('MMM dd, yyyy hh:mm a').format(dateFromTimestamp(paymentHistoryController.invoiceData.value!.invoices![index]!.createdAt!))}",
                                style: TextStyle(
                                  color: const Color(0xFF768897),
                                  fontFamily: 'Circular Std',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        invoicePath.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  try {
                                    Get.to(ViewInvoicePDF(
                                        pdfUrl: invoicePath,
                                        headerText: paymentHistoryController
                                                .invoiceData
                                                .value!
                                                .invoices![index]
                                                ?.invoiceNumber ??
                                            ""));
                                  } catch (err) {
                                    print(err);
                                  }
                                },
                                child: SvgPicture.asset(
                                  AppIcons.downloadPDFSVG,
                                  color: AppColors.primaryColor,
                                  width: 20.w,
                                  height: 30.h,
                                ),
                              )
                            : const Offstage()
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: const Color(0xFFA4B1B9).withOpacity(0.3),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }

  noInvoices() {
    return SizedBox(
      width: 228.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.paymentHistorySVG,
            color: AppColors.primaryColor,
            width: 54.w,
            height: 60.h,
          ),
          SizedBox(
            height: 26.h,
          ),
          Text(
            "We believe that you have not made any purchases on Aayu",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: "Baskerville",
              fontWeight: FontWeight.w400,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          Text(
            "OR",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: "Baskerville",
              fontWeight: FontWeight.w400,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          Text(
            "There is no available invoice at this time.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: "Baskerville",
              fontWeight: FontWeight.w400,
              fontSize: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}
