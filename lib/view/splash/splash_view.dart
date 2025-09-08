import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_structure/injection.dart';
import 'package:flutter_app_structure/nav.dart';
import 'package:flutter_app_structure/utils/asset_helpers/image_assets.dart';
import 'package:flutter_app_structure/utils/routes/routes_name.dart';
import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final UserPreference _userPreference = getIt.get<UserPreference>();
  late bool _isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    _isUserLoggedIn = false;
    _checkUserLoggedIn();
  }

  Future<void> _checkUserLoggedIn() async {
    bool isLoggedIn = await _userPreference.isLoggedIn();
    setState(() {
      _isUserLoggedIn = isLoggedIn;
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_isUserLoggedIn) {
        myRouter?.pushReplacement(RouteName.home);
      } else {
        myRouter?.goNamed(RouteName.intro);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 158.h),
          Center(child: SvgPicture.asset(ImageAssets.logoBlack, width: 250.w)),
          const Spacer(),
          Container(
            margin: EdgeInsets.only(bottom: 170.h),
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Colors.red.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
