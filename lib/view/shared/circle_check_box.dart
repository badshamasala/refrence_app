import 'package:flutter/material.dart';

class CircleCheckbox extends StatefulWidget {
  bool value;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final bool disabled;
  final Color inactiveColor;

  CircleCheckbox(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.activeColor,
      this.disabled = false,
      this.inactiveColor = const Color(0xFFE9E9EC)})
      : super(key: key);

  @override
  _CircleCheckboxState createState() => _CircleCheckboxState();
}

class _CircleCheckboxState extends State<CircleCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (widget.disabled == false)
          ? () {
              widget.value = !widget.value;
              widget.onChanged(widget.value);
              setState(() {});
            }
          : null,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: widget.inactiveColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFD3DCE6),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: widget.value ? widget.activeColor : widget.inactiveColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
