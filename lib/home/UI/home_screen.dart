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
  late TextEditingController _textControllerMaxMinValue;
  late TextEditingController _textControllerCasasDecimais;

  ValueNotifier<int> minMaxValue = ValueNotifier(999999);
  ValueNotifier<int> casasDecimais = ValueNotifier(1);

  late HomeStateController homeState;
  void initController() {
    homeState = HomeStateController();

    _textControllerTara.addListener(
      () {
        homeState.taraTela = _textControllerTara.text;
      },
    );
    _textControllerMaxMinValue.addListener(
      () {
        var minMax = int.tryParse(_textControllerMaxMinValue.text
                .replaceAll('.', '')
                .replaceAll(',', '')) ??
            0;
        if (minMax <= homeState.getPeso) {
          homeState.setPeso(minMax);
        }
        minMaxValue.value = minMax;
      },
    );
    _textControllerCasasDecimais.addListener(
      () {
        casasDecimais.value =
            int.tryParse(_textControllerCasasDecimais.text) ?? 0;
      },
    );
    casasDecimais.addListener(() { 
      var pesoMinMaxAux = double.parse(_textControllerMaxMinValue.text);
      _textControllerMaxMinValue.text =pesoMinMaxAux.toStringAsFixed(casasDecimais.value);

      var taraAux = double.parse(_textControllerTara.text);
      _textControllerTara.text =taraAux.toStringAsFixed(casasDecimais.value);
    });
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

  @override
  void initState() {
    super.initState();
    _textControllerPorta = TextEditingController(text: '32211');
    _textControllerTara = TextEditingController(text: '0.0');
    _textControllerMaxMinValue = TextEditingController(text: '999999.0');
    _textControllerCasasDecimais = TextEditingController(text: '1');
    initController();
  }

  @override
  void dispose() {
    _textControllerPorta.dispose();
    super.dispose();
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
                  valueListenable: casasDecimais,
                  builder: (context,value,child) {
                    var pesoAux =state is HomeStateSucess ? state.peso : 0;
                    var pesoFormatado = (pesoAux / (value>0? pow(10, value):1)).toStringAsFixed(value);
                    return Text(
                        "Peso: $pesoFormatado");
                  }
                ),
                subtitle: ValueListenableBuilder(
                  valueListenable: casasDecimais,
                  builder: (context,casasDecimaisValue,child) {
                    return ValueListenableBuilder<int>(
                      valueListenable: minMaxValue,
                      builder: (context, minMaxValue, child) {
      
                          var pesoFormatado = (homeState.getPeso /
                                  (casasDecimaisValue > 0
                                      ? pow(10, casasDecimaisValue)
                                    : 1))
                              .toStringAsFixed(casasDecimaisValue);
                        return Slider(
                          min: -minMaxValue.toDouble(),
                          max: minMaxValue.toDouble(),
                          divisions: minMaxValue > 0 ? 2 * minMaxValue : 1,
                          value: double.parse(homeState.getPeso.toString()),
                          label: pesoFormatado,
                          onChanged: state is HomeStateSucess
                              ? (value) {
                                  homeState.setPeso(value.round());
                                }
                              : null,
                        );
                      },
                    );
                  }
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: state is HomeStateSucess
                      ? () {
                          homeState.setPeso(0);
                        }
                      : null,
                  child: const Text('Zerar Peso'),
                ),
              )
            ],
          );
        });
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
            ValueListenableBuilder<HomeState>(
              valueListenable: homeState,
              builder: (context, state, child) {
                return TextFormFieldWidget(
                  enabled: (state is! HomeStateSucess),
                  controller: _textControllerPorta,
                  title: 'Porta',
                );
              },
            ),
            ValueListenableBuilder<int>(
              valueListenable: casasDecimais,
              builder: (context,value,child) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormFieldWidget(
                        controller: _textControllerTara,
                        title: 'Tara',
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(value)
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormFieldWidget(
                        controller: _textControllerMaxMinValue,
                        title: 'Min/Max Valor',
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          MaxIntImputFormatter(999999),
                          CurrencyInputFormatter(value),
                        ],
                      ),
                    ),const SizedBox(width: 10),
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
              }
            ),
            _buildSliderPeso(),
            Expanded(
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
                      showDialogCustom(
                          context: context, msg: state.messageError!);
                    }
                    return _returnListProtocolos(state.protocolos ?? []);
                  }
                  return const SizedBox.shrink();
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
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
                const SizedBox(
                  width: 5,
                ),
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
      ),
    );
  }
}
