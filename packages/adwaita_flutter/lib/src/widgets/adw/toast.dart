import 'dart:async';

import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// Represents a toast notification in Adwaita.
class AdwToast {
  AdwToast({
    required this.title,
    this.timeout = const Duration(seconds: 3),
    this.action,
    this.onAction,
    this.actionLabel,
  });

  /// The title of the toast.
  final String title;

  /// The duration before the toast disappears.
  final Duration timeout;

  /// A custom action widget.
  final Widget? action;

  /// Callback when the default action button is pressed.
  final VoidCallback? onAction;

  /// The label for the default action button.
  final String? actionLabel;
}

/// An overlay widget that manages and displays [AdwToast]s.
class AdwToastOverlay extends StatefulWidget {
  const AdwToastOverlay({
    super.key,
    required this.child,
  });

  /// The main content of the app or view.
  final Widget child;

  /// Retrieves the nearest [AdwToastOverlayState] to manage toasts.
  static AdwToastOverlayState of(BuildContext context) {
    final state = context.findAncestorStateOfType<AdwToastOverlayState>();
    assert(state != null, 'No AdwToastOverlay found in context');
    return state!;
  }

  @override
  State<AdwToastOverlay> createState() => AdwToastOverlayState();
}

class AdwToastOverlayState extends State<AdwToastOverlay> {
  final List<_ToastEntry> _toasts = [];

  /// Displays an [AdwToast].
  void addToast(AdwToast toast) {
    final entry = _ToastEntry(toast: toast);
    setState(() {
      _toasts.add(entry);
    });

    Future.delayed(toast.timeout, () {
      if (mounted && _toasts.contains(entry)) {
        setState(() {
          entry.isDismissing = true;
        });
        Future.delayed(AdwConstants.defaultDuration, () {
          if (mounted) {
            setState(() {
              _toasts.remove(entry);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_toasts.isNotEmpty)
          Positioned(
            bottom: AdwConstants.spaceXLarge,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _toasts.map((entry) {
                  return IgnorePointer(
                    ignoring: false, // Intercept clicks for the toast itself
                    child: AnimatedOpacity(
                      opacity: entry.isDismissing ? 0.0 : 1.0,
                      duration: AdwConstants.defaultDuration,
                      curve: AdwConstants.defaultCurve,
                      child: _buildToastWidget(entry.toast),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildToastWidget(AdwToast toast) {
    return Padding(
      padding: const EdgeInsets.only(top: AdwConstants.spaceMedium),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(
            horizontal: AdwConstants.spaceLarge,
            vertical: AdwConstants.spaceMedium,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inverseSurface,
            borderRadius: BorderRadius.circular(24), // Rounded pill shape is common in GTK4
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  toast.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (toast.actionLabel != null || toast.action != null) ...[
                const SizedBox(width: AdwConstants.spaceLarge),
                toast.action ??
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: toast.onAction,
                      child: Text(toast.actionLabel!),
                    ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _ToastEntry {
  _ToastEntry({required this.toast}) : isDismissing = false;
  final AdwToast toast;
  bool isDismissing;
}
