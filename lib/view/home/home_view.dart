import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app_structure/injection.dart';
import 'package:flutter_app_structure/utils/asset_helpers/app_icons.dart';
import 'package:flutter_app_structure/utils/asset_helpers/image_assets.dart';
import 'package:flutter_app_structure/utils/colors/app_color.dart';
import 'package:flutter_app_structure/utils/components/circular_svg_image.dart';
import 'package:flutter_app_structure/utils/components/will_pop_scope.dart';
import 'package:flutter_app_structure/utils/fonts/app_fonts.dart';
import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatefulWidget {
  bool isUserAlreadyLoggedIn;

  HomeView({super.key, this.isUserAlreadyLoggedIn = false});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final UserPreference _userPreference = getIt.get<UserPreference>();
  String? _firstName = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> initValues() async {
    String? firstName = await _userPreference.getFirstName();
    setState(() {
      _firstName = firstName ?? '';
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    initValues();
    return MyWillPopScope(
      onWillPop: () async => (true, null),
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header
                SizedBox(
                  width: screenWidth,
                  height: 60.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: CachedNetworkImage(
                          height: 48.h,
                          width: 48.w,
                          imageUrl: "",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                  ),
                          errorWidget: (context, url, error) =>
                              CircularSvgImage(
                                imagePath: ImageAssets.noImagePlaceholder,
                              ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.appText,
                              fontWeight: FontWeight.w400,
                              fontFamily: FontFamily.manrope.name,
                            ),
                          ),
                          Text(
                            'Hello, $_firstName',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColor.appText, // Fixed color
                              fontWeight: FontWeight.w800,
                              fontFamily: FontFamily.manrope.name,
                            ),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        AppIcons.notificationIcon,
                        height: 40.h,
                        width: 40.h,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,

                // Expenses Section
                const Text(
                  "dashboard",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
