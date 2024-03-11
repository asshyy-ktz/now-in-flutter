import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:now_in_flutter/res/asset_helpers/app_icons.dart';
import 'package:now_in_flutter/res/colors/app_color.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final String description;
  final Widget logo;
  final bool showTitle;
  final bool showDescription;
  final bool showLogo;
  final List<ButtonConfig> buttons;

  const CustomPopup({
    super.key,
    required this.title,
    required this.description,
    required this.logo,
    this.showTitle = true,
    this.showDescription = true,
    this.showLogo = true,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(children: [
            
            Positioned(
              bottom: 10,
              right: 50,
              child: IconButton(
                icon: SvgPicture.asset(AppIcons.closeIcon),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
              border: const Border(
                bottom:
                    BorderSide(color: AppColor.appDark, width: 6.0),
                top:
                    BorderSide(color: AppColor.appDark, width: 1.0),
                right:
                    BorderSide(color: AppColor.appDark, width: 1.0),
                left:
                    BorderSide(color: AppColor.appDark, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (showLogo) logo,
                  if (showTitle)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: AppColor.appText),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (showDescription)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColor.appText),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: buttons.map((button) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          button.onPressed();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(button.color),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              button.textColor),
                        ),
                        child: Text("  ${button.text}  "),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonConfig {
  final String text;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;

  ButtonConfig({
    required this.text,
    required this.color,
    required this.textColor,
    required this.borderColor,
    required this.onPressed,
  });
}
