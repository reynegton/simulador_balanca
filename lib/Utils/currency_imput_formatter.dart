import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  int casasDecimais;
  CurrencyInputFormatter([this.casasDecimais = 2, ]);
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      if (kDebugMode) {
        print(true);
      }
      return newValue;
    }

    var value = double.tryParse(
            newValue.text.replaceAll('.', '').replaceAll(',', '')) ??
        double.tryParse(
            oldValue.text.replaceAll('.', '').replaceAll(',', '')) ??
        0;
    var fator = pow(10, casasDecimais);
    var newText = (value / fator).toStringAsFixed(casasDecimais);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
