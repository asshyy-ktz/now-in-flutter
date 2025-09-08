import 'package:flutter_app_structure/data/auth/auth_manager.dart';
import 'package:flutter_app_structure/injection.dart';
import 'package:flutter_app_structure/nav.dart';
import 'package:flutter_app_structure/repository/auth_repository/auth_repository.dart';
import 'package:flutter_app_structure/utils/constant.dart';
import 'package:flutter_app_structure/utils/platform_type.dart';
import 'package:flutter_app_structure/utils/routes/routes_name.dart';
import 'package:flutter_app_structure/utils/utils.dart';
import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class AuthViewModel extends GetxController {
  final authRepository = getIt.get<AuthRepository>();
  final _authManager = getIt.get<AuthManager>();

  RxBool isLoading = false.obs;
  RxBool isResendOTPLoading = false.obs;
  RxBool showOTPError = false.obs;
  RxBool showOTPSuccess = false.obs;

  bool isFromSettings = false;
  UserPreference userPreference = getIt.get<UserPreference>();

  String email = "";
  String passwordId = "";
  String otpCode = "";

  Future<void> loginApi(
    Function(bool isSuccess) onLoginSuccess,
    String email,
    String password,
    BuildContext context,
  ) async {
    isLoading.value = true;
    // String? token = await userPreference.getFCMToken();
    String platform = PlatformType.currentAsString;
    Map<String, dynamic> data = {
      'userName': email,
      'password': password,
      // 'deviceToken': token,
      'devicePlatform': platform,
      'environment': dotenv.env['ENVIRONMENT'],
    };

    try {
      var value = await authRepository.loginApi(data);
      isLoading.value = false;
      if (value != "") {
        if (value.employeeId == "") {
          Utils.showCustomFlushbar(
            context: context,
            message: "Employee Id is not assigned to this user!",
            icon: Icons.close_rounded,
            type: FlushbarType.error,
          );
          return;
        }
        await userPreference.saveUserAuthData(
          token: value.token ?? "",
          userId: value.userId ?? "",
          userName: value.userName ?? "",
          firstName: value.firstName ?? "",
          lastName: value.lastName ?? "",
          employeeId: value.employeeId ?? "",
        );

        Utils.showCustomFlushbar(
          context: context,
          message: "Loggedin Successfully",
          icon: Icons.check,
          type: FlushbarType.success,
        );
        _authManager.addValidToken(value.token);
        await Future.delayed(const Duration(seconds: flushbarDuration));
        onLoginSuccess(true);
      } else {
        onLoginSuccess(false);
        Utils.showCustomFlushbar(
          context: context,
          message: "Error while authentication!",
          type: FlushbarType.error,
          icon: Icons.close_rounded,
        );
      }
    } catch (error) {
      isLoading.value = false;
      Utils.showCustomFlushbar(
        context: context,
        message: error.toString(),
        type: FlushbarType.error,
        icon: Icons.close_rounded,
      );
      onLoginSuccess(false);
    }
  }

  Future<void> handleUserNavigation() async {
    Get.delete<AuthViewModel>();
    myRouter?.pushReplacement(RouteName.home);
  }

  void navigateTo(String screen) {
    try {
      myRouter?.pushReplacementNamed(screen);
    } catch (e) {
      print("Error navigating: $e");
    }
  }

  void resetFieldHighlight(bool heightlightSuccess, bool heightlightFailure) {
    showOTPSuccess.value = heightlightSuccess;
    showOTPError.value = heightlightFailure;
  }
}
