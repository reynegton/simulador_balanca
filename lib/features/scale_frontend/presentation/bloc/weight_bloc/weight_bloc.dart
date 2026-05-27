import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weight_event.dart';
import 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  Timer? _oscillationTimer;
  int _currentMinMax = 999999;

  WeightBloc() : super(WeightState.initial()) {
    on<SetManualWeightEvent>(_onSetManualWeight);
    on<SetTareEvent>(_onSetTare);
    on<ToggleOscillationEvent>(_onToggleOscillation);
    on<TickOscillationEvent>(_onTickOscillation);
  }

  void _onSetManualWeight(SetManualWeightEvent event, Emitter<WeightState> emit) {
    emit(state.copyWith(basePeso: event.peso, peso: event.peso));
  }

  void _onSetTare(SetTareEvent event, Emitter<WeightState> emit) {
    emit(state.copyWith(tara: event.tara));
  }

  void _onToggleOscillation(ToggleOscillationEvent event, Emitter<WeightState> emit) {
    _currentMinMax = event.minMax;
    emit(state.copyWith(isOscillating: event.isOscillating, variance: event.variance));
    
    if (event.isOscillating) {
      _oscillationTimer?.cancel();
      _oscillationTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
        add(TickOscillationEvent());
      });
    } else {
      _oscillationTimer?.cancel();
    }
  }

  void _onTickOscillation(TickOscillationEvent event, Emitter<WeightState> emit) {
    if (!state.isOscillating) return;

    var pesoini = state.basePeso - state.variance;
    var pesofim = state.basePeso + state.variance;

    if (pesofim > _currentMinMax) pesofim = _currentMinMax;
    if (pesoini < -_currentMinMax) pesoini = -_currentMinMax;

    var diferenca = (pesofim - pesoini).abs();
    var novoPeso = state.basePeso;
    if (diferenca > 0) {
      novoPeso = Random().nextInt(diferenca) + pesoini;
    }

    emit(state.copyWith(peso: novoPeso));
  }

  @override
  Future<void> close() {
    _oscillationTimer?.cancel();
    return super.close();
  }
}
