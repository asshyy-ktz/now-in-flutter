import 'package:flutter_app_structure/main.dart';
import 'package:flutter_app_structure/utils/asset_helpers/app_icons.dart';
import 'package:flutter_app_structure/utils/bold_sub_string.dart';
import 'package:flutter_app_structure/utils/colors/app_color.dart';
import 'package:flutter_app_structure/utils/components/will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomPopup extends StatefulWidget {
  final String title;
  final String description;
  final Widget logo;
  final bool showTitle;
  final bool showDescription;
  final bool showLogo;
  final List<ButtonConfig> buttons;
  final String? textToBold;
  final bool isVerticalButtons;
  final VoidCallback? crossAction;
  final VoidCallback? onDismissed;
  final bool useRootNavigator;

  const CustomPopup({
    super.key,
    required this.title,
    required this.description,
    required this.logo,
    this.showTitle = true,
    this.showDescription = true,
    this.showLogo = true,
    this.isVerticalButtons = false,
    required this.buttons,
    this.textToBold,
    this.onDismissed,
    this.useRootNavigator = true,
    this.crossAction,
  });

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.forward();
  }

  Future<void> _closePopupAndNavigateBack() async {
    await _controller.reverse().then((_) {
      Navigator.of(context, rootNavigator: widget.useRootNavigator).pop();
      widget.onDismissed?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyWillPopScope(
      onWillPop: () async {
        await _closePopupAndNavigateBack();
        widget.crossAction?.call();
        return (false, null);
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500.w,
              maxHeight: screenHeight * 0.9,
            ),
            color: AppColor.transparent,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                var animationValue = _controller.value;
                return FractionalTranslation(
                  translation: Offset(0.0, animationValue - 1.0),
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 14.h,
                          right: 30.w,
                          child: IconButton(
                            icon: SvgPicture.asset(AppIcons.closeIcon),
                            onPressed: () async {
                              await _closePopupAndNavigateBack();
                              widget.crossAction?.call();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: AppColor.appDark, width: 2.0),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (widget.showLogo) widget.logo,
                        if (widget.showTitle)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: AppColor.appText,
                              ),
                            ),
                          ),
                        if (widget.showDescription)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Text(
                              widget.description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: AppColor.appText,
                              ),
                            ).boldSubString(widget.textToBold ?? ""),
                          ),
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: widget.buttons.map((button) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: button.color,
                                foregroundColor: button.textColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 28,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: button.borderColor),
                                ),
                              ),
                              onPressed: () async {
                                await _closePopupAndNavigateBack();
                                button.onPressed();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (button.icon != null)
                                    SvgPicture.asset(
                                      button.icon!,
                                      width: 20,
                                      height: 20,
                                    ),
                                  if (button.icon != null)
                                    const SizedBox(width: 8),
                                  Text(
                                    button.text,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonConfig {
  final String text;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final String? icon;
  final Color iconColor; // New property for icon color
  final VoidCallback onPressed;
  final bool showButtonArrow;
  Color? currentColor;
  Color? currentTextColor;
  Color? currentIconColor;

  final Color pressedBackgroundColor;
  final Color pressedTextColor;
  final Color pressedIconColor;

  ButtonConfig({
    required this.text,
    required this.color,
    required this.textColor,
    required this.borderColor,
    this.icon,
    required this.iconColor,
    required this.onPressed,
    this.showButtonArrow = true,
    Color? pressedBackgroundColor,
    this.pressedTextColor = AppColor.white,
    this.pressedIconColor = AppColor.white,
  }) : pressedBackgroundColor = pressedBackgroundColor ?? textColor;
}
