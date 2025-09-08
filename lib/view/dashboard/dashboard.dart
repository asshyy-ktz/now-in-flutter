import 'dart:async';
import 'package:flutter_app_structure/injection.dart';
import 'package:flutter_app_structure/nav.dart';
import 'package:flutter_app_structure/utils/asset_helpers/app_icons.dart';
import 'package:flutter_app_structure/utils/colors/app_color.dart';
import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatefulWidget {
  final AppStateNotifier appStateNotifier;
  final StatefulNavigationShell navigationShell;

  const Dashboard({
    super.key,
    required this.appStateNotifier,
    required this.navigationShell,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with WidgetsBindingObserver {
  late bool _isUserLoggedIn;
  UserPreference _userPreference = getIt.get<UserPreference>();
  bool _isBottomBarVisible = true;

  @override
  void initState() {
    super.initState();
    _isUserLoggedIn = false;
    _checkUserLoggedIn();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Future<void> _checkUserLoggedIn() async {
    bool isLoggedIn = await _userPreference.isLoggedIn();
    setState(() {
      _isUserLoggedIn = isLoggedIn;
    });
  }

  void toggleBottomBarVisibility(bool isVisible) {
    setState(() {
      _isBottomBarVisible = isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar:
          _isBottomBarVisible
              ? Stack(
                alignment: Alignment.topCenter,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: BottomNavigationBar(
                      items: _navBarsItems(),
                      currentIndex: widget.navigationShell.currentIndex,
                      selectedItemColor: AppColor.baseDarkBlue,
                      unselectedItemColor: AppColor.baseDarkBlue,
                      onTap: (index) {
                        widget.navigationShell.goBranch(
                          index,
                          initialLocation: true,
                        );

                        // Add other actions for different tabs if needed
                      },
                      elevation: 0.1,
                      showSelectedLabels: true,
                      showUnselectedLabels: true,
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.white,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      selectedLabelStyle: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              )
              : null,
    );
  }

  List<BottomNavigationBarItem> _navBarsItems() {
    return [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(AppIcons.homeUnselected, width: 54),
        activeIcon: SvgPicture.asset(AppIcons.home, width: 54),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(AppIcons.expensesUnselected, width: 54),
        activeIcon: SvgPicture.asset(AppIcons.expenses, width: 54),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(AppIcons.profileUnselected, width: 54),
        activeIcon: SvgPicture.asset(AppIcons.profile, width: 54),
        label: "",
      ),
    ];
  }
}
