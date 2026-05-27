import 'package:equatable/equatable.dart';

abstract class WeightEvent extends Equatable {
  const WeightEvent();

  @override
  List<Object> get props => [];
}

class SetManualWeightEvent extends WeightEvent {
  final int peso;
  const SetManualWeightEvent(this.peso);

  @override
  List<Object> get props => [peso];
}

class SetTareEvent extends WeightEvent {
  final int tara;
  const SetTareEvent(this.tara);

  @override
  List<Object> get props => [tara];
}

class ToggleOscillationEvent extends WeightEvent {
  final bool isOscillating;
  final int variance;
  final int minMax;

  const ToggleOscillationEvent(this.isOscillating, this.variance, this.minMax);

  @override
  List<Object> get props => [isOscillating, variance, minMax];
}

class TickOscillationEvent extends WeightEvent {}
