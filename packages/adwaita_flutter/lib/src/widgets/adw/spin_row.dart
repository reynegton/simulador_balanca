import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:adwaita_flutter/src/widgets/adw/action_row.dart';
import 'package:flutter/material.dart';

/// A list row providing native increment/decrement spin buttons.
class AdwSpinRow extends StatelessWidget {
  const AdwSpinRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step = 1,
  });

  /// The title of the row.
  final String title;

  /// The subtitle of the row.
  final String? subtitle;

  /// The current numeric value.
  final double value;

  /// Called when the value changes.
  final ValueChanged<double> onChanged;

  /// The minimum allowable value.
  final double min;

  /// The maximum allowable value.
  final double max;

  /// The increment/decrement step amount.
  final double step;

  @override
  Widget build(BuildContext context) {
    return AdwActionRow(
      title: title,
      subtitle: subtitle,
      end: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AdwConstants.buttonRadius),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSpinButton(
              context,
              icon: Icons.remove,
              onPressed: value > min ? () => onChanged((value - step).clamp(min, max)) : null,
              isLeft: true,
            ),
            Container(
              width: 1,
              height: 24,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AdwConstants.spaceMedium),
              child: Text(
                value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              width: 1,
              height: 24,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            _buildSpinButton(
              context,
              icon: Icons.add,
              onPressed: value < max ? () => onChanged((value + step).clamp(min, max)) : null,
              isLeft: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpinButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isLeft,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.horizontal(
        left: isLeft ? const Radius.circular(AdwConstants.buttonRadius) : Radius.zero,
        right: !isLeft ? const Radius.circular(AdwConstants.buttonRadius) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AdwConstants.spaceSmall),
        child: Icon(
          icon,
          size: 18,
          color: onPressed == null
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
