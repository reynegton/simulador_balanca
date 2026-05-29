import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// Represents a single tab in an [AdwTabView].
class AdwTab {
  const AdwTab({
    required this.title,
    required this.child,
    this.icon,
    this.tooltip,
  });

  /// The label displayed on the tab.
  final String title;

  /// The widget displayed when this tab is active.
  final Widget child;

  /// Optional icon placed before the title.
  final Widget? icon;

  /// Optional tooltip when hovering over the tab.
  final String? tooltip;
}

/// A complete browser-style tabbed view matching the Libadwaita AdwTabView.
/// 
/// Features a heavy, scrollable top bar ([AdwTabBar]) and manages the active tab state.
class AdwTabView extends StatefulWidget {
  const AdwTabView({
    super.key,
    required this.tabs,
    this.onTabClosed,
  });

  /// The list of tabs.
  final List<AdwTab> tabs;

  /// Callback triggered when the 'X' button on a tab is pressed.
  /// If null, the close button is not displayed.
  final ValueChanged<int>? onTabClosed;

  @override
  State<AdwTabView> createState() => AdwTabViewState();
}

class AdwTabViewState extends State<AdwTabView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.tabs.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Ensure index is valid when tabs are removed
    if (_currentIndex >= widget.tabs.length) {
      _currentIndex = widget.tabs.length - 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdwTabBar(
          tabs: widget.tabs,
          currentIndex: _currentIndex,
          onTabSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          onTabClosed: widget.onTabClosed,
        ),
        Expanded(
          child: widget.tabs[_currentIndex].child,
        ),
      ],
    );
  }
}

/// The visual bar that displays the tabs for an [AdwTabView].
class AdwTabBar extends StatelessWidget {
  const AdwTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
    this.onTabClosed,
  });

  final List<AdwTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<int>? onTabClosed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              width: 180, // Fixed width typical of desktop browser tabs
              padding: const EdgeInsets.symmetric(horizontal: AdwConstants.spaceMedium),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).colorScheme.surface : Colors.transparent,
                border: Border(
                  right: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: [
                  if (tab.icon != null) ...[
                    IconTheme.merge(
                      data: const IconThemeData(size: 16),
                      child: tab.icon!,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      tab.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onSurface 
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                  if (onTabClosed != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => onTabClosed!(index),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
