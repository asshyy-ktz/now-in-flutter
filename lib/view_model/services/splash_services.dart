// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:now_in_flutter/utils/routes/routes_name.dart';
import 'package:now_in_flutter/view_model/user_view_model.dart';

import '../../model/user_model.dart';

class SplashServices {
  //Trying to get the data which we stored as Shared Preferences
  //Getter method of UserViewModel
  Future<UserModel> getUserData() => UserViewModel().getUser();

  void checkAuthentication(BuildContext context) async {
    getUserData().then((value) async {
      debugPrint(value.token);
      if (value.token == "null" || value.token.toString() == "") {
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushNamed(context, RoutesName.login);
      } else {
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushNamed(context, RoutesName.home);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
