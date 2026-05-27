import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_bloc.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_state.dart';

class LogPanel extends StatelessWidget {
  const LogPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColorDark,
            child: const Text("Log de Transmissão TCP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: BlocBuilder<ScaleBackendBloc, ScaleBackendState>(
              builder: (context, state) {
                if (state is ScaleBackendRunning) {
                  return ListView.builder(
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        title: Text(state.history[index], style: const TextStyle(fontFamily: 'monospace')),
                      );
                    },
                  );
                } else if (state is ScaleBackendError) {
                  return Center(child: Text("Erro no servidor: ${state.message}"));
                }
                return const Center(child: Text("Servidor Offline"));
              },
            ),
          )
        ],
      ),
    );
  }
}
