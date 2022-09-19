import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Utils/currency_imput_formatter.dart';
import '../controllers/home_controller.dart';
import '../widgets/textformfiled.dart';

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

  final SockerServer socket = SockerServer();

  @override
  void initState() {
    super.initState();
    _textControllerPorta = TextEditingController(text: '32211');
    _textControllerPesoIni = TextEditingController(text: '0');
    _textControllerPesoFim = TextEditingController(text: '0');
    _textControllerTara = TextEditingController(text: '0');

    _textControllerTara.addListener(
      () {
        socket.taraTela = _textControllerTara.text;
      },
    );
    _textControllerPesoIni.addListener(
      () {
        socket.pesoInicialTela = _textControllerPesoIni.text;
      },
    );
    _textControllerPesoFim.addListener(
      () {
        socket.pesoFinalTela = _textControllerPesoFim.text;
      },
    );
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
            ValueListenableBuilder(
              valueListenable: socket.conectado,
              builder: (context, value, child) {
                return TextFormFieldWidget(
                  enabled: !value,
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
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'\d')),
                      CurrencyInputFormatter(1)
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormFieldWidget(
                    controller: _textControllerPesoFim,
                    title: 'Peso Final',
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(1)
                    ],
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
              child: ValueListenableBuilder(
                valueListenable: socket.protocolos,
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Card(child: Text(value[index]));
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<bool>(
          valueListenable: socket.conectado,
          builder: (context, value, child) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: value
                        ? null
                        : () {
                            socket.createSocketServer(
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
                    onPressed: value ? socket.disconectSocket : null,
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
