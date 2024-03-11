import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:now_in_flutter/res/colors/app_color.dart';

class Utils {

  // Use this snippet for scale transition.....
//
//   Navigator.push(
//   context,
//   scaleTransitionRoute(
//     page: SecondPage(),
//     replace: true,
//     clearStack: true,
//     duration: Duration(milliseconds: 800), // Custom duration
//   ),
// );

  static PageRouteBuilder scaleTransitionRoute({
    required Widget page,
    bool replace = false,
    bool clearStack = false,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return PageRouteBuilder(
      transitionDuration: duration,
      transitionsBuilder: (context, animation, _, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => page,
      maintainState: !clearStack,
      opaque: !clearStack,
      fullscreenDialog: replace,
    );
  }

// Use this snippet for fade transition.....

// Navigator.push(
//   context,
//   fadeTransitionRoute(
//     page: SecondPage(),
//     replace: true,
//     clearStack: true,
//     duration: Duration(milliseconds: 800), // Custom duration
//   ),
// );

  static fadeTransitionRoute({
    required Widget page,
    bool replace = false,
    bool clearStack = false,
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    return PageRouteBuilder(
      transitionDuration: duration,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (context, _, __) => page,
      maintainState: !clearStack,
      opaque: !clearStack,
      fullscreenDialog: replace,
    );
  }

// Use this snippet for slide transition.....

// Navigator.push(
//   context,
//   slideTransitionRoute(
//     page: SecondPage(),
//     replace: true,
//     clearStack: true,
//     duration: Duration(milliseconds: 800), // Custom duration
//   ),
// );

  static PageRouteBuilder slideTransitionRoute({
    required Widget page,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return PageRouteBuilder(
      transitionDuration: duration,
      transitionsBuilder: (context, animation, _, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => page,
    );
  }

  static Widget slideAnimation({
    required BuildContext context,
    required Widget child,
    required Offset beginOffset,
    required Offset endOffset,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).animate(CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: Curves.easeOut,
      )),
      child: child,
    );
  }
  
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColor.blackColor,
      textColor: AppColor.whiteColor,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static toastMessageCenter(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColor.blackColor,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG,
      textColor: AppColor.whiteColor,
    );
  }

  static snackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
    );
  }
}
