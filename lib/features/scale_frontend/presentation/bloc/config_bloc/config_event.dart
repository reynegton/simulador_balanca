import 'package:equatable/equatable.dart';
import '../../../domain/entities/scale_config.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object> get props => [];
}

class LoadConfigEvent extends ConfigEvent {}

class UpdateConfigEvent extends ConfigEvent {
  final ScaleConfig config;
  const UpdateConfigEvent(this.config);

  @override
  List<Object> get props => [config];
}
