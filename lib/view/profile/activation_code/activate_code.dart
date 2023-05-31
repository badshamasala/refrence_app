import 'package:aayu/controller/payment/activationCodeController.dart';
import 'package:aayu/view/profile/activation_code/activate_activation_code.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';

class ActivationCode extends StatefulWidget {
  const ActivationCode({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivationCode> createState() => _ActivationCodeState();
}

class _ActivationCodeState extends State<ActivationCode> {
  late ActivationCodeController activationCodeController;
  TextEditingController activationCodeInputController = TextEditingController();
  bool validCode = false;

  @override
  initState() {
    if (ActivationCodeController().initialized == true) {
      activationCodeController = Get.find();
    } else {
      activationCodeController = Get.put(ActivationCodeController());
    }
    super.initState();
  }

  @override
  void dispose() {
    activationCodeInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: pagePadding(),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(Images.subscriptionBackground),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0.w,
                top: 26.h,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Enter Activation Code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 22.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.h,
                    ),
                  ),
                  SizedBox(
                    height: 21.h,
                    width: double.infinity,
                  ),
                  Text(
                    "If you have already bought the plan offline or got it free from promotions, You would have gotten an activation code.\nEnter the Valid Activation code here to enable the plan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromRGBO(52, 69, 83, 0.5),
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                        height: 1.5.h),
                  ),
                  SizedBox(
                    height: 36.h,
                  ),
                  Container(
                    width: 280.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 15.w, top: 8.h, bottom: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(64, 117, 205, 0.08),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.center,
                      controller: activationCodeInputController,
                      style: AppTheme.inputEditProfileTextStyle,
                      decoration: const InputDecoration(
                        hintStyle: AppTheme.hintTextStyle,
                        errorStyle: AppTheme.errorTextStyle,
                        hintText: 'Enter Unique Code',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Color.fromRGBO(229, 229, 229, 0.5),
                        focusColor: Color.fromRGBO(229, 229, 229, 0.5),
                        hoverColor: Color.fromRGBO(229, 229, 229, 0.5),
                        errorBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.errorColor, width: 3),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                      ),
                      onChanged: ((value) => setState(() {})),
                      validator: (val) {
                        if (val == null) {
                          'Please enter your Activation Code.';
                        }
                        if (val!.trim().isEmpty) {
                          return 'Please enter your Activation Code.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  SizedBox(
                    width: 220.w,
                    child: (activationCodeInputController.text
                            .trim()
                            .isNotEmpty)
                        ? InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              buildShowDialog(context);
                              ActivationCodeController
                                  activationCodeController = Get.find();
                              await activationCodeController.validateCode(
                                  activationCodeInputController.text.trim());
                              Navigator.pop(context);
                              if (activationCodeController
                                          .activationCodeResponse.value !=
                                      null &&
                                  activationCodeController
                                          .activationCodeResponse
                                          .value!
                                          .activationCode !=
                                      null) {
                                String status = activationCodeController
                                        .activationCodeResponse
                                        .value!
                                        .activationCode!
                                        .status ??
                                    "";
                                if (status == "ACTIVE") {
                                  Get.bottomSheet(
                                    ActivateActivationCode(
                                      activationCodeDetails:
                                          activationCodeController
                                              .activationCodeResponse.value!,
                                    ),
                                    isScrollControlled: true,
                                  );
                                } else if (status == "USED") {
                                  showGetSnackBar("Code already used",
                                      SnackBarMessageTypes.Success);
                                } else {
                                  showGetSnackBar("Please enter valid code!",
                                      SnackBarMessageTypes.Success);
                                }
                              } else {
                                showGetSnackBar("Please enter valid code!",
                                    SnackBarMessageTypes.Success);
                              }
                            },
                            child: mainButton("Validate"),
                          )
                        : disabledButton("Validate"),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
