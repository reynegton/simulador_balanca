import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// A paginated scrolling carousel widget.
class AdwCarousel extends StatelessWidget {
  const AdwCarousel({
    super.key,
    required this.children,
    this.controller,
    this.onPageChanged,
  });

  /// The pages to display.
  final List<Widget> children;

  /// Controller for the carousel pages.
  final PageController? controller;

  /// Called when the active page changes.
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: onPageChanged,
      physics: const BouncingScrollPhysics(),
      children: children,
    );
  }
}

/// An indicator showing the current position within an [AdwCarousel].
class AdwCarouselIndicator extends StatelessWidget {
  const AdwCarouselIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.isLines = false,
  });

  /// The total number of pages.
  final int itemCount;

  /// The currently active page index.
  final int currentIndex;

  /// Whether to draw indicators as lines (true) or dots (false).
  final bool isLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isSelected = index == currentIndex;
        return AnimatedContainer(
          duration: AdwConstants.defaultDuration,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isLines ? (isSelected ? 24.0 : 12.0) : (isSelected ? 8.0 : 6.0),
          height: isLines ? 4.0 : (isSelected ? 8.0 : 6.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
