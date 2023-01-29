import 'dart:math';

import 'package:flutter/material.dart';

import '../../Utils/shared_preferences_helper.dart';

class HomeController {
  ValueNotifier<int> minMaxValue = ValueNotifier(999999);
  ValueNotifier<int> casasDecimais = ValueNotifier(1);
  ValueNotifier<int> pesoTela = ValueNotifier(0);
  ValueNotifier<bool> oscilarPeso = ValueNotifier(false);
  ValueNotifier<int> pesoOscilacao = ValueNotifier(0);
  ValueNotifier<int> taraTela = ValueNotifier(0);

  final TextEditingController textControllerPorta;
  final TextEditingController textControllerTara;
  final TextEditingController textControllerPesoOscilacao;
  final TextEditingController textControllerMaxMinValue;
  final TextEditingController textControllerCasasDecimais;
  final TextEditingController textControllerPeso;

  HomeController({
    required this.textControllerPorta,
    required this.textControllerCasasDecimais,
    required this.textControllerMaxMinValue,
    required this.textControllerPeso,
    required this.textControllerPesoOscilacao,
    required this.textControllerTara,
  }) {
    _addListeners();
    _loadPreferencesValue();
  }

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

  void _addListeners() {
    textControllerTara.addListener(
      () {
        setTaraTelaValue(textControllerTara.text);
      },
    );
    textControllerPesoOscilacao.addListener(
      () {
        setPesoOscilacao(textControllerPesoOscilacao.text);
      },
    );
    textControllerMaxMinValue.addListener(
      () {
        setMinMaxValue(textControllerMaxMinValue.text);
      },
    );
    textControllerCasasDecimais.addListener(
      () {
        setCasasDecimais(textControllerCasasDecimais.text);
      },
    );

    casasDecimais.addListener(
      () {
        SharedPreferencesHelper.instance.saveInt(
            EnumKeysSharedPreferences.eCasasDecimais, casasDecimais.value);

        textControllerMaxMinValue.text = getValueDivisor(minMaxValue.value);
        textControllerTara.text = getValueDivisor(taraTela.value);
        textControllerPesoOscilacao.text = getValueDivisor(pesoOscilacao.value);
      },
    );
    minMaxValue.addListener(
      () {
        SharedPreferencesHelper.instance
            .saveInt(EnumKeysSharedPreferences.ePesoMinMax, minMaxValue.value);
      },
    );
  }

  Future<void> _loadPreferencesValue() async {
    var casasDecimaisAux = await SharedPreferencesHelper.instance
        .loadInt(EnumKeysSharedPreferences.eCasasDecimais);
    if (casasDecimaisAux != null) {
      setCasasDecimais(casasDecimaisAux.toString());
      textControllerCasasDecimais.text = casasDecimaisAux.toString();
    }

    var minMaxAux = await SharedPreferencesHelper.instance
        .loadInt(EnumKeysSharedPreferences.ePesoMinMax);
    if (minMaxAux != null) {
      setMinMaxIntValue(minMaxAux);
      textControllerMaxMinValue.text = getValueDivisor(minMaxAux);
    }
  }
}
