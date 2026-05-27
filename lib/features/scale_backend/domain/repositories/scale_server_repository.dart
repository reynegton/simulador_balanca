abstract class ScaleServerRepository {
  Future<String> startServer(int port);
  Future<void> stopServer();
  void broadcastMessage(String message);
  Stream<List<String>> get protocolHistoryStream;
}
