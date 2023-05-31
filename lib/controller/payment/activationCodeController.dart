import 'package:aayu/model/model.dart';
import 'package:aayu/services/payment.service.dart';
import 'package:aayu/services/services.dart';
import 'package:get/state_manager.dart';

class ActivationCodeController extends GetxController {
  Rx<ActivationCodeVailidateModel?> activationCodeResponse =
      ActivationCodeVailidateModel().obs;

  Future<void> validateCode(String activationCode) async {
    try {
      activationCodeResponse.value = null;
      String country = "";
      UserDetailsResponse? userDetailsResponse =
          await HiveService().getUserDetails();
      if (userDetailsResponse != null &&
          userDetailsResponse.userDetails != null) {
        if (userDetailsResponse.userDetails!.location != null &&
            userDetailsResponse.userDetails!.location!.isNotEmpty) {
          country =
              userDetailsResponse.userDetails!.location!.first!.country ?? "";
        }
      }
      ActivationCodeVailidateModel? response = await PaymentService()
          .validateActivationCode(activationCode, country);
      if (response != null && response.activationCode != null) {
        if (response.activationCode!.referenceId!.isNotEmpty) {
          activationCodeResponse.value = response;
        }
      }
    } catch (error) {
      print(error);
    } finally {
      update();
    }
  }

  Future<bool> activateCode(String activationCode) async {
    bool isActivated = false;
    try {
      String country = "";
      UserDetailsResponse? userDetailsResponse =
          await HiveService().getUserDetails();
      if (userDetailsResponse != null &&
          userDetailsResponse.userDetails != null) {
        if (userDetailsResponse.userDetails!.location != null &&
            userDetailsResponse.userDetails!.location!.isNotEmpty) {
          country =
              userDetailsResponse.userDetails!.location!.first!.country ?? "";
        }
      }
      isActivated = await PaymentService()
          .activateActivationCode(activationCode, country);
    } catch (error) {
      print(error);
    } finally {
      update();
    }
    return isActivated;
  }
}
