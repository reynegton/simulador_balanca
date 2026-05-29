import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:adwaita_flutter/src/widgets/adw/action_row.dart';
import 'package:flutter/material.dart';

/// A list row that expands to reveal more widgets.
class AdwExpanderRow extends StatefulWidget {
  const AdwExpanderRow({
    super.key,
    required this.title,
    this.subtitle,
    this.startIcon,
    this.children = const [],
  });

  /// The title of the row.
  final String title;

  /// The subtitle of the row.
  final String? subtitle;

  /// The starting icon.
  final Widget? startIcon;

  /// The widgets revealed when expanded.
  final List<Widget> children;

  @override
  State<AdwExpanderRow> createState() => _AdwExpanderRowState();
}

class _AdwExpanderRowState extends State<AdwExpanderRow> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdwActionRow(
          title: widget.title,
          subtitle: widget.subtitle,
          start: widget.startIcon,
          onActivated: _toggle,
          end: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0.0,
            duration: AdwConstants.defaultDuration,
            child: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
        AnimatedSize(
          duration: AdwConstants.expandDuration,
          curve: AdwConstants.expandCurve,
          child: _isExpanded
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.03),
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.children,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
