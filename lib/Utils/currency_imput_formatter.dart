import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  int casasDecimais;
  CurrencyInputFormatter([this.casasDecimais = 2]);
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      if (kDebugMode) {
        print(true);
      }
      return newValue;
    }

    double value = double.parse(newValue.text);
    var fator = pow(10, casasDecimais);
    String newText = (value / fator).toStringAsFixed(casasDecimais);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
