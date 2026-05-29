import 'package:adwaita_flutter/src/libadwaita_core/libadwaita_core.dart';
import 'package:adwaita_flutter/src/models/models.dart';
import 'package:adwaita_flutter/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// A window to present preferences.
///
/// If multiple pages are provided, it automatically creates an
/// [AdwViewSwitcher] in the header bar and uses an [AdwViewStack]
/// for navigation.
class AdwPreferencesWindow extends StatefulWidget {
  const AdwPreferencesWindow({
    super.key,
    required this.pages,
    this.title,
    this.start = const [],
    this.end = const [],
    this.actions,
    this.controls,
  }) : assert(pages.length > 0, 'At least one page is required');

  /// The pages to be displayed in the window. Must be AdwPreferencesPage.
  final List<AdwPreferencesPage> pages;

  /// The title of the window, shown when there's only one page.
  final Widget? title;

  /// The leading widgets for the headerbar.
  final List<Widget> start;

  /// The trailing widgets for the headerbar.
  final List<Widget> end;

  /// Window actions like onDrag, onDoubleTap, etc.
  final AdwActions? actions;

  /// Window controls like closeBtn, maximizeBtn, etc.
  final AdwControls? controls;

  @override
  State<AdwPreferencesWindow> createState() => _AdwPreferencesWindowState();
}

class _AdwPreferencesWindowState extends State<AdwPreferencesWindow> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasMultiplePages = widget.pages.length > 1;

    Widget headerTitle;

    if (hasMultiplePages) {
      headerTitle = AdwViewSwitcher(
        currentIndex: _currentIndex,
        onViewChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        tabs: widget.pages.map((page) {
          return ViewSwitcherData(
            title: page.title ?? page.name ?? '',
            icon: page.icon ?? Icons.settings,
          );
        }).toList(),
      );
    } else {
      headerTitle = widget.title ??
          Text(
            widget.pages.first.title ?? widget.pages.first.name ?? 'Preferences',
            style: const TextStyle(fontWeight: FontWeight.w600),
          );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(47), // AdwHeaderBar style height
        child: AdwHeaderBar(
          title: headerTitle,
          start: widget.start,
          end: widget.end,
          actions: widget.actions,
          controls: widget.controls,
        ),
      ),
      body: AdwViewStack(
        index: _currentIndex,
        children: widget.pages,
      ),
    );
  }
}
