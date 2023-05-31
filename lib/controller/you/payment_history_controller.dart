import 'package:aayu/model/model.dart';
import 'package:aayu/services/payment.service.dart';
import 'package:get/state_manager.dart';

class PaymentHistoryController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<PaymentInvoiceModel?> invoiceData = PaymentInvoiceModel().obs;
  getPaymentHistory() async {
    try {
      isLoading.value = true;
      PaymentInvoiceModel? response = await PaymentService().getInvoices();
      if (response != null) {
        invoiceData.value = response;
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
