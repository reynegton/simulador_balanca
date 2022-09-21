import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Utils/currency_imput_formatter.dart';
import '../../Utils/max_int_imput_formatter.dart';
import '../../widgets/show_dialog_custom.dart';
import '../../widgets/textformfiled.dart';
import '../Controllers/home_controller.dart';
import '../States/home_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _textControllerPorta;
  late TextEditingController _textControllerTara;
  late TextEditingController _textControllerOscilarPeso;
  late TextEditingController _textControllerMaxMinValue;
  late TextEditingController _textControllerCasasDecimais;

  UiController uiController = UiController();

  late HomeStateController homeState;

  @override
  void initState() {
    super.initState();
    _textControllerPorta = TextEditingController(text: '32211');
    _textControllerTara = TextEditingController(text: '0.0');
    _textControllerOscilarPeso = TextEditingController(text: '0.0');
    _textControllerMaxMinValue = TextEditingController(text: '99999.9');
    _textControllerCasasDecimais = TextEditingController(text: '1');
    initController();
  }

  @override
  void dispose() {
    _textControllerPorta.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador Balança'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildCardconfigs(),
            _buildCardDadosPesagem(),
            _buildCardProtocolos(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottonButons(),
    );
  }

  Widget _buildBottonButons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder<HomeState>(
        valueListenable: homeState,
        builder: (context, state, child) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: (state is HomeStateSucess)
                      ? null
                      : () {
                          homeState.createServer(
                              int.tryParse(_textControllerPorta.text) ?? 0);
                        },
                  child: const Text('Conectar'),
                ),
              ),
              _getEspacoRow(),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: (state is HomeStateSucess)
                      ? homeState.disconectSocket
                      : null,
                  child: const Text('Desconectar'),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildCardProtocolos() {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder<HomeState>(
            valueListenable: homeState,
            builder: (context, state, child) {
              if (state is HomeStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is HomeStateSucess) {
                return _returnListProtocolos(state.protocolos);
              }
              if (state is HomeStateDisconect) {
                if ((state.messageError ?? "") != "") {
                  showDialogCustom(context: context, msg: state.messageError!);
                }
                return _returnListProtocolos(state.protocolos ?? []);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardDadosPesagem() {
    return Card(
        child: ListTile(
      title: const Text('Dados Balança'),
      subtitle: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: uiController.casasDecimais,
              builder: (context, valueCasasDecimais, child) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormFieldWidget(
                        controller: _textControllerTara,
                        title: 'Tara',
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          MaxIntImputFormatter(999999),
                          CurrencyInputFormatter(valueCasasDecimais)
                        ],
                      ),
                    ),
                    _getEspacoRow(),
                    Expanded(
                      child: Row(
                        children: [
                          const Text("Oscilar Peso"),
                          ValueListenableBuilder<bool>(
                            valueListenable: uiController.oscilarPeso,
                            builder: (context, valueOscilar, child) {
                              return Switch(
                                value: valueOscilar,
                                activeColor: Colors.blue,
                                onChanged: (bool value) {
                                  uiController.oscilarPeso.value = value;
                                },
                              );
                            },
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: uiController.oscilarPeso,
                              builder: (context, valueOscilarPeso, widget) {
                                return TextFormFieldWidget(
                                  enabled: valueOscilarPeso,
                                  controller: _textControllerOscilarPeso,
                                  title: 'Valor Oscilação',
                                  textInputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    MaxIntImputFormatter(999999),
                                    CurrencyInputFormatter(valueCasasDecimais)
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            _buildSliderPeso(),
          ],
        ),
      ),
    ));
  }

  Widget _buildCardconfigs() {
    return Card(
      child: ListTile(
        title: const Text('Configurações'),
        subtitle: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ValueListenableBuilder<HomeState>(
            valueListenable: homeState,
            builder: (context, state, child) {
              return Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      enabled: (state is! HomeStateSucess),
                      controller: _textControllerPorta,
                      title: 'Porta',
                    ),
                  ),
                  _getEspacoRow(),
                  ValueListenableBuilder<int>(
                      valueListenable: uiController.casasDecimais,
                      builder: (context, value, child) {
                        return Expanded(
                          child: TextFormFieldWidget(
                            controller: _textControllerMaxMinValue,
                            title: 'Min/Max Valor',
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              MaxIntImputFormatter(999999),
                              CurrencyInputFormatter(value),
                            ],
                          ),
                        );
                      }),
                  _getEspacoRow(),
                  Expanded(
                    child: TextFormFieldWidget(
                      controller: _textControllerCasasDecimais,
                      title: 'Casas Decimais',
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        MaxIntImputFormatter(5),
                        CurrencyInputFormatter(0),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String getValueDivisor(int valorOriginal) {
    return (valorOriginal /
            (uiController.casasDecimais.value > 0
                ? pow(10, uiController.casasDecimais.value)
                : 1))
        .toStringAsFixed(uiController.casasDecimais.value);
  }

  Widget _returnListProtocolos(List<String> listaProtocolos) {
    final ScrollController firstController = ScrollController();
    return Scrollbar(
      thumbVisibility: true,
      controller: firstController,
      radius: const Radius.circular(5),
      child: ListView.builder(
        controller: firstController,
        itemCount: listaProtocolos.length,
        itemBuilder: (context, index) {
          return Card(
            child: Text(
              listaProtocolos[index],
            ),
          );
        },
      ),
    );
  }

  Widget _getEspacoRow() {
    return const SizedBox(width: 10);
  }

  Widget _buildSliderPeso() {
    return ValueListenableBuilder(
      valueListenable: homeState,
      builder: (context, state, child) {
        return Column(
          children: [
            ListTile(
              enabled: state is HomeStateSucess,
              title: ValueListenableBuilder(
                  valueListenable: uiController.casasDecimais,
                  builder: (context, value, child) {
                    var pesoFormatado =
                        getValueDivisor(uiController.pesoTela.value);
                    return Text("Peso: $pesoFormatado");
                  }),
              subtitle: ValueListenableBuilder(
                valueListenable: uiController.casasDecimais,
                builder: (context, casasDecimaisValue, child) {
                  return ValueListenableBuilder<int>(
                    valueListenable: uiController.minMaxValue,
                    builder: (context, minMaxValue, child) {
                      var pesoFormatado =
                          getValueDivisor(uiController.pesoTela.value);
                      return Row(
                        children: [
                          Text(getValueDivisor(-minMaxValue)),
                          Expanded(
                            child: Slider(
                              min: -minMaxValue.toDouble(),
                              max: minMaxValue.toDouble(),
                              divisions: minMaxValue > 0 ? 2 * minMaxValue : 1,
                              value: uiController.pesoTela.value.toDouble(),
                              label: pesoFormatado,
                              onChanged: state is HomeStateSucess
                                  ? (value) {
                                      uiController.pesoTela.value =
                                          value.round();
                                    }
                                  : null,
                            ),
                          ),
                          Text(getValueDivisor(minMaxValue)),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: state is HomeStateSucess
                    ? () {
                        uiController.pesoTela.value = 0;
                      }
                    : null,
                child: const Text('Zerar Peso'),
              ),
            )
          ],
        );
      },
    );
  }

  void initController() {
    homeState = HomeStateController(uiController);
    //#region ListenerTextControllers
    _textControllerTara.addListener(
      () {
        uiController.taraTela.value = int.tryParse(_textControllerTara.text
                .replaceAll('.', '')
                .replaceAll(',', '')) ??
            0;
      },
    );
    _textControllerOscilarPeso.addListener(
      () {
        uiController.pesoOscilacao.value = int.tryParse(
                _textControllerOscilarPeso.text
                    .replaceAll('.', '')
                    .replaceAll(',', '')) ??
            0;
      },
    );
    _textControllerMaxMinValue.addListener(
      () {
        var minMax = int.tryParse(_textControllerMaxMinValue.text
                .replaceAll('.', '')
                .replaceAll(',', '')) ??
            0;
        if (minMax <= uiController.pesoTela.value) {
          uiController.pesoTela.value = minMax;
        }
        if (minMax <= uiController.pesoOscilacao.value) {
          _textControllerOscilarPeso.text = getValueDivisor(minMax);
        }
        uiController.minMaxValue.value = minMax;
      },
    );
    _textControllerCasasDecimais.addListener(
      () {
        uiController.casasDecimais.value =
            int.tryParse(_textControllerCasasDecimais.text) ?? 0;
      },
    );

    //#endregion
    // #region ListenerUiController
    uiController.casasDecimais.addListener(
      () {
        _textControllerMaxMinValue.text =
            getValueDivisor(uiController.minMaxValue.value);
        _textControllerTara.text = getValueDivisor(uiController.taraTela.value);
      },
    );
    // #endregion
  }
}
