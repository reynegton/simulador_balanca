import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../Utils/currency_imput_formatter.dart';
import '../../Utils/currency_input_formatter_free_edit.dart';
import '../../Utils/max_value_imput_formatter.dart';
import '../../widgets/my_drawer_menu.dart';
import '../../widgets/show_dialog_custom.dart';
import '../../widgets/textformfiled.dart';
import '../Controllers/balanca_controller.dart';
import '../Controllers/home_controller.dart';
import '../States/balanca_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _textControllerPorta;
  late TextEditingController _textControllerTara;
  late TextEditingController _textControllerPesoOscilacao;
  late TextEditingController _textControllerMaxMinValue;
  late TextEditingController _textControllerCasasDecimais;
  late TextEditingController _textControllerPeso;
  late TextEditingController _textControllerEndereco;
  late FocusNode _focusNodeTara;
  late FocusNode _focusNodeOscilarPeso;
  late FocusNode _focusNodeMinMaxValue;

  late HomeController uiController;

  late BalancaController balancaState;

  void _addFocusNodeListener(
      FocusNode focus, TextEditingController textEditing) {
    focus.addListener(
      () {
        if (focus.hasFocus) {
          textEditing.selection = TextSelection(
              baseOffset: 0, extentOffset: textEditing.text.length);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _textControllerPorta = TextEditingController(text: '32211');
    _textControllerTara = TextEditingController(text: '0.0');
    _textControllerPesoOscilacao = TextEditingController(text: '0.0');
    _textControllerMaxMinValue = TextEditingController(text: '99999.9');
    _textControllerCasasDecimais = TextEditingController(text: '1');
    _textControllerPeso = TextEditingController(text: '0.0');
    _textControllerEndereco = TextEditingController(text: '');
    _focusNodeTara = FocusNode();
    _focusNodeOscilarPeso = FocusNode();
    _focusNodeMinMaxValue = FocusNode();

    uiController = HomeController(
      textControllerCasasDecimais: _textControllerCasasDecimais,
      textControllerMaxMinValue: _textControllerMaxMinValue,
      textControllerPeso: _textControllerPeso,
      textControllerPesoOscilacao: _textControllerPesoOscilacao,
      textControllerPorta: _textControllerPorta,
      textControllerTara: _textControllerTara,
      textControllerEndereco: _textControllerEndereco,
    );

    balancaState = BalancaController(uiController);
    _addFocusNodeListener(_focusNodeTara, _textControllerTara);
    _addFocusNodeListener(_focusNodeOscilarPeso, _textControllerPesoOscilacao);
    _addFocusNodeListener(_focusNodeMinMaxValue, _textControllerMaxMinValue);
  }

  @override
  void dispose() {
    _textControllerPorta.dispose();
    _textControllerEndereco.dispose();
    _textControllerTara.dispose();
    _textControllerPesoOscilacao.dispose();
    _textControllerMaxMinValue.dispose();
    _textControllerCasasDecimais.dispose();
    _textControllerPeso.dispose();
    _focusNodeTara.dispose();
    _focusNodeOscilarPeso.dispose();
    _focusNodeMinMaxValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerMenu(),
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
      child: ValueListenableBuilder<BalancaState>(
        valueListenable: balancaState,
        builder: (context, state, child) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: (state is BalancaStateSucess)
                      ? null
                      : () {
                          balancaState.createServer(
                              int.tryParse(_textControllerPorta.text) ?? 0);
                        },
                  child: const Text('Conectar'),
                ),
              ),
              _getEspacoRow(),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: (state is BalancaStateSucess)
                      ? balancaState.disconectSocket
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
          child: ValueListenableBuilder<BalancaState>(
            valueListenable: balancaState,
            builder: (context, state, child) {
              if (state is BalancaStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is BalancaStateSucess) {
                return _returnListProtocolos(state.protocolos);
              }
              if (state is BalancaStateDisconnect) {
                if ((state.messageError ?? "") != "") {
                  _showMessage(context, state.messageError!);
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

  void _showMessage(BuildContext context, String msg) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await showDialogCustom(context: context, msg: msg, nomeButton: 'OK');
      },
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
              Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: uiController.casasDecimais,
                      builder: (context, valueCasasDecimais, child) {
                        return TextFormFieldWidget(
                          controller: _textControllerTara,
                          focusNode: _focusNodeTara,
                          title: 'Tara',
                          textInputFormatter: [
                            CurrencyInputFormatterFreeEdit(
                                acceptNegative: false,
                                decimalPrecision: valueCasasDecimais),
                            MaxValueImputFormatter(999999, valueCasasDecimais),
                          ],
                        );
                      },
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
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
                              onChanged: (value) {
                                uiController.oscilarPeso.value = value;
                              },
                            );
                          },
                        ),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: uiController.minMaxValue,
                            builder: (context, valueMinMax, child) {
                              return ValueListenableBuilder(
                                valueListenable: uiController.oscilarPeso,
                                builder: (context, valueOscilarPeso, widget) {
                                  return ValueListenableBuilder<int>(
                                    valueListenable: uiController.casasDecimais,
                                    builder:
                                        (context, valueCasasDecimais, child) {
                                      return TextFormFieldWidget(
                                        enabled: valueOscilarPeso,
                                        focusNode: _focusNodeOscilarPeso,
                                        controller:
                                            _textControllerPesoOscilacao,
                                        title: 'Valor Oscilação',
                                        textInputFormatter: [
                                          CurrencyInputFormatterFreeEdit(
                                              acceptNegative: false,
                                              decimalPrecision:
                                                  valueCasasDecimais),
                                          MaxValueImputFormatter(
                                              valueMinMax, valueCasasDecimais),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _getEspacoColumn(),
              _buildSliderPeso(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardconfigs() {
    return Card(
      child: ListTile(
        title: const Text('Configurações'),
        subtitle: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ValueListenableBuilder<BalancaState>(
            valueListenable: balancaState,
            builder: (context, state, child) {
              return Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      enabled: false,
                      controller: _textControllerEndereco,
                      title: 'Ip',
                    ),
                  ),
                  _getEspacoRow(),
                  Expanded(
                    child: TextFormFieldWidget(
                      enabled: (state is! BalancaStateSucess),
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
                          focusNode: _focusNodeMinMaxValue,
                          title: 'Min/Max Valor Peso',
                          textInputFormatter: [
                            CurrencyInputFormatterFreeEdit(
                                acceptNegative: false, decimalPrecision: value),
                            MaxValueImputFormatter(999999, 2),
                          ],
                        ),
                      );
                    },
                  ),
                  _getEspacoRow(),
                  Expanded(
                    child: TextFormFieldWidget(
                      controller: _textControllerCasasDecimais,
                      title: 'Casas Decimais',
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        MaxValueImputFormatter(5, 0),
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

  Widget _returnListProtocolos(List<String> listaProtocolos) {
    final firstController = ScrollController();
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

  Widget _getEspacoColumn() {
    return const SizedBox(height: 10);
  }

  Widget _buildSliderPeso() {
    return ValueListenableBuilder(
      valueListenable: balancaState,
      builder: (context, state, child) {
        return Column(
          children: [
            ValueListenableBuilder(
              valueListenable: uiController.casasDecimais,
              builder: (context, casasDecimaisValue, child) {
                return ValueListenableBuilder<int>(
                  valueListenable: uiController.minMaxValue,
                  builder: (context, minMaxValue, child) {
                    var pesoFormatado = uiController
                        .getValueDivisor(uiController.pesoTela.value);
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  uiController.getValueDivisor(-minMaxValue),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Peso: $pesoFormatado"),
                                IconButton(
                                  onPressed: state is BalancaStateSucess
                                      ? () async {
                                          await _dialogBuilder(context);
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.edit,
                                    color: state is BalancaStateSucess
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  uiController.getValueDivisor(minMaxValue),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                min: -minMaxValue.toDouble(),
                                max: minMaxValue.toDouble(),
                                divisions:
                                    minMaxValue > 0 ? 2 * minMaxValue : 1,
                                value: uiController.pesoTela.value.toDouble(),
                                label: pesoFormatado,
                                onChanged: state is BalancaStateSucess
                                    ? (value) {
                                        uiController.pesoTela.value =
                                            value.round();
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: state is BalancaStateSucess
                      ? () {
                          if (uiController.pesoTela.value >
                              -uiController.minMaxValue.value) {
                            uiController.decrementarPeso(1);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.exposure_minus_1),
                ),
                ElevatedButton(
                  onPressed: state is BalancaStateSucess
                      ? () {
                          uiController.pesoTela.value = 0;
                        }
                      : null,
                  child: const Text('Zerar Peso'),
                ),
                ElevatedButton(
                  onPressed: state is BalancaStateSucess
                      ? () {
                          if (uiController.pesoTela.value <
                              uiController.minMaxValue.value) {
                            uiController.incrementarPeso(1);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.exposure_plus_1),
                )
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilder(BuildContext context) async {
    var textControllerPeso = TextEditingController();
    final _focusNode = FocusNode();

    _focusNode.addListener(
      () {
        if (_focusNode.hasFocus) {
          textControllerPeso.selection = TextSelection(
              baseOffset: 0, extentOffset: textControllerPeso.text.length);
        }
      },
    );

    textControllerPeso.text =
        uiController.getValueDivisor(uiController.pesoTela.value.abs());

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Defina o Peso'),
          content: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormFieldWidget(
                  controller: textControllerPeso,
                  focusNode: _focusNode,
                  autoFocus: true,
                  title: "Peso",
                  textInputFormatter: [
                    CurrencyInputFormatterFreeEdit(
                        acceptNegative: true,
                        decimalPrecision: uiController.casasDecimais.value),
                    MaxValueImputFormatter(uiController.minMaxValue.value,
                        uiController.casasDecimais.value),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                uiController.pesoTela.value =
                    uiController.getValuePesosInt(textControllerPeso.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    textControllerPeso.clear();
  }
}
