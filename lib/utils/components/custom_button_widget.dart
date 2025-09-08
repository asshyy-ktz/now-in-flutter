import 'package:flutter/material.dart';
import 'package:flutter_app_structure/utils/colors/app_color.dart';
import 'package:flutter_app_structure/utils/fonts/app_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color bgStartColor;
  final Color bgEndColor;

  final Color textColor;
  final double borderRadius;
  final double height;
  final double width;
  final IconData? icon;
  final bool loading;
  final bool enabled;
  const CustomButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.bgStartColor = AppColor.primaryButtonColorstart,
    this.bgEndColor = AppColor.primaryButtonColorend,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
    this.height = 50.0,
    this.width = double.infinity,
    this.icon,
    this.loading = false,
    this.enabled = true, // required Color gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: width.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgStartColor, bgEndColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: InkWell(
        onTap: onPressed,
        child:
            loading
                ? const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                : Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // borderradius:31.98px,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(
                          fontFamily: FontFamily.manrope.name,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: textColor,
                        ),
                      ),
                      if (icon != null) ...[
                        Icon(icon, color: textColor, size: 30),
                      ],
                    ],
                  ),
                ),
      ),
    );
  }
}
