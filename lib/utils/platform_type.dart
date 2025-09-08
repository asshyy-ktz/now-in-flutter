import 'dart:io';

enum PlatformType {
  android,
  ios;

  String get asString {
    switch (this) {
      case PlatformType.android:
        return 'Android';
      case PlatformType.ios:
        return 'iOS';
    }
  }

  static PlatformType get current {
    if (Platform.isAndroid) {
      return PlatformType.android;
    } else if (Platform.isIOS) {
      return PlatformType.ios;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get currentAsString => current.asString;
}
