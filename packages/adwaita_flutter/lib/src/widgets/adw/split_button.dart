import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// A split button that provides a main action and a dropdown menu.
class AdwSplitButton extends StatelessWidget {
  const AdwSplitButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.menuItems,
  });

  /// The main content of the button (usually a Text or Icon).
  final Widget child;

  /// The action to perform when the main area is clicked.
  final VoidCallback? onPressed;

  /// The items to show in the dropdown menu.
  final List<PopupMenuEntry<dynamic>> menuItems;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AdwConstants.buttonRadius),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AdwConstants.spaceMedium,
                vertical: AdwConstants.spaceSmall + 2,
              ),
              child: child,
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
            ),
            child: PopupMenuButton(
              itemBuilder: (context) => menuItems,
              padding: EdgeInsets.zero,
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdwConstants.cardRadius),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AdwConstants.spaceSmall,
                  vertical: AdwConstants.spaceSmall + 2,
                ),
                child: Icon(Icons.keyboard_arrow_down, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
