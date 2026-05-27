import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/scale_config_repository.dart';
import 'config_event.dart';
import 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ScaleConfigRepository repository;

  ConfigBloc({required this.repository}) : super(ConfigInitial()) {
    on<LoadConfigEvent>(_onLoadConfig);
    on<UpdateConfigEvent>(_onUpdateConfig);
  }

  Future<void> _onLoadConfig(
      LoadConfigEvent event, Emitter<ConfigState> emit) async {
    emit(ConfigLoading());
    try {
      final config = await repository.loadConfig();
      emit(ConfigLoaded(config));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }

  Future<void> _onUpdateConfig(
      UpdateConfigEvent event, Emitter<ConfigState> emit) async {
    try {
      await repository.saveConfig(event.config);
      emit(ConfigLoaded(event.config));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }
}
