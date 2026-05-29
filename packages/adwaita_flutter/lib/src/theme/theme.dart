import 'package:adwaita_flutter/src/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

/// Generate Adwaita light and dark theme.
class AdwaitaThemeData {
  const AdwaitaThemeData._();

  // Lightens [color] for use as a focus indicator on dark backgrounds,
  // keeping hue/saturation intact — same accent, better legibility.
  static Color _focusColorForDark(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + 0.22).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation * 0.85).clamp(0.0, 1.0))
        .toColor();
  }

  static ColorScheme _getLightColorScheme(Color? accentColor) {
    final primary = accentColor ?? AdwaitaColors.blueAccent;
    return ColorScheme.light(
      primary: primary,
      secondary: primary,
      error: AdwaitaColors.red5,
      onSecondary: Colors.white,
    );
  }

  static ColorScheme _getDarkColorScheme(Color? accentColor) {
    final primary = accentColor ?? AdwaitaColors.blueAccent;
    return ColorScheme.dark(
      primary: primary,
      secondary: primary,
      surface: AdwaitaColors.darkCardBackground,
      error: AdwaitaColors.red5,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
    );
  }

  static ShapeBorder getDialogShape([Color color = Colors.white]) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.2)),
      );

  static TextTheme getTextTheme([Brightness brightness = Brightness.light]) {
    final color = brightness == Brightness.light ? Colors.black : Colors.white;
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 26,
        color: color,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 21,
        color: color,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        color: color,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 17,
        color: color,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontSize: 15,
        color: color,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 13,
        color: color,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        color: color,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.6,
        color: color,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        color: color,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// A default light theme.
  static ThemeData light({String? fontFamily, Color? accentColor}) {
    final colorScheme = _getLightColorScheme(accentColor);
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      splashFactory: NoSplash.splashFactory,
      tabBarTheme: TabBarThemeData(labelColor: colorScheme.onSurface),
      scaffoldBackgroundColor: AdwaitaColors.backgroundColor,
      cardColor: AdwaitaColors.cardBackground,
      dividerTheme: DividerThemeData(
        color: colorScheme.onSurface.withOpacity(0.12),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: getDialogShape(Colors.black),
      ),
      textTheme: getTextTheme(),
      buttonTheme: _buttonThemeData,
      elevatedButtonTheme:
          _getElevatedButtonThemeData(Brightness.light, colorScheme),
      outlinedButtonTheme: _outlinedButtonThemeData,
      textButtonTheme: _textButtonThemeData,
      switchTheme: _switchStyleLight(colorScheme),
      checkboxTheme: _checkStyleLight(colorScheme),
      radioTheme: _radioStyleLight(colorScheme),
      appBarTheme: _appBarLightTheme,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: AdwaitaColors.dark3,
      ),
      sliderTheme: SliderThemeData(
        inactiveTrackColor: colorScheme.onSurface.withOpacity(0.18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AdwaitaColors.button,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
        ),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(color: colorScheme.surface),
    );
  }

  /// A default dark theme.
  static ThemeData dark({String? fontFamily, Color? accentColor}) {
    final colorScheme = _getDarkColorScheme(accentColor);
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      splashFactory: NoSplash.splashFactory,
      tabBarTheme: TabBarThemeData(labelColor: colorScheme.onSurface),
      scaffoldBackgroundColor: AdwaitaColors.darkBackgroundColor,
      cardColor: AdwaitaColors.darkCardBackground,
      dividerTheme: DividerThemeData(
        color: colorScheme.onSurface.withOpacity(0.12),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: getDialogShape(),
      ),
      textTheme: getTextTheme(Brightness.dark),
      buttonTheme: _buttonThemeData,
      textButtonTheme: _darkTextButtonThemeData,
      elevatedButtonTheme:
          _getElevatedButtonThemeData(Brightness.dark, colorScheme),
      outlinedButtonTheme: _darkOutlinedButtonThemeData,
      switchTheme: _switchStyleDark(colorScheme),
      checkboxTheme: _checkStyleDark(colorScheme),
      radioTheme: _radioStyleDark(colorScheme),
      appBarTheme: _appBarDarkTheme,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: AdwaitaColors.warmGrey.shade300,
      ),
      sliderTheme: SliderThemeData(
        inactiveTrackColor: colorScheme.onSurface.withOpacity(0.18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AdwaitaColors.darkButton,
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return TextStyle(color: _focusColorForDark(colorScheme.primary));
          }
          return const TextStyle();
        }),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide:
              BorderSide(color: _focusColorForDark(colorScheme.primary)),
        ),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(color: colorScheme.surface),
    );
  }

  // Special casing some widgets to get the desired Adwaita look
  // Buttons

  static final _commonButtonStyle = ButtonStyle(
    visualDensity: VisualDensity.standard,
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return AdwaitaColors.light4;
      }
      return AdwaitaColors.light2; // Use the component's default.
    }),
    foregroundColor: WidgetStateProperty.all(Colors.black),
  );

  static final _darkCommonButtonStyle = ButtonStyle(
    visualDensity: VisualDensity.standard,
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return AdwaitaColors.dark5;
      }
      return AdwaitaColors.dark2; // Use the component's default.
    }),
    foregroundColor: WidgetStateProperty.all(Colors.white),
  );

  static final _buttonThemeData = ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
  );

  static final _outlinedButtonThemeData = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AdwaitaColors.dark4,
      visualDensity: _commonButtonStyle.visualDensity,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  );

  static final _darkOutlinedButtonThemeData = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      visualDensity: _commonButtonStyle.visualDensity,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    ),
  );

  static final _textButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AdwaitaColors.dark4,
      visualDensity: _commonButtonStyle.visualDensity,
      backgroundColor: AdwaitaColors.button,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: Colors.transparent),
      ),
    ),
  );

  static final _darkTextButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      visualDensity: _darkCommonButtonStyle.visualDensity,
      backgroundColor: AdwaitaColors.darkButton,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: Colors.transparent),
      ),
    ),
  );

  static ElevatedButtonThemeData _getElevatedButtonThemeData(
    Brightness brightness,
    ColorScheme colorScheme,
  ) {
    if (brightness == Brightness.light) {
      return ElevatedButtonThemeData(style: _commonButtonStyle);
    }
    return ElevatedButtonThemeData(style: _darkCommonButtonStyle);
  }

// Switches
  static SwitchThemeData _switchStyleDark(ColorScheme colorScheme) =>
      SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AdwaitaColors.dark2;
          } else {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            } else {
              return AdwaitaColors.warmGrey;
            }
          }
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AdwaitaColors.dark2.withAlpha(120);
          } else {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary.withAlpha(160);
            } else {
              return AdwaitaColors.warmGrey.withAlpha(80);
            }
          }
        }),
      );

  static SwitchThemeData _switchStyleLight(ColorScheme colorScheme) =>
      SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AdwaitaColors.warmGrey.shade200;
          } else {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            } else {
              return Colors.white;
            }
          }
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AdwaitaColors.warmGrey.shade200;
          } else {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary.withAlpha(180);
            } else {
              return AdwaitaColors.warmGrey.shade300;
            }
          }
        }),
      );

// Checks
  static CheckboxThemeData _checkStyleDark(ColorScheme colorScheme) =>
      CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.disabled)) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return AdwaitaColors.warmGrey.shade400;
          }
          return AdwaitaColors.warmGrey.withOpacity(0.4);
        }),
        checkColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.disabled)) {
            return Colors.white;
          }
          return AdwaitaColors.warmGrey;
        }),
      );

  static CheckboxThemeData _checkStyleLight(ColorScheme colorScheme) =>
      CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.disabled)) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return AdwaitaColors.warmGrey;
          }
          return AdwaitaColors.warmGrey.shade300;
        }),
        checkColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.disabled)) {
            return Colors.white;
          }
          return AdwaitaColors.warmGrey;
        }),
      );

// Radios
  static RadioThemeData _radioStyleDark(ColorScheme colorScheme) =>
      RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.disabled)) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return AdwaitaColors.warmGrey.shade400;
          }
          return AdwaitaColors.warmGrey.withOpacity(0.4);
        }),
      );

  static RadioThemeData _radioStyleLight(ColorScheme colorScheme) =>
      RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.disabled)) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return AdwaitaColors.warmGrey;
          }
          return AdwaitaColors.warmGrey.shade300;
        }),
      );

  static final _appBarLightTheme = AppBarTheme(
    elevation: 0,
    titleTextStyle: getTextTheme().headlineSmall,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backgroundColor: AdwaitaColors.headerBarBackground,
    foregroundColor: AdwaitaColors.headerBarForeground,
    iconTheme: const IconThemeData(color: AdwaitaColors.dark3),
    actionsIconTheme: const IconThemeData(color: AdwaitaColors.dark3),
  );

  static final _appBarDarkTheme = AppBarTheme(
    elevation: 0,
    titleTextStyle: getTextTheme(Brightness.dark).headlineSmall,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: AdwaitaColors.darkHeaderBarBackground,
    foregroundColor: AdwaitaColors.darkHeaderBarForeground,
  );
}
