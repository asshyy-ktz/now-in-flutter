// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:now_in_flutter/res/colors/app_color.dart';

class TextFieldWithIcon extends StatelessWidget {
  final IconData prefixIcon;
  final String hintText;

  const TextFieldWithIcon({
    super.key,
    required this.prefixIcon,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Icon(prefixIcon, color: AppColor.appDark),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordTextFieldWithIcon extends StatefulWidget {
  final IconData prefixIcon;
  final String hintText;

  const PasswordTextFieldWithIcon({
    super.key,
    required this.prefixIcon,
    required this.hintText,
  });

  @override
  _PasswordTextFieldWithIconState createState() =>
      _PasswordTextFieldWithIconState();
}

class _PasswordTextFieldWithIconState extends State<PasswordTextFieldWithIcon> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Icon(widget.prefixIcon, color: AppColor.appDark),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ],
      ),
    );
  }
}
