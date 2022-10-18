abstract class BalancaState {}

class BalancaStateDisconnect extends BalancaState {
  BalancaStateDisconnect({this.messageError, this.protocolos});
  String? messageError;
  List<String>? protocolos;
}

class BalancaStateLoading extends BalancaState {}

class BalancaStateSucess extends BalancaState {
  final List<String> protocolos;
  final int peso;
  BalancaStateSucess(this.protocolos,this.peso);
}
