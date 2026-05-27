import 'package:equatable/equatable.dart';

abstract class ScaleBackendEvent extends Equatable {
  const ScaleBackendEvent();

  @override
  List<Object> get props => [];
}

class StartServerEvent extends ScaleBackendEvent {
  final int port;
  const StartServerEvent(this.port);

  @override
  List<Object> get props => [port];
}

class StopServerEvent extends ScaleBackendEvent {}

class EmitWeightEvent extends ScaleBackendEvent {
  final int peso;
  final int tara;

  const EmitWeightEvent(this.peso, this.tara);

  @override
  List<Object> get props => [peso, tara];
}

class UpdateHistoryEvent extends ScaleBackendEvent {
  final List<String> history;
  const UpdateHistoryEvent(this.history);

  @override
  List<Object> get props => [history];
}
