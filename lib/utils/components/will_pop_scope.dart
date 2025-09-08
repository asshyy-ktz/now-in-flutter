import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_structure/nav.dart';
import 'package:flutter_app_structure/utils/app_localization/localization_keys.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

/// Brings the same behavior as WillPopScope, which is now deprecated
/// [onWillPop] is a bit different and still asks as the first value if we should block the pop
/// The second value is used, if [Navigator.pop()] should provide a specific value (can be null)
class MyWillPopScope extends StatefulWidget {
  const MyWillPopScope({
    required this.child,
    required this.onWillPop,
    super.key,
  });

  final Widget child;
  final Future<(bool shouldClose, dynamic res)> Function() onWillPop;

  @override
  State<MyWillPopScope> createState() => _StayXWillPopScopeState();
}

class _StayXWillPopScopeState extends State<MyWillPopScope> {
  DateTime? lastBackPressTime;

  bool handleDoubleTapToExit() {
    final now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > const Duration(seconds: 3)) {
      lastBackPressTime = now;
      Fluttertoast.showToast(
        msg: context.tr(backButtonMessage),
        toastLength: Toast.LENGTH_SHORT,
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    lastBackPressTime = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }

        final (bool shouldClose, dynamic res) = await widget.onWillPop.call();
        if (shouldClose == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              if (myRouter?.canPop() == true) {
                myRouter?.pop(res);
              } else {
                if (!handleDoubleTapToExit()) {
                  return;
                }
                SystemNavigator.pop();
              }
              myRouter?.pop(res);
            } on GoError catch (_) {
              if (myRouter?.canPop() == false) {
                // Force to kill the app
                SystemNavigator.pop();
              }
            }
          });
        }
      },
      child: widget.child,
    );
  }
}
