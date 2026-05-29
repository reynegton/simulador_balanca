import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// A button that looks like a list row.
class AdwButtonRow extends StatelessWidget {
  const AdwButtonRow({
    super.key,
    required this.title,
    this.startIcon,
    this.endIcon,
    this.onPressed,
    this.destructive = false,
  });

  /// The title of the button row.
  final String title;

  /// The icon displayed before the title.
  final Widget? startIcon;

  /// The icon displayed after the title.
  final Widget? endIcon;

  /// The callback when the row is tapped.
  final VoidCallback? onPressed;

  /// Whether this is a destructive action (styles it red).
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = destructive ? colorScheme.error : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AdwConstants.spaceMedium,
            vertical: AdwConstants.spaceMedium,
          ),
          child: Row(
            children: [
              if (startIcon != null) ...[
                IconTheme(
                  data: IconThemeData(color: textColor),
                  child: startIcon!,
                ),
                const SizedBox(width: AdwConstants.spaceMedium),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor,
                      ),
                  textAlign: startIcon == null && endIcon == null
                      ? TextAlign.center
                      : TextAlign.start,
                ),
              ),
              if (endIcon != null) ...[
                const SizedBox(width: AdwConstants.spaceMedium),
                IconTheme(
                  data: IconThemeData(color: textColor),
                  child: endIcon!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
