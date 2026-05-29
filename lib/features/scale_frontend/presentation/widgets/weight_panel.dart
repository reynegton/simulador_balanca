import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adwaita_flutter/adwaita_flutter.dart';
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
    final bloc = context.read<WeightBloc>();
    _pesoCtrl = TextEditingController(text: _formatValue(bloc.state.peso));
    _taraCtrl = TextEditingController(text: _formatValue(bloc.state.tara));
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
    return (value /
            (widget.config.casasDecimais > 0
                ? pow(10, widget.config.casasDecimais)
                : 1))
        .toStringAsFixed(widget.config.casasDecimais);
  }

  int _parseValue(String text) {
    if (text.isEmpty) return 0;
    final cleanText = text.replaceAll(',', '.');
    final doubleValue = double.tryParse(cleanText) ?? 0.0;
    return (doubleValue *
            (widget.config.casasDecimais > 0
                ? pow(10, widget.config.casasDecimais)
                : 1))
        .round();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightBloc, WeightState>(
      builder: (context, state) {
        return AdwCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Simulação de Peso",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AdwTextField(
                        controller: _pesoCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Peso Base'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatterFreeEdit(
                              acceptNegative: true,
                              decimalPrecision: widget.config.casasDecimais),
                          MaxValueImputFormatter(widget.config.minMaxValue,
                              widget.config.casasDecimais),
                        ],
                        onChanged: (val) {
                          context
                              .read<WeightBloc>()
                              .add(SetManualWeightEvent(_parseValue(val)));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AdwTextField(
                        controller: _taraCtrl,
                        decoration: const InputDecoration(labelText: 'Tara'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatterFreeEdit(
                              acceptNegative: false,
                              decimalPrecision: widget.config.casasDecimais),
                          MaxValueImputFormatter(widget.config.minMaxValue,
                              widget.config.casasDecimais),
                        ],
                        onChanged: (val) {
                          context
                              .read<WeightBloc>()
                              .add(SetTareEvent(_parseValue(val)));
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
                          context
                              .read<WeightBloc>()
                              .add(SetManualWeightEvent(val.toInt()));
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
                    const SizedBox(width: 16),
                    AdwSwitch(
                      value: state.isOscillating,
                      onChanged: (val) {
                        final variance = _parseValue(_oscilacaoCtrl.text);
                        context.read<WeightBloc>().add(ToggleOscillationEvent(
                            val, variance, widget.config.minMaxValue));
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AdwTextField(
                        controller: _oscilacaoCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Variância de Oscilação (+/-)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatterFreeEdit(
                              acceptNegative: false,
                              decimalPrecision: widget.config.casasDecimais),
                          MaxValueImputFormatter(widget.config.minMaxValue,
                              widget.config.casasDecimais),
                        ],
                        onChanged: (val) {
                          if (state.isOscillating) {
                            final variance = _parseValue(val);
                            context.read<WeightBloc>().add(
                                ToggleOscillationEvent(
                                    true, variance, widget.config.minMaxValue));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Builder(builder: (context) {
                      final colorScheme = Theme.of(context).colorScheme;
                      final displayColor = colorScheme.primary;
                      final displayTextColor = colorScheme.onPrimary;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: displayColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.monitor_weight, color: displayTextColor),
                            const SizedBox(width: 8),
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Text(
                                  _formatValue(widget.config.minMaxValue),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: Colors.transparent,
                                      ),
                                ),
                                Text(
                                  _formatValue(state.peso),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: displayTextColor,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
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
