import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// A page used for empty states, errors, etc.
class AdwStatusPage extends StatelessWidget {
  const AdwStatusPage({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.child,
  });

  /// The title of the status page.
  final String? title;

  /// The description of the status page.
  final String? description;

  /// The icon of the status page. Typically a large Icon widget.
  final Widget? icon;

  /// A custom child widget, typically used for action buttons.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AdwConstants.spaceXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  size: 128,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                child: icon!,
              ),
              const SizedBox(height: AdwConstants.spaceXLarge),
            ],
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: AdwConstants.spaceMedium),
            ],
            if (description != null) ...[
              Text(
                description!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: AdwConstants.spaceXLarge),
            ],
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
