import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// The modern adaptive dialog from Libadwaita 1.5.
/// 
/// Automatically morphs into a bottom sheet on narrow screens (mobile/small windows)
/// and a floating dialog on wide screens (desktop).
class AdwDialog extends StatelessWidget {
  const AdwDialog({
    super.key,
    required this.child,
    this.title,
    this.width = 400,
  });

  /// The main content of the dialog.
  final Widget child;

  /// Optional title displayed at the top.
  final String? title;

  /// The maximum width of the dialog when in floating mode.
  final double width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // If we are inside a navigator barrier, the constraints are the full screen.
      final isNarrow = constraints.maxWidth < 600;

      if (isNarrow) {
        // Bottom Sheet Mode
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AdwConstants.windowRadius),
            ),
            elevation: 16,
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 600),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(AdwConstants.spaceMedium),
                        child: Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Divider(height: 1, color: Theme.of(context).dividerColor),
                    ],
                    Flexible(child: child),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        // Floating Dialog Mode
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AdwConstants.dialogRadius),
              elevation: 24,
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 600),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(AdwConstants.spaceMedium),
                        child: Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Divider(height: 1, color: Theme.of(context).dividerColor),
                    ],
                    Flexible(child: child),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  /// Helper method to show an adaptive [AdwDialog].
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double width = 400,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AdwDialog(
          title: title,
          width: width,
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final isNarrow = MediaQuery.of(context).size.width < 600;

        if (isNarrow) {
          // Slide up for bottom sheet
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AdwConstants.defaultCurve,
            )),
            child: child,
          );
        } else {
          // Scale/Fade for floating dialog
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(
                parent: animation,
                curve: AdwConstants.defaultCurve,
              )),
              child: child,
            ),
          );
        }
      },
    );
  }
}
