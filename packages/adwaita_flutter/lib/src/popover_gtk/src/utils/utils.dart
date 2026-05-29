import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class Utils {
  factory Utils() {
    _singleton._init();
    return _singleton;
  }

  Utils._();
  static final Utils _singleton = Utils._();

  double screenWidth = 0;
  double screenHeight = 0;
  MediaQueryData? mediaQueryData;

  void _init() {
    final mediaQuery = MediaQueryData.fromView(ui.window);
    if (mediaQueryData != mediaQuery) {
      screenWidth = mediaQuery.size.width;
      screenHeight = mediaQuery.size.height;
      mediaQueryData = mediaQuery;
    }
  }
}
