import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// A persistent banner typically placed below the header bar.
class AdwBanner extends StatelessWidget {
  const AdwBanner({
    super.key,
    required this.title,
    this.buttonLabel,
    this.onButtonClicked,
    this.isRevealed = true,
  });

  /// The main message text.
  final String title;

  /// Optional action button label.
  final String? buttonLabel;

  /// Callback when the action button is pressed.
  final VoidCallback? onButtonClicked;

  /// Whether the banner is currently visible. Triggers a slide animation.
  final bool isRevealed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: AdwConstants.defaultDuration,
      curve: AdwConstants.defaultCurve,
      alignment: Alignment.topCenter,
      child: isRevealed
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AdwConstants.spaceMedium,
                vertical: AdwConstants.spaceSmall + 2,
              ),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (buttonLabel != null) ...[
                    const SizedBox(width: AdwConstants.spaceMedium),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: AdwConstants.spaceSmall),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: onButtonClicked,
                      child: Text(buttonLabel!),
                    ),
                  ]
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
