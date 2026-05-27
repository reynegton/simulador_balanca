abstract class ProtocolStrategy {
  String formatWeight(int peso, int tara);
}

class DefaultProtocolStrategy implements ProtocolStrategy {
  @override
  String formatWeight(int peso, int tara) {
    var pesoStr = peso.abs().toString();
    var taraStr = tara.abs().toString();
    return "${String.fromCharCode(2)}+${peso >= 0 ? 'p' : 's'}`${pesoStr.padLeft(6, '0')}${taraStr.padLeft(6, '0')}${String.fromCharCode(13)}";
  }
}
