import 'dart:math';

import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  int _minMaxValue;
  int get minMaxValue => _minMaxValue;
  set minMaxValue(int value) {
    _minMaxValue = value;
    notifyListeners();
  }

  int _casasDecimais;
  int get casasDecimais => _casasDecimais;
  set casasDecimais(int value) {
    _casasDecimais = value;
    notifyListeners();
  }

  int _pesoTela;
  int get pesoTela => _pesoTela;
  set pesoTela(int value) {
    _pesoTela = value;
    notifyListeners();
  }

  bool _oscilarPeso;
  bool get oscilarPeso => _oscilarPeso;
  set oscilarPeso(bool value) {
    _oscilarPeso = value;
    notifyListeners();
  }

  int _pesoOscilacao;
  int get pesoOscilacao => _pesoOscilacao;
  set pesoOscilacao(int value) {
    _pesoOscilacao = value;
    notifyListeners();
  }

  int _taraTela;
  int get taraTela => _taraTela;
  set taraTela(int value) {
    _taraTela = value;
    notifyListeners();
  }

  HomeController(
      [this._minMaxValue = 999999,
      this._casasDecimais = 1,
      this._pesoTela = 0,
      this._oscilarPeso = false,
      this._pesoOscilacao = 0,
      this._taraTela = 0]);

  void incrementarPeso(int value) {
    pesoTela += value;
  }

  void decrementarPeso(int value) {
    pesoTela -= value;
  }

  void setTaraTelaValue(String valueString) {
    var retorno = getValuePesosInt(valueString);
    taraTela = retorno;
  }

  void setPesoOscilacao(String valueString) {
    var retorno = getValuePesosInt(valueString);
    pesoOscilacao = retorno;
  }

  void setMinMaxValue(String valueString) {
    var minMax = getValuePesosInt(valueString);
    minMaxValue = minMax;
    if (minMax <= pesoTela) {
      pesoTela = minMax;
    }
    if (minMax <= pesoOscilacao) {
      setPesoOscilacao(getValueDivisor(minMax));
    }
    minMaxValue = minMax;
  }

  void setMinMaxIntValue(int value) {
    var minMax = value;
    minMaxValue = minMax;
    if (minMax <= pesoTela) {
      pesoTela = minMax;
    }
    if (minMax <= pesoOscilacao) {
      setPesoOscilacao(getValueDivisor(minMax));
    }
    minMaxValue = minMax;
  }

  void setCasasDecimais(String valueString) {
    casasDecimais = int.tryParse(valueString) ?? 0;
  }

  String getValueDivisor(int valorOriginal) {
    return (valorOriginal / (casasDecimais > 0 ? pow(10, casasDecimais) : 1))
        .toStringAsFixed(casasDecimais);
  }

  int getValuePesosInt(String valueStr) {
    return int.tryParse((double.tryParse(valueStr) ?? 0)
            .toStringAsFixed(casasDecimais)
            .replaceAll('.', '')
            .replaceAll(',', '')) ??
        0;
  }
}
