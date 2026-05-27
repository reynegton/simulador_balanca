import 'package:flutter/material.dart';

class AdwExpanderCard extends StatefulWidget {
  const AdwExpanderCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.children,
    this.initiallyExpanded = false,
    this.expanded,
    this.onExpansionChanged,
    this.cardColor,
  });

  /// The title of the expander card
  final Widget title;

  /// The subtitle/summary of the expander card, visible when collapsed/expanded
  final Widget? subtitle;

  /// Optional leading icon or widget
  final Widget? leading;

  /// The children widgets displayed when expanded
  final List<Widget> children;

  /// Whether the card starts expanded
  final bool initiallyExpanded;

  /// Programmatic control of the expander's expanded state.
  /// If provided, changes to this value will toggle the expansion.
  final bool? expanded;

  /// Callback when the card is expanded or collapsed
  final ValueChanged<bool>? onExpansionChanged;

  /// Optional custom card color
  final Color? cardColor;

  @override
  State<AdwExpanderCard> createState() => _AdwExpanderCardState();
}

class _AdwExpanderCardState extends State<AdwExpanderCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _heightFactor = _controller.drive(
      CurveTween(curve: Curves.easeInOut),
    );

    _isExpanded = (widget.expanded == null
            ? PageStorage.of(context).readState(context) as bool?
            : null) ??
        widget.expanded ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AdwExpanderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != null && widget.expanded != oldWidget.expanded) {
      _handleExpansion(widget.expanded!, notify: false);
    }
  }

  void _handleExpansion(bool expanded, {bool notify = true}) {
    if (_isExpanded != expanded) {
      setState(() {
        _isExpanded = expanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        PageStorage.of(context).writeState(context, _isExpanded);
      });
      if (notify) {
        widget.onExpansionChanged?.call(_isExpanded);
      }
    }
  }

  void _toggleExpansion() {
    _handleExpansion(!_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBgColor = widget.cardColor ?? theme.cardColor;

    return Card(
      color: cardBgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.08),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          InkWell(
            onTap: _toggleExpansion,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextStyle(
                          style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ) ??
                              const TextStyle(fontWeight: FontWeight.bold),
                          child: widget.title,
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          DefaultTextStyle(
                            style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                                ) ??
                                const TextStyle(color: Colors.grey),
                            child: widget.subtitle!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.iconTheme.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Collapsible Content
          AnimatedBuilder(
            animation: _controller.view,
            builder: (context, child) {
              if (_controller.value >= 1.0) {
                return child!;
              }
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: theme.dividerColor.withOpacity(0.08),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.children,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
