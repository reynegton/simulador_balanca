import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// The appearance style of an [AdwAlertDialogResponse].
enum AdwAlertDialogResponseAppearance {
  defaultAppearance,
  suggested,
  destructive,
}

/// Represents a button in an [AdwAlertDialog].
class AdwAlertDialogResponse {
  const AdwAlertDialogResponse({
    required this.id,
    required this.label,
    this.appearance = AdwAlertDialogResponseAppearance.defaultAppearance,
    this.isDefault = false,
  });

  /// The ID returned when this response is tapped.
  final String id;

  /// The label displayed on the button.
  final String label;

  /// Visual styling of the button.
  final AdwAlertDialogResponseAppearance appearance;

  /// Whether this is the default action (bold text).
  final bool isDefault;
}

/// A dialog matching the GTK4 AdwAlertDialog specification.
class AdwAlertDialog extends StatelessWidget {
  const AdwAlertDialog({
    super.key,
    required this.heading,
    this.bodyText,
    required this.responses,
  });

  /// The bold heading of the dialog.
  final String heading;

  /// Optional body text.
  final String? bodyText;

  /// The actions available. If 2, placed side-by-side. Otherwise, stacked.
  final List<AdwAlertDialogResponse> responses;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdwConstants.dialogRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AdwConstants.spaceXLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    heading,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (bodyText != null) ...[
                    const SizedBox(height: AdwConstants.spaceMedium),
                    Text(
                      bodyText!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            if (responses.length == 2)
              Row(
                children: [
                  Expanded(child: _buildButton(context, responses[0], rightBorder: true)),
                  Expanded(child: _buildButton(context, responses[1])),
                ],
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: responses
                    .map((r) => _buildButton(context, r, bottomBorder: r != responses.last))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    AdwAlertDialogResponse response, {
    bool rightBorder = false,
    bool bottomBorder = false,
  }) {
    Color? textColor;
    final fontWeight = response.isDefault ? FontWeight.bold : FontWeight.normal;

    if (response.appearance == AdwAlertDialogResponseAppearance.destructive) {
      textColor = Theme.of(context).colorScheme.error;
    } else if (response.appearance == AdwAlertDialogResponseAppearance.suggested) {
      textColor = Theme.of(context).colorScheme.primary;
    } else {
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          right: rightBorder ? BorderSide(color: Theme.of(context).dividerColor) : BorderSide.none,
          bottom: bottomBorder ? BorderSide(color: Theme.of(context).dividerColor) : BorderSide.none,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(response.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            response.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
