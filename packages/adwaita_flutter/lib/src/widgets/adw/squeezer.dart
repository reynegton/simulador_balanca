import 'package:flutter/material.dart';

/// A child definition for [AdwSqueezer].
/// 
/// It associates a widget with a minimum width threshold.
class AdwSqueezerChild {
  const AdwSqueezerChild({
    required this.child,
    required this.minWidth,
  });

  /// The widget to display if the width threshold is met.
  final Widget child;

  /// The minimum available width required to display this child.
  final double minWidth;
}

/// A container that selectively renders different children based on available space.
/// 
/// It takes a list of [children] ordered by priority (usually from most detailed/largest
/// to least detailed/smallest) and displays the first one whose `minWidth` is satisfied
/// by the current layout constraints.
class AdwSqueezer extends StatelessWidget {
  const AdwSqueezer({
    super.key,
    required this.children,
  }) : assert(children.length > 0, 'At least one AdwSqueezerChild must be provided.');

  /// The list of potential widgets and their width thresholds.
  final List<AdwSqueezerChild> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        for (final item in children) {
          if (constraints.maxWidth >= item.minWidth) {
            return item.child;
          }
        }
        // Fallback to the last (smallest) item if none fit.
        return children.last.child;
      },
    );
  }
}
