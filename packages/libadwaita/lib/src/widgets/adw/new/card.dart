import 'package:flutter/material.dart';

/// A non-expandable card that matches the Adwaita card style.
/// Use this for static content panels; use [AdwExpanderCard] for collapsible ones.
class AdwCard extends StatelessWidget {
  const AdwCard({
    super.key,
    required this.child,
    this.cardColor,
  });

  final Widget child;
  final Color? cardColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: cardColor ?? theme.cardColor,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.08),
        ),
      ),
      child: child,
    );
  }
}
