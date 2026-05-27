import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/scale_config.dart';
import '../bloc/weight_bloc/weight_bloc.dart';
import '../bloc/weight_bloc/weight_event.dart';
import '../bloc/weight_bloc/weight_state.dart';
import '../../../../Utils/currency_input_formatter_free_edit.dart';
import '../../../../Utils/max_value_imput_formatter.dart';

class WeightPanel extends StatefulWidget {
  final ScaleConfig config;
  const WeightPanel({super.key, required this.config});

  @override
  State<WeightPanel> createState() => _WeightPanelState();
}

class _WeightPanelState extends State<WeightPanel> {
  late TextEditingController _pesoCtrl;
  late TextEditingController _taraCtrl;
  late TextEditingController _oscilacaoCtrl;

  @override
  void initState() {
    super.initState();
    _pesoCtrl = TextEditingController();
    _taraCtrl = TextEditingController();
    _oscilacaoCtrl = TextEditingController(text: "0");
  }

  @override
  void dispose() {
    _pesoCtrl.dispose();
    _taraCtrl.dispose();
    _oscilacaoCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WeightPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.casasDecimais != widget.config.casasDecimais) {
      final bloc = context.read<WeightBloc>();
      _pesoCtrl.text = _formatValue(bloc.state.peso);
      _taraCtrl.text = _formatValue(bloc.state.tara);
    }
  }

  String _formatValue(int value) {
    return (value / (widget.config.casasDecimais > 0 ? pow(10, widget.config.casasDecimais) : 1))
        .toStringAsFixed(widget.config.casasDecimais);
  }

  int _parseValue(String text) {
    if (text.isEmpty) return 0;
    final clean = text.replaceAll('.', '').replaceAll(',', '');
    return int.tryParse(clean) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeightBloc, WeightState>(
      listenWhen: (previous, current) => previous.peso != current.peso && current.isOscillating,
      listener: (context, state) {
        // Sync text controller when oscillating
        _pesoCtrl.text = _formatValue(state.peso);
      },
      builder: (context, state) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Simulação de Peso", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pesoCtrl,
                        decoration: const InputDecoration(labelText: 'Peso Base'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatterFreeEdit(acceptNegative: true, decimalPrecision: widget.config.casasDecimais),
                          MaxValueImputFormatter(widget.config.minMaxValue, widget.config.casasDecimais),
                        ],
                        onChanged: (val) {
                          context.read<WeightBloc>().add(SetManualWeightEvent(_parseValue(val)));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _taraCtrl,
                        decoration: const InputDecoration(labelText: 'Tara'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatterFreeEdit(acceptNegative: false, decimalPrecision: widget.config.casasDecimais),
                          MaxValueImputFormatter(widget.config.minMaxValue, widget.config.casasDecimais),
                        ],
                        onChanged: (val) {
                           context.read<WeightBloc>().add(SetTareEvent(_parseValue(val)));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Ajuste Rápido:"),
                    Expanded(
                      child: Slider(
                        value: state.basePeso.toDouble().clamp(
                              -(widget.config.minMaxValue.toDouble()),
                              widget.config.minMaxValue.toDouble(),
                            ),
                        min: -(widget.config.minMaxValue.toDouble()),
                        max: widget.config.minMaxValue.toDouble(),
                        onChanged: (val) {
                          context.read<WeightBloc>().add(SetManualWeightEvent(val.toInt()));
                          _pesoCtrl.text = _formatValue(val.toInt());
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Text("Oscilar Peso"),
                    Switch(
                      value: state.isOscillating,
                      onChanged: (val) {
                        final variance = _parseValue(_oscilacaoCtrl.text);
                        context.read<WeightBloc>().add(ToggleOscillationEvent(val, variance, widget.config.minMaxValue));
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _oscilacaoCtrl,
                        enabled: !state.isOscillating,
                        decoration: const InputDecoration(labelText: 'Variância de Oscilação (+/-)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatterFreeEdit(acceptNegative: false, decimalPrecision: widget.config.casasDecimais),
                          MaxValueImputFormatter(widget.config.minMaxValue, widget.config.casasDecimais),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
