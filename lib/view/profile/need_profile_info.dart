// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/you/edit_profile_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/shared/ui_helper/new_cupertino_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NeedProfileInfo extends StatelessWidget {
  const NeedProfileInfo({Key? key}) : super(key: key);

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    EditProfileController editProfileController =
        Get.put(EditProfileController());
    Future.delayed(Duration.zero, () {
      editProfileController.setUserDetails();
    });
    return  Container(
        padding: pagePadding(),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFEEFEF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.w),
            topRight: Radius.circular(30.w),
          ),
        ),
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                Text(
                  "You are unique".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w700,
                    height: 1.h,
                  ),
                ),
                SizedBox(height: 26.h,),
                Form(
                  key: _formKey,
                  child: GetBuilder<EditProfileController>(
                    builder: (controller) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel("Tell us your Name"),
                        buildName(editProfileController),
                        buildLabel("Your identity is important to us"),
                        buildGender(editProfileController),
                        buildLabel("Tell us your Birthdate"),
                        buildDOB(context, editProfileController),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 26.h,
                ),
                InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    bool isValid = _formKey.currentState!.validate();
                    if (isValid == true) {
                      buildShowDialog(context);
                      bool isUpdated =
                          await editProfileController.updateUserProfile();
                      Navigator.of(context).pop();
                      if (isUpdated == true) {
                        Navigator.of(context).pop("updated");
                      } else {
                        showGetSnackBar("FAILED_TO_UPDATE_PROFILE".tr,
                            SnackBarMessageTypes.Error);
                      }
                    }
                  },
                  child: mainButton('Next'),
                ),
              ],
            ),
            Positioned(
              top: 0.h,
              left: 0.h,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.secondaryLabelColor,
                ),
              ),
            ),
          ],
        ),
      
    );
  }

  buildName(EditProfileController editProfileController) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
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
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: editProfileController.firstNameTextEditingController,
        style: AppTheme.inputEditProfileTextStyle,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
        ],
        decoration: const InputDecoration(
          hintStyle: AppTheme.hintTextStyle,
          errorStyle: AppTheme.errorTextStyle,
          hintText: 'Name',
          labelStyle: AppTheme.hintTextStyle,
          border: UnderlineInputBorder(
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
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.errorColor, width: 3),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        validator: (val) {
          if (val == null) {
            'Please enter your name.';
          }
          if (val!.trim().isEmpty) {
            return 'Please enter your name.';
          }
          return null;
        },
      ),
    );
  }

  buildGender(EditProfileController editProfileController) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          editProfileController.genderList.length,
          (index) => GestureDetector(
            onTap: () {
              editProfileController
                  .setGender(editProfileController.genderList[index]);
            },
            child: Container(
              padding: EdgeInsets.zero,
              margin: (index == 1)
                  ? EdgeInsets.symmetric(horizontal: 11.w)
                  : EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleCheckbox(
                    activeColor: AppColors.primaryColor,
                    value: editProfileController.genderList[index] ==
                            editProfileController.gender.value
                        ? true
                        : false,
                    onChanged: (value) {
                      editProfileController
                          .setGender(editProfileController.genderList[index]);
                    },
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    editProfileController.genderList[index],
                    style: primaryFontPrimaryLabelSmallTextStyle(),
                  ),
                ],
              ),
            ),
          ),
        ).toList(),
      ),
    );
  }

  buildDOB(BuildContext context, EditProfileController editProfileController) {
    return InkWell(
      onTap: () {
        selectBirthDate(context, editProfileController);
      },
      child: Container(
        padding: EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
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
            Expanded(
              child: TextFormField(
                enabled: false,
                readOnly: true,
                controller:
                    editProfileController.birthdateTextEditingController,
                style: AppTheme.inputEditProfileTextStyle,
                decoration: InputDecoration(
                  hintStyle: AppTheme.hintTextStyle,
                  errorStyle: AppTheme.errorTextStyle,
                  hintText: 'BIRTHDATE'.tr,
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
                  errorBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.errorColor, width: 3),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
                validator: (val) {
                  if (editProfileController.birthdateTextEditingController.text
                      .trim()
                      .isEmpty) {
                    return 'Please select your birthdate';
                  }
                  return null;
                },
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: AppColors.primaryColor,
            ),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  buildLabel(String labelText) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0.w, bottom: 12.h),
      child: Text(
        labelText,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: AppColors.secondaryLabelColor,
          fontSize: 14.sp,
          letterSpacing: 0,
          fontWeight: FontWeight.w400,
          height: 1.18.h,
        ),
      ),
    );
  }

  Widget _buildBottomPicker(BuildContext context, Widget picker,
      EditProfileController editProfileController) {
    return Container(
      height: 438.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      )),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: AppColors.blackLabelColor,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: Padding(
              padding: pagePadding(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.blackLabelColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(child: picker),
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (editProfileController.selectedDate != null) {
                        editProfileController
                            .setBirthdate(editProfileController.selectedDate!);
                      }
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: 158.w,
                      child: mainButton("SELECT".tr),
                    ),
                  ),
                  pageBottomHeight()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  selectBirthDate(
      BuildContext context, EditProfileController editProfileController) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (BuildContext context) {
        return _buildBottomPicker(
            context,
            StatefulBuilder(
              builder: (context, setState) => NewCupertinoDatePicker(
                textColor: AppColors.blackLabelColor,
                overlayColor: const Color.fromRGBO(252, 175, 175, 0.2),
                dateOrder: DatePickerDateOrder.dmy,
                mode: NewCupertinoDatePickerMode.date,
                backgroundColor: Colors.white,
                initialDateTime: editProfileController.initialDate,
                minimumYear: editProfileController.firstDate.year,
                maximumYear: editProfileController.lastDate.year,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    editProfileController.selectedDate = newDateTime;
                    editProfileController.initialDate = newDateTime;
                  });
                },
              ),
            ),
            editProfileController);
      },
    );
  }
}
