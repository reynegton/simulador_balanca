import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? initialValue;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final List<TextInputFormatter>? textInputFormatter;
  final String? Function(String? value)? funcValidator;
  final void Function()? onEditingComplete;
  final Function(String value)? onFieldSubmitted;
  final Function(String value)? onChanged;
  final String title;
  final int? maxLength;
  final int? minLine;
  final int? maxLine;
  final bool? enabled;
  final bool obscuredText;
  final bool autoFocus;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final bool alignLabelWithHint;
  final bool readOnly;
  final bool autovalidate;
  final bool enableInteractiveSelection;
  final VoidCallback? onTap;

  const TextFormFieldWidget({super.key, 
    required this.controller,
    this.initialValue,
    required this.title,
    this.funcValidator,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
    this.textInputType,
    this.focusNode,
    this.nextFocusNode,
    this.textInputFormatter,
    this.maxLength,
    this.minLine,
    this.maxLine,
    this.autoFocus = false,
    this.enabled = true,
    this.obscuredText = false,
    this.textInputAction,
    this.textCapitalization,
    this.alignLabelWithHint = false,
    this.readOnly = false,
    this.enableInteractiveSelection = true,
    this.autovalidate = false,
    this.onTap,

  }) ;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      initialValue: initialValue,
      focusNode: focusNode,
      maxLength: maxLength,
      minLines: minLine ?? 1,
      maxLines: maxLine ?? 1,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscuredText,
      inputFormatters: textInputFormatter,
      autovalidateMode: autovalidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      enableInteractiveSelection: enableInteractiveSelection,
      keyboardType: textInputType ?? TextInputType.text,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue.withOpacity(0.6),
          ),
        ),
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 13,
          //color: Colors.blueGrey.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: funcValidator,
      textInputAction: textInputAction ?? TextInputAction.done,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      onEditingComplete: onEditingComplete ??
          () {
            FocusScope.of(context).requestFocus(nextFocusNode ?? FocusNode());
          },
      onFieldSubmitted: onFieldSubmitted ??
          (value) {
            FocusScope.of(context).requestFocus(nextFocusNode ?? FocusNode());
          },
      onChanged: onChanged ?? (value) {},
      onTap: onTap ?? () {},
      style: TextStyle(
        color: Theme.of(context).textTheme.bodySmall?.color??Colors.black,
        fontSize: 12.5,
      ),
    );
  }
}
