import 'package:flutter/material.dart';

/// A container that switches between layouts based on available width.
///
/// This perfectly replicates the GNOME Adwaita breakpoint system behavior.
class AdwBreakpointBin extends StatelessWidget {
  const AdwBreakpointBin({
    super.key,
    required this.child,
    this.narrowChild,
    this.breakpointWidth = 500.0,
  });

  /// The default layout (usually the desktop/wide layout - your "Option A").
  final Widget child;

  /// The layout to display when the width is smaller than [breakpointWidth].
  /// This is the optional "Option B".
  final Widget? narrowChild;

  /// The width constraint at which the widget switches to [narrowChild].
  final double breakpointWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (narrowChild != null && constraints.maxWidth <= breakpointWidth) {
          return narrowChild!;
        }
        return child;
      },
    );
  }
}
