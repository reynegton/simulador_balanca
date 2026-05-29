import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// A helper widget for standardizing the spacing between an icon and a label inside buttons.
/// 
/// Matches the official AdwButtonContent from Libadwaita.
class AdwButtonContent extends StatelessWidget {
  const AdwButtonContent({
    super.key,
    this.icon,
    required this.label,
  });

  /// The icon widget, usually an [Icon].
  final Widget? icon;

  /// The text label of the button.
  final String label;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(label, textAlign: TextAlign.center);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon!,
        const SizedBox(width: AdwConstants.spaceSmall),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}
