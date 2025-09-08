import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_structure/utils/asset_helpers/app_icons.dart';
import 'package:flutter_app_structure/utils/colors/app_color.dart';
import 'package:flutter_app_structure/utils/components/custom_popup.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  var isDialogShowing = false;

  DialogHelper._internal();

  static final DialogHelper _instance = DialogHelper._internal();

  factory DialogHelper() {
    return _instance;
  }

  showInfoDialog({
    required BuildContext context,
    required String title,
    required String description,
    bool useRootNavigator = true,
    String affirmativeBtnTitle = "Yes",
    VoidCallback? onDismissed = null,
    VoidCallback? affirmativeAction,
  }) {
    popUnwantedOverlays(context: context, useRootNavigator: useRootNavigator);

    isDialogShowing = true;

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      useRootNavigator: useRootNavigator,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder:
          (
            BuildContext context,
            Animation animation,
            Animation secondaryAnimation,
          ) {
            return Center(
              child: CustomPopup(
                title: title,
                description: description,
                logo: const Icon(Icons.info),
                showTitle: true,
                showDescription: true,
                showLogo: false,
                onDismissed: () {
                  isDialogShowing = false;
                  if (onDismissed != null) {
                    onDismissed();
                  }
                },
                useRootNavigator: useRootNavigator,
                buttons: [
                  ButtonConfig(
                    text: affirmativeBtnTitle,
                    color: AppColor.appBaseBlueColor,
                    textColor: AppColor.white,
                    borderColor: AppColor.transparent,
                    iconColor: AppColor.appBaseBlueColor,
                    pressedBackgroundColor: AppColor.appDark,
                    onPressed: () {
                      if (affirmativeAction != null) {
                        affirmativeAction();
                      }
                    },
                  ),
                ],
              ),
            );
          },
    );
  }

  Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String description,
    Icon? icon,
    String affirmativeBtnTitle = "Yes",
    VoidCallback? affirmativeAction,
    String negativeBtnTitle = "No",
    VoidCallback? negativeAction,
    VoidCallback? crossAction,
    VoidCallback? onDismissed = null,
    bool showAvatarWithLevel = false,
    bool useRootNavigator = true,
    String? textToBold,
    bool isVerticalButtons = false,
  }) async {
    popUnwantedOverlays(context: context, useRootNavigator: useRootNavigator);

    isDialogShowing = true;
    return await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: true,
          barrierLabel: MaterialLocalizations.of(
            context,
          ).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          useRootNavigator: useRootNavigator,
          pageBuilder:
              (
                BuildContext context,
                Animation animation,
                Animation secondaryAnimation,
              ) {
                return Center(
                  child: CustomPopup(
                    title: title,
                    description: description,
                    logo: icon ?? const Icon(Icons.info),
                    showTitle: true,
                    showDescription: true,
                    showLogo: icon != null,
                    crossAction: crossAction,
                    onDismissed: () {
                      isDialogShowing = false;
                      if (onDismissed != null) {
                        onDismissed();
                      }
                    },
                    useRootNavigator: useRootNavigator,
                    buttons: [
                      _getAffirmativeBtnConfig(
                        title: affirmativeBtnTitle,
                        action: affirmativeAction,
                      ),
                      _getNegativeButtonConfig(
                        title: negativeBtnTitle,
                        action: negativeAction,
                      ),
                    ],
                    textToBold: textToBold,
                    isVerticalButtons: isVerticalButtons,
                  ),
                );
              },
          transitionBuilder:
              (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
        ) ??
        false;
  }

  ButtonConfig _getAffirmativeBtnConfig({
    required String title,
    VoidCallback? action,
  }) {
    return ButtonConfig(
      text: title,
      showButtonArrow: false,
      color: Colors.white,
      textColor: Colors.green,
      borderColor: Colors.green,
      iconColor: Colors.green,
      icon: AppIcons.iconTick,
      onPressed: () {
        Future.delayed(const Duration(milliseconds: 750), () {
          if (action != null) {
            action();
          }
        });
      },
    );
  }

  ButtonConfig _getNegativeButtonConfig({
    required String title,
    VoidCallback? action,
  }) {
    return ButtonConfig(
      text: title,
      showButtonArrow: false,
      color: Colors.white,
      textColor: Colors.red,
      borderColor: Colors.red,
      iconColor: Colors.red,
      icon: AppIcons.iconCross,
      onPressed: () {
        if (action != null) {
          action();
        }
      },
    );
  }

  /// Pops all overlay routes until it finds a route that should be kept.
  void popUnwantedOverlays({
    required BuildContext context,
    required bool useRootNavigator,
  }) {
    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);

    if (navigator.canPop()) {
      navigator.popUntil((route) {
        if (_shouldKeepRoute(route)) {
          // We’ve hit a “keeper” route, so popUntil stops popping here.
          return true;
        }

        // If NOT a keeper => we want to pop it.
        return false;
      });
    }
  }

  bool _shouldKeepRoute(Route route) {
    if (route is PageRoute) return true;

    if (route.settings.name == 'comboStreakOverlay' ||
        route.settings.name == 'levelUpOverlay' ||
        route.settings.name == 'rewardOverlay') {
      return true;
    }

    return false;
  }
}
