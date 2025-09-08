import 'package:flutter_app_structure/utils/asset_helpers/json_assets.dart';
import 'package:flutter_app_structure/utils/colors/app_color.dart';
import 'package:flutter_app_structure/utils/fonts/app_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({
    final Key? key,
    this.dismissOnBackPress = true,
    this.isLoaderEnabled = true,
    this.size = 50.0,
    this.title = "Please wait...",
  }) : super(key: key);

  final bool dismissOnBackPress;
  final bool isLoaderEnabled;
  final double size;
  final String title;

  @override
  State<CustomLoader> createState() => _CustomLoaderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<bool>('dismissOnBackPress', dismissOnBackPress),
    );
    properties.add(
      DiagnosticsProperty<bool>('isLoaderEnabled', isLoaderEnabled),
    );
    properties.add(DoubleProperty('size', size));
    properties.add(StringProperty('title', title));
  }
}

class _CustomLoaderState extends State<CustomLoader> {
  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: Container(color: AppColor.transparent)),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: Lottie.asset(JsonAssets.loader, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: TextStyle(
                  color: AppColor.baseDarkBlue,
                  fontFamily: FontFamily.manrope.name,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
