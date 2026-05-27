import 'package:flutter/material.dart';

class AdwaitaTheme {
  static const Color blue = Color(0xFF3584E4);
  static const Color darkBlue = Color(0xFF1C71D8);

  static ThemeData getLight({Color? primaryColor}) {
    final primary = primaryColor ?? blue;
    const bgColor = Color(0xFFFAFAFA);
    const surfaceColor = Color(0xFFFFFFFF);
    const textColor = Color(0xFF242424);
    const borderColor = Color(0xFFD4D4D4);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        surface: surfaceColor,
        onSurface: textColor,
        background: bgColor,
        onBackground: textColor,
        outline: borderColor,
      ),
      scaffoldBackgroundColor: bgColor,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: textColor),
        bodySmall: TextStyle(fontFamily: 'monospace', color: textColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFEBEBEB),
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFF6F5F4),
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: borderColor, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        floatingLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return const Color(0xFF8B8B8B);
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return primary;
          return const Color(0xFFE1E1E1);
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: const Color(0xFFE1E1E1),
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: 0.1),
        trackHeight: 4.0,
      ),
    );
  }

  static ThemeData getDark({Color? primaryColor}) {
    final primary = primaryColor ?? blue;
    const bgColor = Color(0xFF242424);
    const surfaceColor = Color(0xFF303030);
    const textColor = Color(0xFFFFFFFF);
    const borderColor = Color(0xFF4A4A4A);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: Colors.white,
        surface: surfaceColor,
        onSurface: textColor,
        background: bgColor,
        onBackground: textColor,
        outline: borderColor,
      ),
      scaffoldBackgroundColor: bgColor,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: textColor),
        bodySmall: TextStyle(fontFamily: 'monospace', color: textColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF303030),
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF3A3A3A),
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: borderColor, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        floatingLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return const Color(0xFFD4D4D4);
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return primary;
          return const Color(0xFF4A4A4A);
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: const Color(0xFF4A4A4A),
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: 0.1),
        trackHeight: 4.0,
      ),
    );
  }
}
