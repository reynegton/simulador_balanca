import 'package:flutter/services.dart';

class CurrencyInputFormatterFreeEdit extends TextInputFormatter {
  CurrencyInputFormatterFreeEdit({this.acceptNegative = false, this.decimalPrecision });
  bool acceptNegative;
  int? decimalPrecision;
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) { 
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var newText = "";      
    var exp = RegExp('^''${acceptNegative?"-?":""}'r'[\d]*\.?[\d]''${decimalPrecision != null ? "{0,$decimalPrecision}": "*"}'r'$');
    var str = newValue.text.replaceAll(',', '.');
    var match = exp.firstMatch(str);

    if (match?.input.isNotEmpty??false) {
      newText = match?.input??"";
    }
    else{
      newText = oldValue.text;
    }

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
