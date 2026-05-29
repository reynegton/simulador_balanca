import 'package:flutter/material.dart';

/// The modern split view that replaces AdwLeaflet.
/// 
/// Displays [sidebar] and [content] side-by-side on wide screens.
/// On narrow screens, it collapses and displays either the sidebar or the content
/// based on the [showContent] property.
class AdwNavigationSplitView extends StatelessWidget {
  const AdwNavigationSplitView({
    super.key,
    required this.sidebar,
    required this.content,
    this.showContent = false,
    this.collapsedWidth = 600,
    this.sidebarWidth = 300,
  });

  /// The sidebar widget, usually a list of navigation items.
  final Widget sidebar;

  /// The main content widget.
  final Widget content;

  /// When collapsed (width < [collapsedWidth]), determines whether to show
  /// the [content] (true) or the [sidebar] (false).
  final bool showContent;

  /// The width threshold below which the view collapses into a single pane.
  final double collapsedWidth;

  /// The fixed width of the sidebar when expanded.
  final double sidebarWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final collapsed = constraints.maxWidth < collapsedWidth;

        if (collapsed) {
          return showContent ? content : sidebar;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: sidebarWidth,
              child: sidebar,
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
            Expanded(
              child: content,
            ),
          ],
        );
      },
    );
  }
}
