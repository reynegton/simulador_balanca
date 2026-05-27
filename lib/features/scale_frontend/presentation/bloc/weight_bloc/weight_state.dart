import 'package:equatable/equatable.dart';

class WeightState extends Equatable {
  final int basePeso;
  final int peso;
  final int tara;
  final bool isOscillating;
  final int variance;

  const WeightState({
    required this.basePeso,
    required this.peso,
    required this.tara,
    required this.isOscillating,
    required this.variance,
  });

  factory WeightState.initial() {
    return const WeightState(
      basePeso: 0,
      peso: 0,
      tara: 0,
      isOscillating: false,
      variance: 0,
    );
  }

  WeightState copyWith({
    int? basePeso,
    int? peso,
    int? tara,
    bool? isOscillating,
    int? variance,
  }) {
    return WeightState(
      basePeso: basePeso ?? this.basePeso,
      peso: peso ?? this.peso,
      tara: tara ?? this.tara,
      isOscillating: isOscillating ?? this.isOscillating,
      variance: variance ?? this.variance,
    );
  }

  @override
  List<Object> get props => [basePeso, peso, tara, isOscillating, variance];
}
