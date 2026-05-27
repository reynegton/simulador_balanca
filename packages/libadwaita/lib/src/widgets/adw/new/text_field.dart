import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdwTextField extends StatelessWidget {
  const AdwTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.icon,
    this.prefixIcon,
    this.onSubmitted,
    this.initialValue,
    this.autofocus = false,
    this.decoration,
    this.enabled,
    this.inputFormatters,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  /// Suffix icon (ignored when [decoration] is provided)
  final IconData? icon;

  /// Prefix icon (ignored when [decoration] is provided)
  final IconData? prefixIcon;

  final ValueChanged<String>? onSubmitted;
  final String? initialValue;
  final bool autofocus;

  /// Full InputDecoration override. When provided, [icon] and [prefixIcon] are ignored.
  final InputDecoration? decoration;

  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = decoration ??
        InputDecoration(
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Theme.of(context).iconTheme.color)
              : null,
          suffixIcon: icon != null
              ? Icon(icon, color: Theme.of(context).iconTheme.color)
              : null,
        );

    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      autofocus: autofocus,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      enabled: enabled,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      decoration: effectiveDecoration,
      onChanged: onChanged,
    );
  }
}
