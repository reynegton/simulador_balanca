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
import 'package:adwaita_flutter/adwaita_flutter.dart';

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
  bool _isPanelExpanded = true;

  @override
  void initState() {
    super.initState();
    _portCtrl = TextEditingController(text: widget.config.port.toString());

    final maxWeightPhysical = widget.config.minMaxValue /
        (widget.config.casasDecimais > 0
            ? pow(10, widget.config.casasDecimais)
            : 1);
    _minMaxCtrl = TextEditingController(
        text: maxWeightPhysical.toStringAsFixed(widget.config.casasDecimais));

    _casasCtrl =
        TextEditingController(text: widget.config.casasDecimais.toString());
  }

  @override
  void didUpdateWidget(covariant ConfigPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      if (oldWidget.config.port != widget.config.port) {
        _portCtrl.text = widget.config.port.toString();
      }
      if (oldWidget.config.casasDecimais != widget.config.casasDecimais ||
          oldWidget.config.minMaxValue != widget.config.minMaxValue) {
        final maxWeightPhysical = widget.config.minMaxValue /
            (widget.config.casasDecimais > 0
                ? pow(10, widget.config.casasDecimais)
                : 1);
        _minMaxCtrl.text =
            maxWeightPhysical.toStringAsFixed(widget.config.casasDecimais);
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
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Protocolo e Casas Decimais Salvos')));
  }

  void _saveLimits() {
    final minMaxRaw = _minMaxCtrl.text.replaceAll(',', '.');
    final minMaxDouble = double.tryParse(minMaxRaw) ?? 0.0;
    final minMaxInt = (minMaxDouble *
            (widget.config.casasDecimais > 0
                ? pow(10, widget.config.casasDecimais)
                : 1))
        .round();

    final newConfig = widget.config.copyWith(
      minMaxValue: minMaxInt,
    );
    context.read<ConfigBloc>().add(UpdateConfigEvent(newConfig));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Peso Máximo Salvo')));
  }

  @override
  Widget build(BuildContext context) {
    final maxWeightPhysical = widget.config.minMaxValue /
        (widget.config.casasDecimais > 0
            ? pow(10, widget.config.casasDecimais)
            : 1);

    return BlocConsumer<ScaleBackendBloc, ScaleBackendState>(
      listenWhen: (previous, current) {
        return previous is! ScaleBackendRunning && current is ScaleBackendRunning;
      },
      listener: (context, backendState) {
        if (backendState is ScaleBackendRunning) {
          setState(() {
            _isPanelExpanded = false;
          });
        }
      },
      builder: (context, backendState) {
        final isRunning = backendState is ScaleBackendRunning;

        final connectionCard = AdwCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (backendState is ScaleBackendRunning) ...[
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Servidor Ativo",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Rodando em: ${backendState.ip}:${backendState.port}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 160,
                    child: AdwButton(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                      opaque: true,
                      onPressed: () => context
                          .read<ScaleBackendBloc>()
                          .add(StopServerEvent()),
                      child: const Text("Parar Servidor"),
                    ),
                  ),
                ] else if (backendState is ScaleBackendLoading) ...[
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Iniciando Servidor...",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ] else ...[
                  Icon(
                    Icons.cancel,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Servidor Parado",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Nenhuma conexão ativa.",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 160,
                    child: AdwButton(
                      backgroundColor: AdwaitaColors.green5,
                      textStyle: const TextStyle(color: Colors.white),
                      opaque: true,
                      onPressed: () {
                        final port = int.tryParse(_portCtrl.text) ?? 32211;
                        context
                            .read<ScaleBackendBloc>()
                            .add(StartServerEvent(port));
                      },
                      child: const Text("Iniciar Servidor"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdwExpanderCard(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Configuração da Balança'),
              subtitle: Text(
                'Porta: ${widget.config.port}  •  Casas Dec.: ${widget.config.casasDecimais}  •  Peso Máx.: ${maxWeightPhysical.toStringAsFixed(widget.config.casasDecimais)} kg',
              ),
              expanded: _isPanelExpanded,
              onExpansionChanged: (val) {
                setState(() {
                  _isPanelExpanded = val;
                });
              },
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 750;

                    final island1 = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Comunicação & Protocolo",
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: AdwTextField(
                                controller: _portCtrl,
                                enabled: !isRunning,
                                decoration:
                                    const InputDecoration(labelText: 'Porta TCP'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AdwTextField(
                                controller: _casasCtrl,
                                enabled: !isRunning,
                                decoration:
                                    const InputDecoration(labelText: 'Casas Dec.'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 160,
                              child: AdwButton(
                                onPressed: isRunning ? null : _saveProtocol,
                                child: const Text("Aplicar Protocolo"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );

                    final island2 = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Limites da Balança",
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: AdwTextField(
                                controller: _minMaxCtrl,
                                enabled: !isRunning,
                                decoration:
                                    const InputDecoration(labelText: 'Peso Máx.'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CurrencyInputFormatterFreeEdit(
                                    acceptNegative: false,
                                    decimalPrecision: widget.config.casasDecimais,
                                  ),
                                  MaxValueImputFormatter(
                                    999999,
                                    widget.config.casasDecimais,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 160,
                              child: AdwButton(
                                onPressed: isRunning ? null : _saveLimits,
                                child: const Text("Aplicar Limites"),
                              ),
                            ),
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
              ],
            ),
            const SizedBox(height: 12),
            connectionCard,
          ],
        );
      },
    );
  }
}
