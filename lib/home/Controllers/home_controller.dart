import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';

import '../States/home_state.dart';

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

class HomeStateController extends ValueNotifier<HomeState> {
  UiController uiController;
  /*int _pesoTela = 0;
  String taraTela = "";*/

  ServerSocket? _serverSocket;
  late Timer _timer;
  List<String> _protocolos = [];
  final List<Socket> _sockets = [];

  HomeStateController(this.uiController) : super(HomeStateDisconect());

  Future<void> disconectSocket() async {
    for (Socket socket in _sockets) {
      socket.close();
    }
    _sockets.clear();
    _timer.cancel();
    await _serverSocket?.close();
    _serverSocket = null;
    uiController.pesoTela.value = 0;
    value = HomeStateDisconect(protocolos: _protocolos);
  }

  Future<void> createServer(int porta) async {
    try {
      value = HomeStateLoading();
      _serverSocket =
          await ServerSocket.bind(InternetAddress.anyIPv4, porta, shared: true);
      _serverSocket?.listen(
        (client) {
          _handleConnection(client);
        },
      );
      _timer = Timer.periodic(
        const Duration(milliseconds: 300),
        (_) {
          var protocolo = _getStringProtocolo();
          _protocolos.insert(
            0,
            protocolo
                .replaceAll(String.fromCharCode(2), '{2}')
                .replaceAll(String.fromCharCode(13), '{13}'),
          );
          _protocolos = _protocolos.take(100).toList();
          _broadCast(protocolo);
          value = HomeStateSucess(_protocolos, uiController.pesoTela.value);
        },
      );
    } catch (e) {
      value = HomeStateDisconect(
          messageError: e.toString(), protocolos: _protocolos);
    }
  }

  void _handleConnection(Socket client) {
    if (!_sockets.contains(client)) {
      _sockets.add(client);
    }
    if (kDebugMode) {
      print('Connection from'
          ' ${client.remoteAddress.address}:${client.remotePort}');
    }
    // listen for events from the client
    client.listen(
      // handle data from the client
      (Uint8List data) {
        final message = String.fromCharCodes(data);
        if (kDebugMode) {
          print(message);
        }
      },
      // handle errors
      onError: (error) {
        if (kDebugMode) {
          print(error);
        }
        client.close();
      },
      // handle the client closing the connection
      onDone: () async {
        if (kDebugMode) {
          print('Client left');
        }
        _sockets.remove(client);
        await client.close();
      },
    );
  }

  _broadCast(String message) {
    for (Socket socket in _sockets) {
      socket.write(message);
    }
  }

  String _getStringProtocolo() {
    var peso = 0;
    if (uiController.oscilarPeso.value) {
      var pesoini =
          uiController.pesoTela.value - uiController.pesoOscilacao.value;
      var pesofim =
          uiController.pesoTela.value + uiController.pesoOscilacao.value;
      if (pesofim > uiController.minMaxValue.value){
        pesofim = uiController.minMaxValue.value;
      }
      if (pesoini < -uiController.minMaxValue.value){
        pesoini = -uiController.minMaxValue.value;
      }
      var diferenca = (pesofim - pesoini).abs();
      if (diferenca > 0) {
        peso = Random().nextInt(diferenca) + pesoini;
      } else {
        peso = pesoini;
      }
    } else {
      peso = uiController.pesoTela.value;
    }

    var pesoStr = peso.abs().toString();
    var tara = uiController.taraTela.value;
    var taraStr = tara.abs().toString();
    var protocolo =
        "${String.fromCharCode(2)}+${peso >= 0 ? 'p' : 's'}`${pesoStr.padLeft(6, '0')}${taraStr.padLeft(6, '0')}${String.fromCharCode(13)}";
    return protocolo;
  }
}
