import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// A split view where the sidebar floats over the content on narrow screens.
/// 
/// Very similar to a standard Drawer, but strictly following GNOME design paradigms.
class AdwOverlaySplitView extends StatelessWidget {
  const AdwOverlaySplitView({
    super.key,
    required this.sidebar,
    required this.content,
    this.collapsedWidth = 600,
    this.sidebarWidth = 300,
    this.showSidebar = false,
    this.onSidebarToggled,
  });

  /// The sidebar widget.
  final Widget sidebar;

  /// The main content widget.
  final Widget content;

  /// The width threshold below which the sidebar becomes an overlay.
  final double collapsedWidth;

  /// The fixed width of the sidebar.
  final double sidebarWidth;

  /// Whether the sidebar is currently open/visible in overlay mode.
  final bool showSidebar;

  /// Callback when the overlay sidebar is dismissed by tapping outside.
  final ValueChanged<bool>? onSidebarToggled;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final collapsed = constraints.maxWidth < collapsedWidth;

        if (!collapsed) {
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
        }

        return Stack(
          children: [
            Positioned.fill(child: content),
            if (showSidebar)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => onSidebarToggled?.call(false),
                  child: Container(
                    color: Colors.black54,
                  ),
                ),
              ),
            AnimatedPositioned(
              duration: AdwConstants.defaultDuration,
              curve: AdwConstants.defaultCurve,
              left: showSidebar ? 0 : -sidebarWidth,
              top: 0,
              bottom: 0,
              width: sidebarWidth,
              child: Material(
                elevation: 16,
                child: sidebar,
              ),
            ),
          ],
        );
      },
    );
  }
}
