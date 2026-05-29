import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// A list row with an embedded text entry.
class AdwEntryRow extends StatefulWidget {
  const AdwEntryRow({
    super.key,
    required this.title,
    this.controller,
    this.obscureText = false,
    this.endIcon,
    this.onChanged,
  });

  /// The floating title/label for the text input.
  final String title;

  /// Controller for the text input.
  final TextEditingController? controller;

  /// Whether the text should be obscured (e.g., for passwords).
  final bool obscureText;

  /// Optional icon placed at the end.
  final Widget? endIcon;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  @override
  State<AdwEntryRow> createState() => _AdwEntryRowState();
}

class _AdwEntryRowState extends State<AdwEntryRow> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AdwConstants.spaceMedium,
        vertical: AdwConstants.spaceSmall,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _obscureText,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                labelText: widget.title,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          if (widget.obscureText)
            IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          else if (widget.endIcon != null)
            widget.endIcon!,
        ],
      ),
    );
  }
}

/// A list row specifically for passwords, wrapping [AdwEntryRow].
class AdwPasswordEntryRow extends StatelessWidget {
  const AdwPasswordEntryRow({
    super.key,
    required this.title,
    this.controller,
    this.onChanged,
  });

  final String title;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AdwEntryRow(
      title: title,
      controller: controller,
      obscureText: true,
      onChanged: onChanged,
    );
  }
}
