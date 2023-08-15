import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';

import '../States/balanca_state.dart';
import 'home_controller.dart';

class BalancaController extends ValueNotifier<BalancaState> {
  HomeController uiController;
  ServerSocket? _serverSocket;
  late Timer _timer;
  List<String> _protocolos = [];
  final List<Socket> _sockets = [];

  BalancaController(this.uiController) : super(BalancaStateDisconnect());

  Future<void> disconectSocket() async {
    for (var socket in _sockets) {
      socket.close();
    }
    _sockets.clear();
    _timer.cancel();
    await _serverSocket?.close();
    _serverSocket = null;
    uiController.pesoTela.value = 0;
    value = BalancaStateDisconnect(protocolos: _protocolos);
  }

  Future<void> _connect(InternetAddress address, int porta) async {
    try {
      value = BalancaStateLoading();
      _serverSocket = await ServerSocket.bind(address, porta, shared: true);
      _serverSocket?.listen(
        _handleConnection,
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
          value = BalancaStateSucess(_protocolos, uiController.pesoTela.value);
        },
      );
    } on Exception catch (e) {
      value = BalancaStateDisconnect(
          messageError: e.toString(), protocolos: _protocolos);
      rethrow;
    }
  }

  Future<void> createServer(int porta) async {
    var listaAddress = await getAddress();
    for (var element in listaAddress) {
      try{
        await _connect(element, porta);
        uiController.setEnderecoIp(element.address);
      } on Exception catch (_) {
      }
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
      (data) {
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
    for (var socket in _sockets) {
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
      if (pesofim > uiController.minMaxValue.value) {
        pesofim = uiController.minMaxValue.value;
      }
      if (pesoini < -uiController.minMaxValue.value) {
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

  Future<List<InternetAddress>> getAddress() async {
    var enderecos = <InternetAddress>[];
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          enderecos.add(addr);
        }
      }
    }
    return enderecos;
  }
}
