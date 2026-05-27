import 'package:equatable/equatable.dart';

class ScaleProtocol extends Equatable {
  final String formattedString;

  const ScaleProtocol(this.formattedString);

  @override
  List<Object> get props => [formattedString];
}
