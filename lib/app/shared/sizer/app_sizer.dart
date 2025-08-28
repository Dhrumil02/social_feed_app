import 'package:feed_app/app/export.dart';
import 'dart:math' as math;

enum DeviceType { mobile, tablet , desktop}

class AppSizer {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late DeviceType deviceType;
  static late Orientation orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    orientation = _mediaQueryData.orientation;

    safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;


    if (screenWidth < 600) {
      deviceType = DeviceType.mobile;
    } else if (screenWidth < 1200) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.desktop;
    }
  }

  static double sp(double fontSize) {
    final scaleFactor = math.min(blockSizeHorizontal, blockSizeVertical);
    return fontSize * scaleFactor;
  }

}