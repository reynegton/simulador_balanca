import 'package:equatable/equatable.dart';

abstract class ScaleBackendState extends Equatable {
  const ScaleBackendState();

  @override
  List<Object?> get props => [];
}

class ScaleBackendInitial extends ScaleBackendState {}

class ScaleBackendLoading extends ScaleBackendState {}

class ScaleBackendRunning extends ScaleBackendState {
  final String ip;
  final int port;
  final List<String> history;

  const ScaleBackendRunning(this.ip, this.port, this.history);

  @override
  List<Object> get props => [ip, port, history];
}

class ScaleBackendError extends ScaleBackendState {
  final String message;

  const ScaleBackendError(this.message);

  @override
  List<Object> get props => [message];
}
