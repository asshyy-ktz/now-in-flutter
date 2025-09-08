import 'package:flutter_app_structure/utils/colors/app_color.dart';
import 'package:flutter_app_structure/utils/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode currentFocusNode;
  final bool isError;
  final Color borderColor;
  final String errorText;
  final String hintText;
  final Function(String) onFieldSubmitted;
  final Function(String) onChanged;
  final Function()? onTap;
  final Function()? onPostfixIconTap;
  final bool isEnabled;
  final bool isMultiline;
  final TextInputType? keyboardType;

  final List<TextInputFormatter>? inputFormatters;

  const CustomInputWidget({
    super.key,
    required this.controller,
    required this.currentFocusNode,
    required this.isError,
    this.borderColor = AppColor.borderColor,
    required this.errorText,
    required this.hintText,
    required this.onFieldSubmitted,
    required this.onChanged,
    this.onTap,
    this.onPostfixIconTap,
    this.isEnabled = true,
    this.inputFormatters,
    this.isMultiline = false,
    this.keyboardType,
  });

  @override
  _CustomInputWidgetState createState() => _CustomInputWidgetState();
}

class _CustomInputWidgetState extends State<CustomInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.isError,
          child: Text(
            widget.isError && widget.controller.text.isEmpty
                ? "Required Field"
                : widget.errorText,
            style: TextStyle(
              fontFamily: FontFamily.manrope.name,
              color: Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        (widget.isError ? 3 : 0).verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: widget.isError ? Colors.red : widget.borderColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            onTap: widget.onTap,
            readOnly: widget.onTap != null,
            keyboardType:
                widget.keyboardType ??
                ((widget.isMultiline)
                    ? TextInputType.multiline
                    : TextInputType.text),
            maxLines: widget.isMultiline ? 5 : null,
            inputFormatters: widget.inputFormatters,
            style: TextStyle(
              fontFamily: FontFamily.manrope.name,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColor.appText,
            ),
            enabled: widget.isEnabled,
            controller: widget.controller,
            focusNode: widget.currentFocusNode,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: AppColor.appHintColor,
                fontFamily: FontFamily.manrope.name,
              ),
              border: InputBorder.none,
              hintText: widget.hintText,
            ),
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
