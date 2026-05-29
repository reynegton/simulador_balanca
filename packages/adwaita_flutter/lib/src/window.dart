import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// Helper class to initialize the window for Libadwaita desktop apps.
class AdwWindow {
  /// Initializes the window manager and hides the native title bar.
  /// 
  /// This must be called inside your `main()` method after 
  /// `WidgetsFlutterBinding.ensureInitialized()`.
  /// 
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await AdwWindow.initialize();
  ///   runApp(const MyApp());
  /// }
  /// ```
  static Future<void> initialize({
    Size? minimumSize,
    Size? defaultSize,
    String? title,
  }) async {
    if (kIsWeb || !(Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
      return;
    }
    await windowManager.ensureInitialized();

    final windowOptions = WindowOptions(
      size: defaultSize ?? const Size(800, 600),
      minimumSize: minimumSize ?? const Size(400, 300),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      title: title,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
