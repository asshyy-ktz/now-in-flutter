import 'package:flutter_app_structure/injection.dart';
import 'package:flutter_app_structure/main.dart';
import 'package:flutter_app_structure/nav.dart';
import 'package:flutter_app_structure/repository/profile_repository/profile_repository.dart';
import 'package:flutter_app_structure/utils/colors/app_color.dart';
import 'package:flutter_app_structure/utils/components/custom_button_widget.dart';
import 'package:flutter_app_structure/utils/components/will_pop_scope.dart';
import 'package:flutter_app_structure/utils/fonts/app_fonts.dart';
import 'package:flutter_app_structure/utils/routes/routes_name.dart';
import 'package:flutter_app_structure/utils/utils.dart';
import 'package:flutter_app_structure/view_model/profile/profile_view_model.dart';
import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileView>
    with WidgetsBindingObserver {
  final UserPreference _userPreference = getIt.get<UserPreference>();

  final ProfileViewModel profileViewModel = Get.put(
    ProfileViewModel(profileRepository: getIt.get<ProfileRepository>()),
  );

  double progressRowHeight = 27.0;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent ?? false) {}
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _callAPIToGetExpenses();
    // });
  }

  void _handleLogout() {
    _userPreference.removeUserData();

    Future.delayed(const Duration(milliseconds: 500), () {
      myRouter?.goNamed(RouteName.splash);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        final ctx = myRouter
            ?.routerDelegate
            .navigatorKey
            .currentState!
            .overlay!
            .context;
        if (ctx == null) return;
        Utils.showCustomFlushbar(
          context: ctx,
          message: "User logged out successfully!",
          icon: Icons.check,
          type: FlushbarType.error,
        );
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        return MyWillPopScope(
          onWillPop: () async => (true, null),
          child: Scaffold(
            body: Container(
              height: screenHeight,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      maxLines: 1,
                      "Under development..",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: FontFamily.manrope.name,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.h),
                    child: CustomButtonWidget(
                      loading: false,
                      buttonText: "Logout",
                      onPressed: () {
                        viewModel.showConfirmationPopup(context, () {
                          _handleLogout();
                        });
                      },
                      bgStartColor: AppColor.logoutButton,
                      bgEndColor: AppColor.logoutButton,
                      textColor: Colors.white,
                      borderRadius: 48.0,
                      height: 50.0,
                      width: screenWidth,
                      icon: Icons.arrow_right_alt_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
