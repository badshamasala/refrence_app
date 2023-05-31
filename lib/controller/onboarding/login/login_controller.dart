import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:intl_phone_field/phone_number.dart';

class LoginController extends GetxController {
  PageController pageController = PageController();
  RxDouble containerHeight = 440.0.h.obs;
  RxInt selectedPage = 0.obs;

  Rx<PhoneNumber> userPhoneNumber =
      PhoneNumber(countryCode: "+91", countryISOCode: "IN", number: "").obs;
  RxBool isValidPhoneNumber = false.obs;
  RxString errorMessage = "".obs;

  TextEditingController phoneNumberController = TextEditingController();

  RxBool isRegistered = true.obs;

  setPhoneNumber() {
    phoneNumberController.text = userPhoneNumber.value.completeNumber;
  }

  updateMobileNumber(PhoneNumber inputPhoneNumber) {
    userPhoneNumber.value = inputPhoneNumber;
  }

  updateIsValidPhoneNumber(bool isValid) {
    isValidPhoneNumber.value = isValid;
  }

  setSelectedPage(int index) {
    switch (index) {
      //Mobile Number
      case 0:
        containerHeight.value = 440.h;
        break;
      // OTP
      case 2:
        containerHeight.value = 355.h;
        break;
      default:
        containerHeight.value = 440.h;
        break;
    }
    selectedPage.value = index;
    update();
  }

  Future<bool?> checkIfRegistered() async {
    String emailId = "";
    CheckRegistrationResponseModel? checkRegistrationResponse =
        await OnboardingService().checkIfRegistered(
            userPhoneNumber.value.completeNumber.replaceAll("+", ""), emailId);

    if (checkRegistrationResponse != null) {
      isRegistered.value = checkRegistrationResponse.isRegister!;
      update();
    }

    return isRegistered.value;
  }
}
