import 'dart:math';

import 'package:flutter/material.dart';

class HomeController {
  ValueNotifier<int> minMaxValue = ValueNotifier(999999);
  ValueNotifier<int> casasDecimais = ValueNotifier(1);
  ValueNotifier<int> pesoTela = ValueNotifier(0);
  ValueNotifier<bool> oscilarPeso = ValueNotifier(false);
  ValueNotifier<int> pesoOscilacao = ValueNotifier(0);
  ValueNotifier<int> taraTela = ValueNotifier(0);

  void incrementarPeso(int value) {
    pesoTela.value += value;
  }

  void decrementarPeso(int value) {
    pesoTela.value -= value;
  }

  void setTaraTelaValue(String valueString) {
    var retorno = getValuePesosInt(valueString);
    taraTela.value = retorno;
  }

  void setPesoOscilacao(String valueString) {
    var retorno = getValuePesosInt(valueString);
    pesoOscilacao.value = retorno;
  }

  void setMinMaxValue(String valueString) {
    var minMax = getValuePesosInt(valueString);
    minMaxValue.value = minMax;
    if (minMax <= pesoTela.value) {
      pesoTela.value = minMax;
    }
    if (minMax <= pesoOscilacao.value) {
      setPesoOscilacao(getValueDivisor(minMax));
    }
    minMaxValue.value = minMax;
  }
  void setMinMaxIntValue(int value) {
    var minMax = value;
    minMaxValue.value = minMax;
    if (minMax <= pesoTela.value) {
      pesoTela.value = minMax;
    }
    if (minMax <= pesoOscilacao.value) {
      setPesoOscilacao(getValueDivisor(minMax));
    }
    minMaxValue.value = minMax;
  }

  void setCasasDecimais(String valueString) {
    casasDecimais.value = int.tryParse(valueString) ?? 0;
  }

  String getValueDivisor(int valorOriginal) {
    return (valorOriginal /
            (casasDecimais.value > 0 ? pow(10, casasDecimais.value) : 1))
        .toStringAsFixed(casasDecimais.value);
  }

  int getValuePesosInt(String valueStr) {
    return int.tryParse((double.tryParse(valueStr) ?? 0)
            .toStringAsFixed(casasDecimais.value)
            .replaceAll('.', '')
            .replaceAll(',', '')) ??
        0;
  }
}
