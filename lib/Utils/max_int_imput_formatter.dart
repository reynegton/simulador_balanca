import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MaxIntImputFormatter extends TextInputFormatter {
  int maxIntValue;
  MaxIntImputFormatter(this.maxIntValue);
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      if (kDebugMode) {
        print(true);
      }
      return newValue;
    }

    var value = int.tryParse(
            newValue.text.replaceAll('.', '').replaceAll(',', '')) ??
        int.tryParse(
            oldValue.text.replaceAll('.', '').replaceAll(',', '')) ??
        0;

    var newText = (value<=maxIntValue)?value.toString():oldValue.text.replaceAll('.', '').replaceAll(',', '');
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
