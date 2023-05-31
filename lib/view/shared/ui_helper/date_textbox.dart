import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/new_cupertino_date_picker.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CupertinoDateTextBox extends StatefulWidget {
  /// A text box widget which displays a cupertino picker to select a date if clicked
  const CupertinoDateTextBox(
      {Key? key,
      required this.minimumDate,
      required this.initialValue,
      required this.maximumDate,
      required this.onDateChange,
      required this.hintText,
      this.color = CupertinoColors.label,
      this.hintColor = CupertinoColors.inactiveGray,
      this.pickerBackgroundColor = CupertinoColors.systemBackground,
      this.fontSize = 17.0,
      this.textfieldPadding = 15.0,
      this.enabled = true})
      : super(key: key);

  /// The initial value which shall be displayed in the text box
  final DateTime initialValue;

  final DateTime minimumDate;

  final DateTime maximumDate;

  /// The function to be called if the selected date changes
  final Function onDateChange;

  /// The text to be displayed if no initial value is given
  final String hintText;

  /// The color of the text within the text box
  final Color color;

  /// The color of the hint text within the text box
  final Color hintColor;

  /// The background color of the cupertino picker
  final Color pickerBackgroundColor;

  /// The size of the font within the text box
  final double fontSize;

  /// The inner padding within the text box
  final double textfieldPadding;

  /// Specifies if the text box can be modified
  final bool enabled;

  @override
  _CupertinoDateTextBoxState createState() => _CupertinoDateTextBoxState();
}

class _CupertinoDateTextBoxState extends State<CupertinoDateTextBox> {
  final double _kPickerSheetHeight = 250.0;

  DateTime? selectedDate;

  @override
  void initState() {
    print("minimumDate => ${widget.minimumDate}");
    print("initialValue => ${widget.initialValue}");
    print("maximumDate => ${widget.maximumDate}");

    super.initState();
  }

  void callback(DateTime? newDate) {
    widget.onDateChange(newDate);
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 438.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      )),
      child: DefaultTextStyle(
        style: TextStyle(
          color: widget.color,
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
                      if (selectedDate == null) {
                        selectedDate ??= widget.initialValue;
                        callback(selectedDate);
                      }
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: 158.w,
                      child: mainButton("Select"),
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

  void onSelectedDate(DateTime? date) {
    setState(() {
      selectedDate = date;
    });
  }

  Widget _buildTextField(String hintText, Function onSelectedFunction) {
    String fieldText;
    Color textColor;
    if (selectedDate != null) {
      final formatter = DateFormat('dd-MM-yyyy');
      fieldText = formatter.format(selectedDate!);
      textColor = widget.color;
    } else {
      fieldText = hintText;
      textColor = widget.hintColor;
    }

    return Flexible(
      child: GestureDetector(
        onTap: !widget.enabled
            ? null
            : () async {
                await showModalBottomSheet<void>(
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
                      NewCupertinoDatePicker(
                        textColor: AppColors.blackLabelColor,
                        overlayColor: const Color.fromRGBO(252, 175, 175, 0.2),
                        dateOrder: DatePickerDateOrder.dmy,
                        mode: NewCupertinoDatePickerMode.date,
                        backgroundColor: widget.pickerBackgroundColor,
                        initialDateTime: widget.initialValue,
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        minimumYear: widget.minimumDate.year,
                        maximumYear: widget.maximumDate.year,
                        onDateTimeChanged: (DateTime newDateTime) {
                          onSelectedFunction(newDateTime);
                          callback(newDateTime);
                        },
                      ),
                    );
                  },
                );
              },
        child: InputDecorator(
          decoration: InputDecoration(
            //style: AppTheme.inputTextStyle,
            isDense: true,
            hintText: hintText,
            hintStyle: AppTheme.hintTextStyle,
            prefixStyle: AppTheme.hintTextStyle,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
            suffixIcon: const Icon(Icons.calendar_today),
            // enabledBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(6.0),
            //     borderSide: const BorderSide(
            //         color: CupertinoColors.inactiveGray, width: 0.0)),
            // border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(6.0),
            //     borderSide: const BorderSide(
            //         color: CupertinoColors.inactiveGray, width: 0.0)),
          ),
          child: Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: Offset(0, 10),
                color: Color.fromRGBO(125, 130, 138, 0.08),
              )
            ]),
            child: Text(
              fieldText,
              style: TextStyle(
                color: textColor,
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      _buildTextField(widget.hintText, onSelectedDate),
    ]);
  }
}
