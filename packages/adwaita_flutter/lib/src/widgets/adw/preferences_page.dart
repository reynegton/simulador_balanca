import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:adwaita_flutter/src/widgets/adw/clamp.dart';
import 'package:flutter/material.dart';

/// A page from [AdwPreferencesWindow].
///
/// It provides a centered, maximum-width layout, typically
/// populated with [AdwPreferencesGroup] elements.
class AdwPreferencesPage extends StatelessWidget {
  const AdwPreferencesPage({
    super.key,
    required this.children,
    this.title,
    this.icon,
    this.name,
  });

  /// The groups to be displayed in the page.
  final List<Widget> children;

  /// The title of the page.
  final String? title;

  /// The icon of the page.
  final IconData? icon;

  /// The name of the page.
  final String? name;

  @override
  Widget build(BuildContext context) {
    return AdwClamp.scrollable(
      margin: const EdgeInsets.symmetric(
        vertical: AdwConstants.spaceXLarge,
        horizontal: AdwConstants.spaceMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          children.isEmpty ? 0 : children.length * 2 - 1,
          (index) {
            if (index.isEven) {
              return children[index ~/ 2];
            }
            return const SizedBox(height: AdwConstants.spaceXLarge);
          },
        ),
      ),
    );
  }
}
