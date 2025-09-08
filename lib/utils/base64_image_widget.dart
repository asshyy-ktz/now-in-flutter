import 'dart:typed_data';
import 'package:flutter_app_structure/utils/asset_helpers/image_assets.dart';
import 'package:flutter_app_structure/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Base64ImageWidget extends StatelessWidget {
  final String base64String;

  const Base64ImageWidget({super.key, required this.base64String});

  @override
  Widget build(BuildContext context) {
    if (base64String == "") {
      return SvgPicture.asset(
        ImageAssets.noImagePlaceholder,
        height: 48.h,
        width: 48.w,
        fit: BoxFit.cover,
      );
    }
    Uint8List? imageBytes = base64ToImage(base64String);
    if (imageBytes == null) {
      return Image.asset(
        ImageAssets.noImagePlaceholder,
        height: 48.h,
        width: 48.w,
        fit: BoxFit.cover,
      );
    }

    return Image.memory(
      height: 48.h,
      width: 48.w,
      imageBytes,
      fit: BoxFit.cover,
    );
  }
}
