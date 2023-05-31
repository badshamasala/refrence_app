import 'package:aayu/controller/consultant/psychologist/psychology_initial_assessment_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ObjectiveOptions extends StatelessWidget {
  final PsychologyInitialAssessmentController assessmentController;
  const ObjectiveOptions({
    Key? key,
    required this.assessmentController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: assessmentController
              .initialAssessmentResponse
              .value!
              .assessments![assessmentController.selectedQuestionIndex.value]!
              .objective!
              .options!
              .length,
          itemBuilder: (context, index) {
            return buildOptions(
                context,
                index,
                assessmentController
                        .initialAssessmentResponse
                        .value!
                        .assessments![
                            assessmentController.selectedQuestionIndex.value]!
                        .objective!
                        .optionType ??
                    "");
          },
        ),
        buildOtherOptionInput(),
      ],
    );
  }

  buildOtherOptionInput() {
    return assessmentController.showOtherInputBox == true
        ? Container(
            width: 280.w,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 15.w, top: 8.h, bottom: 8.h),
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
              controller: assessmentController.otherInputController,
              style: const TextStyle(
                color: AppColors.blackLabelColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 6,
              decoration: const InputDecoration(
                hintStyle: AppTheme.hintTextStyle,
                errorStyle: AppTheme.errorTextStyle,
                hintText: 'Your answer here',
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
                  'Please enter your answer.';
                }
                if (val!.trim().isEmpty) {
                  return 'Please enter your answer.';
                }
                return null;
              },
            ),
          )
        : const Offstage();
  }

  buildOptions(BuildContext context, int index, String optionType) {
    return InkWell(
      onTap: () {
        if (assessmentController
                .initialAssessmentResponse
                .value!
                .assessments![assessmentController.selectedQuestionIndex.value]!
                .objective!
                .multiChoice ==
            true) {
          setMultiSelection(
              assessmentController,
              index,
              assessmentController
                  .initialAssessmentResponse
                  .value!
                  .assessments![
                      assessmentController.selectedQuestionIndex.value]!
                  .objective!
                  .options![index]!
                  .selected!);
        } else {
          setSelection(context, assessmentController, index);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
            bottom: assessmentController
                        .initialAssessmentResponse
                        .value!
                        .assessments![
                            assessmentController.selectedQuestionIndex.value]!
                        .objective!
                        .multiChoice ==
                    true
                ? 0.h
                : 26.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            assessmentController
                        .initialAssessmentResponse
                        .value!
                        .assessments![
                            assessmentController.selectedQuestionIndex.value]!
                        .objective!
                        .multiChoice ==
                    true
                ? Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: AppColors.whiteColor,
                    ),
                    child: Checkbox(
                        value: assessmentController
                            .initialAssessmentResponse
                            .value!
                            .assessments![assessmentController
                                .selectedQuestionIndex.value]!
                            .objective!
                            .options![index]!
                            .selected!,
                        checkColor: AppColors.whiteColor,
                        activeColor: AppColors.primaryColor,
                        side: const BorderSide(
                            color: AppColors.secondaryLabelColor),
                        onChanged: (bool? value) {
                          setMultiSelection(
                              assessmentController,
                              index,
                              assessmentController
                                  .initialAssessmentResponse
                                  .value!
                                  .assessments![assessmentController
                                      .selectedQuestionIndex.value]!
                                  .objective!
                                  .options![index]!
                                  .selected!);
                        }),
                  )
                : CircleCheckbox(
                    activeColor: AppColors.primaryColor,
                    inactiveColor: AppColors.whiteColor,
                    value: assessmentController
                        .initialAssessmentResponse
                        .value!
                        .assessments![
                            assessmentController.selectedQuestionIndex.value]!
                        .objective!
                        .options![index]!
                        .selected!,
                    onChanged: (value) {
                      setSelection(context, assessmentController, index);
                    },
                  ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: optionType == "IMAGE"
                  ? buildImageOptions(assessmentController
                      .initialAssessmentResponse
                      .value!
                      .assessments![
                          assessmentController.selectedQuestionIndex.value]!
                      .objective!
                      .options![index]!)
                  : buildTextOptions(assessmentController
                          .initialAssessmentResponse
                          .value!
                          .assessments![
                              assessmentController.selectedQuestionIndex.value]!
                          .objective!
                          .options![index]!
                          .option ??
                      ""),
            ),
          ],
        ),
      ),
    );
  }

  buildTextOptions(String optionText) {
    return Text(
      optionText,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AppColors.secondaryLabelColor,
        fontFamily: 'Circular Std',
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  buildImageOptions(
      NutritionInitialAssessmentModelAssessmentsObjectiveOptions option) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        option.imageUrl != null && option.imageUrl!.isNotEmpty
            ? FadeInImage(
                fit: BoxFit.fitHeight,
                width: 80.w,
                fadeInDuration: const Duration(milliseconds: 700),
                fadeOutDuration: const Duration(milliseconds: 300),
                fadeInCurve: Curves.easeIn,
                image: CachedNetworkImageProvider(option.imageUrl!),
                placeholder: const AssetImage("assets/images/placeholder.jpg"),
                placeholderFit: BoxFit.fitHeight,
                placeholderErrorBuilder: (context, url, error) => Image(
                  image: const AssetImage("assets/images/placeholder.jpg"),
                  width: 80.w,
                  fit: BoxFit.fitHeight,
                ),
                imageErrorBuilder: (context, url, error) => Image(
                  image: const AssetImage("assets/images/placeholder.jpg"),
                  width: 80.w,
                  fit: BoxFit.fitHeight,
                ),
              )
            : const Offstage(),
        SizedBox(
          width: 8.w,
        ),
        buildTextOptions(option.option ?? ""),
      ],
    );
  }

  setMultiSelection(PsychologyInitialAssessmentController assessmentController,
      int selectedIndex, bool isSelected) {
    assessmentController
        .initialAssessmentResponse
        .value!
        .assessments![assessmentController.selectedQuestionIndex.value]!
        .objective!
        .options![selectedIndex]!
        .selected = !isSelected;
    assessmentController.update();
  }

  setSelection(
      BuildContext context,
      PsychologyInitialAssessmentController assessmentController,
      int selectedIndex) async {
    for (var element in assessmentController
        .initialAssessmentResponse
        .value!
        .assessments![assessmentController.selectedQuestionIndex.value]!
        .objective!
        .options!) {
      element!.selected = false;
    }
    assessmentController
        .initialAssessmentResponse
        .value!
        .assessments![assessmentController.selectedQuestionIndex.value]!
        .objective!
        .options![selectedIndex]!
        .selected = true;

    if (assessmentController
            .initialAssessmentResponse
            .value!
            .assessments![assessmentController.selectedQuestionIndex.value]!
            .objective!
            .options![selectedIndex]!
            .option!
            .toUpperCase() ==
        "OTHER") {
      assessmentController.showOtherInputBox = true;
    } else {
      assessmentController.showOtherInputBox = false;
    }

    assessmentController.update();
  }
}
