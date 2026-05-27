import 'package:equatable/equatable.dart';

class ScaleConfig extends Equatable {
  final int port;
  final int minMaxValue;
  final int casasDecimais;

  const ScaleConfig({
    required this.port,
    required this.minMaxValue,
    required this.casasDecimais,
  });

  ScaleConfig copyWith({
    int? port,
    int? minMaxValue,
    int? casasDecimais,
  }) {
    return ScaleConfig(
      port: port ?? this.port,
      minMaxValue: minMaxValue ?? this.minMaxValue,
      casasDecimais: casasDecimais ?? this.casasDecimais,
    );
  }

  @override
  List<Object> get props => [port, minMaxValue, casasDecimais];
}
