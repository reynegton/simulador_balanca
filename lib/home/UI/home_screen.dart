import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simulador_balanca/home/States/home_state.dart';
import 'package:simulador_balanca/widgets/show_dialog_custom.dart';

import '../../Utils/currency_imput_formatter.dart';
import '../Controllers/home_controller.dart';
import '../../widgets/textformfiled.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _textControllerPorta;
  late TextEditingController _textControllerPesoIni;
  late TextEditingController _textControllerPesoFim;
  late TextEditingController _textControllerTara;

  late HomeStateController homeState;

  void initController() {
    homeState = HomeStateController();
    _textControllerTara.addListener(
      () {
        homeState.taraTela = _textControllerTara.text;
      },
    );
    _textControllerPesoIni.addListener(
      () {
        homeState.pesoInicialTela = _textControllerPesoIni.text;
      },
    );
    _textControllerPesoFim.addListener(
      () {
        homeState.pesoFinalTela = _textControllerPesoFim.text;
      },
    );
  }

  Widget _returnListProtocolos(List<String> listaProtocolos) {
    return ListView.builder(
      itemCount: listaProtocolos.length,
      itemBuilder: (context, index) {
        return Card(child: Text(listaProtocolos[index]));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _textControllerPorta = TextEditingController(text: '32211');
    _textControllerPesoIni = TextEditingController(text: '0.0');
    _textControllerPesoFim = TextEditingController(text: '0.0');
    _textControllerTara = TextEditingController(text: '0.0');
    initController();
  }

  @override
  void dispose() {
    _textControllerPorta.dispose();
    _textControllerPesoIni.dispose();
    _textControllerPesoFim.dispose();
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
            Row(
              children: [
                Expanded(
                  child: TextFormFieldWidget(
                    controller: _textControllerPesoIni,
                    title: 'Peso Inicial',
                    textInputFormatter: [CurrencyInputFormatter(1)],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormFieldWidget(
                    controller: _textControllerPesoFim,
                    title: 'Peso Final',
                    textInputFormatter: [CurrencyInputFormatter(1)],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormFieldWidget(
                    controller: _textControllerTara,
                    title: 'Tara',
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(1)
                    ],
                  ),
                )
              ],
            ),
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
