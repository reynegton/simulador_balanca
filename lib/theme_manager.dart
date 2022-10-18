import 'package:flutter/material.dart';

import 'Utils/shared_preferences_helper.dart';

class ThemeNotifier extends ChangeNotifier {
  final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
  );
  final darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
  );

  late ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    _themeData = darkTheme;
    SharedPreferencesHelper.instance
        .loadString(EnumKeysSharedPreferences.eThemeMode)
        .then((value) {
      print('value read from storage: $value');
      var themeMode = value;
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
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

  bool get boDarkMode{
    return _themeData.brightness == Brightness.dark;
  }
}
