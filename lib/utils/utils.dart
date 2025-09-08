import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:archive/archive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_structure/data/network/connectivity_service.dart';
import 'package:flutter_app_structure/utils/app_localization/localization_keys.dart';
import 'package:flutter_app_structure/utils/bold_sub_string.dart';
import 'package:flutter_app_structure/utils/colors/app_color.dart';
import 'package:flutter_app_structure/utils/constant.dart';
import 'package:flutter_app_structure/utils/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:ui' as ui;

enum FlushbarType { success, error, info }

class Utils {
  static void fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode nextFocus,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    String pattern = r'^.{6,}$';
    return RegExp(pattern).hasMatch(password);
  }

  static void showCustomFlushbar({
    required BuildContext context,
    required String message,
    required FlushbarType type,
    required IconData icon,
    String? textToBold,
  }) {
    Color? backgroundColor;
    String messageToDisplay;

    switch (type) {
      case FlushbarType.success:
        backgroundColor = AppColor.flashBarSuccessBgColor;
        messageToDisplay = message;
        break;
      case FlushbarType.error:
        backgroundColor = AppColor.flashBarErrorBgColor;
        messageToDisplay = Get.find<ConnectivityService>().hasInternet.value
            ? message
            : "No internet connection!";
        break;
      case FlushbarType.info:
        backgroundColor = AppColor.baseDarkBlue;
        messageToDisplay = message;
        break;
    }

    showFlushbar(
      context: context,
      flushbar: Flushbar(
        shouldIconPulse: false,
        backgroundColor: backgroundColor,
        flushbarPosition: FlushbarPosition.TOP,
        messageText: Text(
          messageToDisplay,
          style: TextStyle(
            fontFamily: FontFamily.manrope.name,
            color: AppColor.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ).boldSubString(textToBold ?? ''),
        isDismissible: true,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        forwardAnimationCurve: Curves.bounceIn,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: flushbarDuration),
        icon: Icon(icon, color: AppColor.white),
      )..show(context),
    );
  }

  static String truncateText(String text, {int length = 15}) {
    return text.length > length ? '${text.substring(0, length)}...' : text;
  }

  static String decompressStringFromBase64(String compressedBase64) {
    try {
      if (compressedBase64.isEmpty) return '';
      print('Starting decompression of Base64 string decompression');
      final compressedBytes = base64Decode(compressedBase64);
      print('Base64 string decoded successfully decompression');
      final decompressedBytes = GZipDecoder().decodeBytes(compressedBytes);
      print('GZip decompression completed decompression');
      return utf8.decode(decompressedBytes);
    } on Exception catch (e) {
      print("error ${e.toString()}");
      return '';
    }
  }

  static int secondsTillNow(String dateString) {
    DateTime inputDate = DateTime.parse(dateString);
    DateTime currentDate = DateTime.now().toUtc();

    DateTime inputTime = DateTime.utc(
      0,
      1,
      1,
      inputDate.hour,
      inputDate.minute,
      inputDate.second,
    );
    DateTime currentTime = DateTime.utc(
      0,
      1,
      1,
      currentDate.hour,
      currentDate.minute,
      currentDate.second,
    );

    Duration difference = currentTime.difference(inputTime);

    print("Current time in UTC: $currentTime");
    print("Input time in UTC: $inputTime");
    print("Difference in seconds: ${difference.inSeconds}");

    return difference.inSeconds;
  }

  static bool needsSecondLine({
    required String title,
    required TextStyle style,
    required double availableWidth,
    double padding = 0,
  }) {
    if (title.isEmpty) return false;

    final textSpan = TextSpan(text: title, style: style);
    final tp = TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
    tp.layout();

    return tp.width > availableWidth - padding;
  }

  static bool validateDOB(String dateString) {
    // Check if the date string matches the format DD.MM.YYYY
    final regex = RegExp(r'^\d{2}\.\d{2}\.\d{4}$');
    if (!regex.hasMatch(dateString)) {
      debugPrint("Invalid format");
      return false;
    }

    // Split the input into day, month, and year
    final parts = dateString.split('.');
    final day = int.tryParse(parts[0]) ?? 0;
    final month = int.tryParse(parts[1]) ?? 0;
    final year = int.tryParse(parts[2]) ?? 0;

    // Validate ranges for month and year
    if (month < 1 || month > 12 || year < 1000 || year > 9999) {
      debugPrint("Invalid month or year");
      return false;
    }

    // Get the maximum valid days for the month
    final daysInMonth = <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && _isLeapYear(year)) {
      daysInMonth[1] = 29;
      debugPrint("Adjust February for leap years");
    }

    // Validate the day range
    if (day < 1 || day > daysInMonth[month - 1]) {
      debugPrint("Invalid day for the given month");
      return false;
    }

    // Check if the date is in the future
    final inputDate = DateTime(year, month, day);
    final currentDate = DateTime.now();
    if (inputDate.isAfter(currentDate)) {
      debugPrint("Future date is not allowed");
      return false;
    }

    debugPrint("Date validation checked.");
    return true;
  }

  static bool _isLeapYear(int year) {
    // A year is a leap year if divisible by 4, but not by 100 unless also divisible by 400
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}

class FlushbarRoute<T> extends OverlayRoute<T> {
  final Flushbar flushbar;
  final Builder _builder;
  final Completer<T> _transitionCompleter = Completer<T>();
  final FlushbarStatusCallback? _onStatusChanged;

  Animation<double>? _filterBlurAnimation;
  Animation<Color?>? _filterColorAnimation;
  Alignment? _initialAlignment;
  Alignment? _endAlignment;
  bool _wasDismissedBySwipe = false;
  Timer? _timer;
  T? _result;
  FlushbarStatus? currentStatus;

  FlushbarRoute({required this.flushbar, RouteSettings? settings})
    : _builder = Builder(
        builder: (BuildContext innerContext) {
          return GestureDetector(
            onTap: flushbar.onTap != null
                ? () => flushbar.onTap!(flushbar)
                : null,
            child: flushbar,
          );
        },
      ),
      _onStatusChanged = flushbar.onStatusChanged,
      super(settings: settings) {
    _configureAlignment(flushbar.flushbarPosition);
  }

  void _configureAlignment(FlushbarPosition flushbarPosition) {
    switch (flushbar.flushbarPosition) {
      case FlushbarPosition.TOP:
        {
          _initialAlignment = const Alignment(-1.0, -2.0);
          _endAlignment = flushbar.endOffset != null
              ? const Alignment(-1.0, -1.0) +
                    Alignment(flushbar.endOffset!.dx, flushbar.endOffset!.dy)
              : const Alignment(-1.0, -1.0);
          break;
        }
      case FlushbarPosition.BOTTOM:
        {
          _initialAlignment = const Alignment(-1.0, 2.0);
          _endAlignment = flushbar.endOffset != null
              ? const Alignment(-1.0, 1.0) +
                    Alignment(flushbar.endOffset!.dx, flushbar.endOffset!.dy)
              : const Alignment(-1.0, 1.0);
          break;
        }
    }
  }

  Future<T> get completed => _transitionCompleter.future;
  bool get opaque => false;

  @override
  Future<RoutePopDisposition> willPop() {
    if (!flushbar.isDismissible) {
      return Future.value(RoutePopDisposition.doNotPop);
    }

    return Future.value(RoutePopDisposition.pop);
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    final overlays = <OverlayEntry>[];

    if (flushbar.blockBackgroundInteraction) {
      overlays.add(
        OverlayEntry(
          builder: (BuildContext context) {
            return Listener(
              onPointerDown: flushbar.isDismissible
                  ? (_) => flushbar.dismiss()
                  : null,
              child: _createBackgroundOverlay(),
            );
          },
          maintainState: false,
          opaque: opaque,
        ),
      );
    }

    overlays.add(
      OverlayEntry(
        builder: (BuildContext context) {
          final Widget annotatedChild = Semantics(
            focused: false,
            container: true,
            explicitChildNodes: true,
            child: AlignTransition(
              alignment: _animation!,
              child: flushbar.isDismissible
                  ? _getDismissibleFlushbar(_builder)
                  : _getFlushbar(),
            ),
          );
          return annotatedChild;
        },
        maintainState: false,
        opaque: opaque,
      ),
    );

    return overlays;
  }

  Widget _createBackgroundOverlay() {
    if (_filterBlurAnimation != null && _filterColorAnimation != null) {
      return AnimatedBuilder(
        animation: _filterBlurAnimation!,
        builder: (context, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _filterBlurAnimation!.value,
              sigmaY: _filterBlurAnimation!.value,
            ),
            child: Container(
              constraints: const BoxConstraints.expand(),
              color: _filterColorAnimation!.value,
            ),
          );
        },
      );
    }

    if (_filterBlurAnimation != null) {
      return AnimatedBuilder(
        animation: _filterBlurAnimation!,
        builder: (context, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _filterBlurAnimation!.value,
              sigmaY: _filterBlurAnimation!.value,
            ),
            child: Container(
              constraints: const BoxConstraints.expand(),
              color: Colors.transparent,
            ),
          );
        },
      );
    }

    if (_filterColorAnimation != null) {
      AnimatedBuilder(
        animation: _filterColorAnimation!,
        builder: (context, child) {
          return Container(
            constraints: const BoxConstraints.expand(),
            color: _filterColorAnimation!.value,
          );
        },
      );
    }

    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.transparent,
    );
  }

  /// This string is a workaround until Dismissible supports a returning item
  String dismissibleKeyGen = '';

  Widget _getDismissibleFlushbar(Widget child) {
    return Dismissible(
      direction: _getDismissDirection(),
      resizeDuration: null,
      confirmDismiss: (_) {
        if (currentStatus == FlushbarStatus.IS_APPEARING ||
            currentStatus == FlushbarStatus.IS_HIDING) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      key: Key(dismissibleKeyGen),
      onDismissed: (_) {
        dismissibleKeyGen += '1';
        _cancelTimer();
        _wasDismissedBySwipe = true;

        if (isCurrent) {
          navigator!.pop();
        } else {
          navigator!.removeRoute(this);
        }
      },
      child: _getFlushbar(),
    );
  }

  DismissDirection _getDismissDirection() {
    if (flushbar.dismissDirection == FlushbarDismissDirection.HORIZONTAL) {
      return DismissDirection.horizontal;
    } else {
      if (flushbar.flushbarPosition == FlushbarPosition.TOP) {
        return DismissDirection.up;
      } else {
        return DismissDirection.down;
      }
    }
  }

  Widget _getFlushbar() {
    return Container(margin: flushbar.margin, child: _builder);
  }

  @override
  bool get finishedWhenPopped =>
      _controller!.status == AnimationStatus.dismissed;

  /// The animation that drives the route's transition and the previous route's
  /// forward transition.
  Animation<Alignment>? get animation => _animation;
  Animation<Alignment>? _animation;

  /// The animation controller that the route uses to drive the transitions.
  ///
  /// The animation itself is exposed by the [animation] property.
  @protected
  AnimationController? get controller => _controller;
  AnimationController? _controller;

  /// Called to create the animation controller that will drive the transitions to
  /// this route from the previous one, and back to the previous route from this
  /// one.
  AnimationController createAnimationController() {
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot reuse a $runtimeType after disposing it.',
    );
    assert(flushbar.animationDuration >= Duration.zero);
    return AnimationController(
      duration: flushbar.animationDuration,
      debugLabel: debugLabel,
      vsync: navigator!,
    );
  }

  /// Called to create the animation that exposes the current progress of
  /// the transition controlled by the animation controller created by
  /// [createAnimationController()].
  Animation<Alignment> createAnimation() {
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot reuse a $runtimeType after disposing it.',
    );
    assert(_controller != null);
    return AlignmentTween(begin: _initialAlignment, end: _endAlignment).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: flushbar.forwardAnimationCurve,
        reverseCurve: flushbar.reverseAnimationCurve,
      ),
    );
  }

  Animation<double>? createBlurFilterAnimation() {
    if (flushbar.routeBlur == null) return null;

    return Tween(begin: 0.0, end: flushbar.routeBlur).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(0.0, 0.35, curve: Curves.easeInOutCirc),
      ),
    );
  }

  Animation<Color?>? createColorFilterAnimation() {
    if (flushbar.routeColor == null) return null;

    return ColorTween(
      begin: Colors.transparent,
      end: flushbar.routeColor,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(0.0, 0.35, curve: Curves.easeInOutCirc),
      ),
    );
  }

  //copy of `routes.dart`
  void _handleStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        currentStatus = FlushbarStatus.SHOWING;
        if (_onStatusChanged != null) _onStatusChanged!(currentStatus);
        if (overlayEntries.isNotEmpty) overlayEntries.first.opaque = opaque;

        break;
      case AnimationStatus.forward:
        currentStatus = FlushbarStatus.IS_APPEARING;
        if (_onStatusChanged != null) _onStatusChanged!(currentStatus);
        break;
      case AnimationStatus.reverse:
        currentStatus = FlushbarStatus.IS_HIDING;
        if (_onStatusChanged != null) _onStatusChanged!(currentStatus);
        if (overlayEntries.isNotEmpty) overlayEntries.first.opaque = false;
        break;
      case AnimationStatus.dismissed:
        assert(!overlayEntries.first.opaque);
        // We might still be the current route if a subclass is controlling the
        // the transition and hits the dismissed status. For example, the iOS
        // back gesture drives this animation to the dismissed status before
        // popping the navigator.
        currentStatus = FlushbarStatus.DISMISSED;
        if (_onStatusChanged != null) _onStatusChanged!(currentStatus);

        if (!isCurrent) {
          navigator!.finalizeRoute(this);
          if (overlayEntries.isNotEmpty) {
            overlayEntries.clear();
          }
          assert(overlayEntries.isEmpty);
        }
        break;
    }
    changedInternalState();
  }

  @override
  void install() {
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot install a $runtimeType after disposing it.',
    );
    _controller = createAnimationController();
    assert(
      _controller != null,
      '$runtimeType.createAnimationController() returned null.',
    );
    _filterBlurAnimation = createBlurFilterAnimation();
    _filterColorAnimation = createColorFilterAnimation();
    _animation = createAnimation();
    assert(_animation != null, '$runtimeType.createAnimation() returned null.');
    super.install();
  }

  @override
  TickerFuture didPush() {
    assert(
      _controller != null,
      '$runtimeType.didPush called before calling install() or after calling dispose().',
    );
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot reuse a $runtimeType after disposing it.',
    );
    _animation!.addStatusListener(_handleStatusChanged);
    _configureTimer();
    super.didPush();
    return _controller!.forward();
  }

  @override
  void didReplace(Route<dynamic>? oldRoute) {
    assert(
      _controller != null,
      '$runtimeType.didReplace called before calling install() or after calling dispose().',
    );
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot reuse a $runtimeType after disposing it.',
    );
    if (oldRoute is FlushbarRoute) {
      _controller!.value = oldRoute._controller!.value;
    }
    _animation!.addStatusListener(_handleStatusChanged);
    super.didReplace(oldRoute);
  }

  @override
  bool didPop(T? result) {
    assert(
      _controller != null,
      '$runtimeType.didPop called before calling install() or after calling dispose().',
    );
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot reuse a $runtimeType after disposing it.',
    );

    _result = result;
    _cancelTimer();

    if (_wasDismissedBySwipe) {
      Timer(const Duration(milliseconds: 200), () {
        _controller!.reset();
      });

      _wasDismissedBySwipe = false;
    } else {
      _controller!.reverse();
    }

    return super.didPop(result);
  }

  void _configureTimer() {
    if (flushbar.duration != null) {
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
      _timer = Timer(flushbar.duration!, () {
        if (isCurrent) {
          navigator!.pop();
        } else if (isActive) {
          navigator!.removeRoute(this);
        }
      });
    } else {
      if (_timer != null) {
        _timer!.cancel();
      }
    }
  }

  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  /// Whether this route can perform a transition to the given route.
  ///
  /// Subclasses can override this method to restrict the set of routes they
  /// need to coordinate transitions with.
  bool canTransitionTo(FlushbarRoute<dynamic> nextRoute) => true;

  /// Whether this route can perform a transition from the given route.
  ///
  /// Subclasses can override this method to restrict the set of routes they
  /// need to coordinate transitions with.
  bool canTransitionFrom(FlushbarRoute<dynamic> previousRoute) => true;

  @override
  void dispose() {
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot dispose a $runtimeType twice.',
    );
    _controller?.dispose();
    _transitionCompleter.complete(_result);
    _timer?.cancel();
    super.dispose();
  }

  /// A short description of this route useful for debugging.
  String get debugLabel => '$runtimeType';

  @override
  String toString() => '$runtimeType(animation: $_controller)';
}

FlushbarRoute showFlushbar<T>({
  required BuildContext context,
  required Flushbar flushbar,
}) {
  return FlushbarRoute<T>(
    flushbar: flushbar,
    settings: const RouteSettings(name: FLUSHBAR_ROUTE_NAME),
  );
}
