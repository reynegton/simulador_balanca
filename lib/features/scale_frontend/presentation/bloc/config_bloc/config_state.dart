import 'package:equatable/equatable.dart';
import '../../../domain/entities/scale_config.dart';

abstract class ConfigState extends Equatable {
  const ConfigState();

  @override
  List<Object> get props => [];
}

class ConfigInitial extends ConfigState {}

class ConfigLoading extends ConfigState {}

class ConfigLoaded extends ConfigState {
  final ScaleConfig config;

  const ConfigLoaded(this.config);

  @override
  List<Object> get props => [config];
}

class ConfigError extends ConfigState {
  final String message;

  const ConfigError(this.message);

  @override
  List<Object> get props => [message];
}
