import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    _minMaxCtrl = TextEditingController(text: widget.config.minMaxValue.toString());
    _casasCtrl = TextEditingController(text: widget.config.casasDecimais.toString());
  }

  @override
  void dispose() {
    _portCtrl.dispose();
    _minMaxCtrl.dispose();
    _casasCtrl.dispose();
    super.dispose();
  }

  void _saveConfig() {
    final newConfig = widget.config.copyWith(
      port: int.tryParse(_portCtrl.text),
      minMaxValue: int.tryParse(_minMaxCtrl.text),
      casasDecimais: int.tryParse(_casasCtrl.text),
    );
    context.read<ConfigBloc>().add(UpdateConfigEvent(newConfig));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Configuração Salva')));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Configurações da Balança", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                SizedBox(width: 100, child: TextField(controller: _portCtrl, decoration: const InputDecoration(labelText: 'Porta TCP'), keyboardType: TextInputType.number)),
                SizedBox(width: 100, child: TextField(controller: _minMaxCtrl, decoration: const InputDecoration(labelText: 'Peso Máx.'), keyboardType: TextInputType.number)),
                SizedBox(width: 100, child: TextField(controller: _casasCtrl, decoration: const InputDecoration(labelText: 'Casas Dec.'), keyboardType: TextInputType.number)),
                ElevatedButton(onPressed: _saveConfig, child: const Text("Salvar")),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            BlocBuilder<ScaleBackendBloc, ScaleBackendState>(
              builder: (context, state) {
                if (state is ScaleBackendRunning) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      Text("Servidor rodando: ${state.ip}:${state.port}"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        onPressed: () => context.read<ScaleBackendBloc>().add(StopServerEvent()),
                        child: const Text("Parar Servidor", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  );
                } else if (state is ScaleBackendLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.cancel, color: Colors.red),
                      const Text("Servidor parado."),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () {
                          final port = int.tryParse(_portCtrl.text) ?? 9090;
                          context.read<ScaleBackendBloc>().add(StartServerEvent(port));
                        },
                        child: const Text("Iniciar Servidor", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
