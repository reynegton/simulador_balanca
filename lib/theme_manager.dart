import 'package:flutter/material.dart';
import 'package:adwaita_flutter/adwaita_flutter.dart';

import 'Utils/shared_preferences_helper.dart';

class ThemeNotifier extends ChangeNotifier {
  final lightTheme = AdwaitaThemeData.light();
  final darkTheme = AdwaitaThemeData.dark();

  late ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    _themeData = darkTheme;
    SharedPreferencesHelper.instance
        .loadString(EnumKeysSharedPreferences.eThemeMode)
        .then((value) {
      var themeMode = value;
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    SharedPreferencesHelper.instance
        .saveString(EnumKeysSharedPreferences.eThemeMode, 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    SharedPreferencesHelper.instance
        .saveString(EnumKeysSharedPreferences.eThemeMode, 'light');
    notifyListeners();
  }

  bool get boDarkMode {
    return _themeData.brightness == Brightness.dark;
  }
}
