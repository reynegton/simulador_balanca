import 'package:flutter/material.dart';

/// Centralized design constants aligned with GNOME HIG (GTK4/Libadwaita).
class AdwConstants {
  const AdwConstants._();

  // Spacings and Margins (typically multiples of 6px in GTK4)
  static const double spaceSmall = 6;
  static const double spaceMedium = 12;
  static const double spaceLarge = 18;
  static const double spaceXLarge = 24;

  // Border Radius
  static const double buttonRadius = 6;
  static const double cardRadius = 12;
  static const double dialogRadius = 12;
  static const double windowRadius = 12;

  // Animations
  static const Duration defaultDuration = Duration(milliseconds: 200);
  static const Duration expandDuration = Duration(milliseconds: 250);
  static const Curve defaultCurve = Curves.easeOutQuart;
  static const Curve expandCurve = Curves.easeInOutCubic;
}
