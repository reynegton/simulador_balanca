import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Utils/currency_input_formatter_free_edit.dart';
import '../../../../Utils/max_value_imput_formatter.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_bloc.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_event.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_state.dart';
import '../../domain/entities/scale_config.dart';
import '../bloc/config_bloc/config_bloc.dart';
import '../bloc/config_bloc/config_event.dart';

class ConfigPanel extends StatefulWidget {
  final ScaleConfig config;
  const ConfigPanel({super.key, required this.config});

  @override
  State<ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends State<ConfigPanel> {
  late TextEditingController _portCtrl;
  late TextEditingController _minMaxCtrl;
  late TextEditingController _casasCtrl;

  @override
  void initState() {
    super.initState();
    _portCtrl = TextEditingController(text: widget.config.port.toString());
    
    final maxWeightPhysical = widget.config.minMaxValue / (widget.config.casasDecimais > 0 ? pow(10, widget.config.casasDecimais) : 1);
    _minMaxCtrl = TextEditingController(text: maxWeightPhysical.toStringAsFixed(widget.config.casasDecimais));
    
    _casasCtrl = TextEditingController(text: widget.config.casasDecimais.toString());
  }

  @override
  void didUpdateWidget(covariant ConfigPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      if (oldWidget.config.port != widget.config.port) {
        _portCtrl.text = widget.config.port.toString();
      }
      if (oldWidget.config.casasDecimais != widget.config.casasDecimais || oldWidget.config.minMaxValue != widget.config.minMaxValue) {
        final maxWeightPhysical = widget.config.minMaxValue / (widget.config.casasDecimais > 0 ? pow(10, widget.config.casasDecimais) : 1);
        _minMaxCtrl.text = maxWeightPhysical.toStringAsFixed(widget.config.casasDecimais);
        _casasCtrl.text = widget.config.casasDecimais.toString();
      }
    }
  }

  @override
  void dispose() {
    _portCtrl.dispose();
    _minMaxCtrl.dispose();
    _casasCtrl.dispose();
    super.dispose();
  }

  void _saveProtocol() {
    final casas = int.tryParse(_casasCtrl.text) ?? 0;
    final newConfig = widget.config.copyWith(
      port: int.tryParse(_portCtrl.text),
      casasDecimais: casas,
    );
    context.read<ConfigBloc>().add(UpdateConfigEvent(newConfig));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Protocolo e Casas Decimais Salvos')));
  }

  void _saveLimits() {
    final minMaxRaw = _minMaxCtrl.text.replaceAll(',', '.');
    final minMaxDouble = double.tryParse(minMaxRaw) ?? 0.0;
    final minMaxInt = (minMaxDouble * (widget.config.casasDecimais > 0 ? pow(10, widget.config.casasDecimais) : 1)).round();

    final newConfig = widget.config.copyWith(
      minMaxValue: minMaxInt,
    );
    context.read<ConfigBloc>().add(UpdateConfigEvent(newConfig));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Peso Máximo Salvo')));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ScaleBackendBloc, ScaleBackendState>(
          builder: (context, backendState) {
            final isRunning = backendState is ScaleBackendRunning;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 750;

                    final island1 = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Comunicação & Protocolo", style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: TextField(controller: _portCtrl, enabled: !isRunning, decoration: const InputDecoration(labelText: 'Porta TCP'), keyboardType: TextInputType.number)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _casasCtrl, 
                                enabled: !isRunning,
                                decoration: const InputDecoration(labelText: 'Casas Dec.'), 
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(onPressed: isRunning ? null : _saveProtocol, child: const Text("Aplicar Protocolo")),
                      ],
                    ),
                  ],
                );

                final island2 = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Limites da Balança", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                            Expanded(
                              child: TextField(
                                controller: _minMaxCtrl, 
                                enabled: !isRunning,
                                decoration: const InputDecoration(labelText: 'Peso Máx.'), 
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CurrencyInputFormatterFreeEdit(acceptNegative: false, decimalPrecision: widget.config.casasDecimais),
                                  MaxValueImputFormatter(999999, widget.config.casasDecimais),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(onPressed: isRunning ? null : _saveLimits, child: const Text("Aplicar Limites")),
                      ],
                    ),
                  ],
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: island1),
                      const SizedBox(width: 32),
                      Expanded(flex: 4, child: island2),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      island1,
                      const SizedBox(height: 24),
                      island2,
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                if (backendState is ScaleBackendRunning) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      Text("Servidor rodando: ${backendState.ip}:${backendState.port}"),
                      Builder(
                        builder: (context) {
                          const btnColor = Colors.redAccent;
                          final textColor = btnColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: btnColor, foregroundColor: textColor),
                            onPressed: () => context.read<ScaleBackendBloc>().add(StopServerEvent()),
                            child: const Text("Parar Servidor"),
                          );
                        }
                      )
                    ],
                  );
                } else if (backendState is ScaleBackendLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.cancel, color: Colors.red),
                      const Text("Servidor parado."),
                      Builder(
                        builder: (context) {
                          const btnColor = Colors.green;
                          final textColor = btnColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: btnColor, foregroundColor: textColor),
                            onPressed: () {
                              final port = int.tryParse(_portCtrl.text) ?? 9090;
                              context.read<ScaleBackendBloc>().add(StartServerEvent(port));
                            },
                            child: const Text("Iniciar Servidor"),
                          );
                        }
                      )
                    ],
                  );
                }
              },
            ),
          ],
        );
      }),
      ),
    );
  }
}
