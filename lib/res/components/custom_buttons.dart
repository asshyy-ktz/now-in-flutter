import 'package:flutter/material.dart';
import 'package:now_in_flutter/res/colors/app_color.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {super.key,
      required this.title,
      this.loading = false,
      required this.onPress});
  final String title;
  final bool loading;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: AppColor.white),
          borderRadius: BorderRadius.circular(30),
          color: AppColor.buttonColor.withOpacity(0.5),
        ),
        child: Center(
            child: loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    "$title  ➜",
                    style: const TextStyle(color: AppColor.whiteColor),
                  )),
      ),
    );
  }
}
