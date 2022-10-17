import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MAxValueImputFormatter extends TextInputFormatter {
  int maxValue;
  int decimalPrecision;
  MAxValueImputFormatter(this.maxValue,this.decimalPrecision);
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
            (double.tryParse(newValue.text)??0).toStringAsFixed(decimalPrecision).replaceAll('.', '').replaceAll(',', '')) ??
        int.tryParse(
            (double.tryParse(oldValue.text)??0).toStringAsFixed(decimalPrecision).replaceAll('.', '').replaceAll(',', '')) ??
        0;

    var newText = (value<=maxValue)?newValue.text:oldValue.text;
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
