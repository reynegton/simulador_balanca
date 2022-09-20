import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';

import '../States/home_state.dart';

class HomeStateController extends ValueNotifier<HomeState> {
  String pesoInicialTela = "";
  String pesoFinalTela = "";
  String taraTela = "";

  ServerSocket? _serverSocket;
  late Timer _timer;
  List<String> _protocolos = [];
  final List<Socket> _sockets = [];

  HomeStateController() : super(HomeStateDisconect());

  Future<void> disconectSocket() async {
    for (Socket socket in _sockets) {
      socket.close();
    }
    _sockets.clear();
    _timer.cancel();
    await _serverSocket?.close();
    _serverSocket = null;
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
          _protocolos.insert(0, protocolo);
          _protocolos = _protocolos.take(100).toList();
          _broadCast(protocolo);
          value = HomeStateSucess(_protocolos);
        },
      );
    } catch (e) {
      value = HomeStateDisconect(messageError: e.toString());
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
    var pesoini = double.tryParse(pesoInicialTela) ?? 0;
    var pesofim = double.tryParse(pesoFinalTela) ?? 0;
    var peso = Random().nextDouble() * (pesofim - pesoini).abs() + pesoini;
    var pesoStr =
        peso.abs().toStringAsFixed(1).replaceAll(',', '').replaceAll('.', '');
    var tara = double.tryParse(taraTela) ?? 0;
    var taraStr =
        tara.abs().toStringAsFixed(1).replaceAll(',', '').replaceAll('.', '');
    var protocolo =
        "${String.fromCharCode(2)}+${peso >= 0 ? 'p' : 's'}`${pesoStr.padLeft(6, '0')}${taraStr.padLeft(6, '0')}${String.fromCharCode(13)}";
    return protocolo;
  }
}