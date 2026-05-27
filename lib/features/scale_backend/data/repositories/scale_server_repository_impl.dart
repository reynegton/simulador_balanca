import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/scale_server_repository.dart';

class ScaleServerRepositoryImpl implements ScaleServerRepository {
  ServerSocket? _serverSocket;
  final List<Socket> _sockets = [];
  List<String> _history = [];

  final _historyController = StreamController<List<String>>.broadcast();

  @override
  Stream<List<String>> get protocolHistoryStream => _historyController.stream;

  @override
  Future<String> startServer(int port) async {
    try {
      _serverSocket =
          await ServerSocket.bind(InternetAddress.anyIPv4, port, shared: true);
      _serverSocket!.listen(_handleConnection);

      // Try to find the best non-loopback IPv4 to display
      var interfaces = await NetworkInterface.list();

      // Sort interfaces to prioritize physical adapters (deprioritize VPNs, WSL, VirtualBox, etc.)
      interfaces.sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();
        final aIsVirtual = aName.contains('virtual') ||
            aName.contains('vethernet') ||
            aName.contains('wsl') ||
            aName.contains('vmware') ||
            aName.contains('pseudo');
        final bIsVirtual = bName.contains('virtual') ||
            bName.contains('vethernet') ||
            bName.contains('wsl') ||
            bName.contains('vmware') ||
            bName.contains('pseudo');

        if (aIsVirtual && !bIsVirtual) return 1;
        if (!aIsVirtual && bIsVirtual) return -1;
        return 0;
      });

      String bestIp = '0.0.0.0';
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 &&
              !addr.isLoopback &&
              !addr.isLinkLocal) {
            bestIp = addr.address;
            break;
          }
        }
        if (bestIp != '0.0.0.0') break;
      }

      return bestIp;
    } catch (e) {
      throw Exception("Could not start server on port $port: $e");
    }
  }

  @override
  Future<void> stopServer() async {
    for (var socket in _sockets) {
      socket.close();
    }
    _sockets.clear();
    await _serverSocket?.close();
    _serverSocket = null;
    _history.clear();
    _historyController.add(_history);
  }

  @override
  void broadcastMessage(String message) {
    if (_serverSocket == null) return;

    for (var socket in _sockets) {
      try {
        socket.write(message);
      } catch (e) {
        debugPrint("Error writing to socket: $e");
      }
    }

    _history.insert(
      0,
      message
          .replaceAll(String.fromCharCode(2), '{2}')
          .replaceAll(String.fromCharCode(13), '{13}'),
    );
    _history = _history.take(100).toList();
    _historyController.add(_history);
  }

  void _handleConnection(Socket client) {
    if (!_sockets.contains(client)) {
      _sockets.add(client);
    }
    if (kDebugMode) {
      print(
          'Connection from ${client.remoteAddress.address}:${client.remotePort}');
    }
    client.listen(
      (data) {
        final message = String.fromCharCodes(data);
        if (kDebugMode) {
          print("Client msg: $message");
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print(error);
        }
        client.close();
      },
      onDone: () async {
        if (kDebugMode) {
          print('Client left');
        }
        _sockets.remove(client);
        await client.close();
      },
    );
  }
}
