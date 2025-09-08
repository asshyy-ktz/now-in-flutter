import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "root");
  static final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "home");
  static final GlobalKey<NavigatorState> _profileNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "profile");
  static final GlobalKey<NavigatorState> _garageNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "garage");
  static final GlobalKey<NavigatorState> _createAppointmentNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "create_appointment");


  // static final GlobalKey<NavigatorState> _settingNavigatorKey =
  //     GlobalKey<NavigatorState>(debugLabel: "setting");

  // static final GlobalKey<NavigatorState> _addNewExpenseNavigatorKey =
  //     GlobalKey<NavigatorState>(debugLabel: "newExpenses");

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  static GlobalKey<NavigatorState> get homeNavigatorKey => _homeNavigatorKey;
  static GlobalKey<NavigatorState> get profileNavigatorKey =>
      _profileNavigatorKey;
  static GlobalKey<NavigatorState> get garageNavigatorKey =>
      _garageNavigatorKey;
  static GlobalKey<NavigatorState> get createAppointmentNavigatorKey =>
      _createAppointmentNavigatorKey;
  
  // static GlobalKey<NavigatorState> get addNewExpenseNavigatorKey =>
  //     _addNewExpenseNavigatorKey;
  // static GlobalKey<NavigatorState> get settingNavigatorKey =>
  //     _settingNavigatorKey;
}
