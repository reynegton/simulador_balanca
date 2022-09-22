import 'package:flutter/material.dart';

class UiController {
  ValueNotifier<int> minMaxValue = ValueNotifier(999999);
  ValueNotifier<int> casasDecimais = ValueNotifier(1);
  ValueNotifier<int> pesoTela = ValueNotifier(0);
  ValueNotifier<bool> oscilarPeso = ValueNotifier(false);
  ValueNotifier<int> pesoOscilacao = ValueNotifier(0);
  ValueNotifier<int> taraTela = ValueNotifier(0);

  void incrementarPeso(int value){
    pesoTela.value +=value;
  }

  void decrementarPeso(int value){
    pesoTela.value -=value;
  }
}