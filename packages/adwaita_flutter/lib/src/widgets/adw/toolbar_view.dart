import 'package:flutter/material.dart';

/// The modern replacement for scaffolds in Libadwaita (GTK4).
/// 
/// It provides a rigid structure for top bars, a central content area, and bottom bars.
class AdwToolbarView extends StatelessWidget {
  const AdwToolbarView({
    super.key,
    this.topBars = const [],
    required this.content,
    this.bottomBars = const [],
    this.backgroundColor,
  });

  /// Widgets placed at the top of the view, typically [AdwHeaderBar]s or banners.
  final List<Widget> topBars;

  /// The main content of the view.
  final Widget content;

  /// Widgets placed at the bottom of the view.
  final List<Widget> bottomBars;

  /// The background color of the view. Defaults to the theme's background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      // We use a column to rigidly place the bars and content without overlapping
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (topBars.isNotEmpty) ...topBars,
          Expanded(
            child: ClipRect(
              child: content,
            ),
          ),
          if (bottomBars.isNotEmpty) ...bottomBars,
        ],
      ),
    );
  }
}
