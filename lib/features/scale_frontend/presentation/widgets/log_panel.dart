import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libadwaita/libadwaita.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_bloc.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_state.dart';

class LogPanel extends StatelessWidget {
  const LogPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AdwCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Log de Transmissão TCP",
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
                        title: Text(state.history[index],
                            style: Theme.of(context).textTheme.bodySmall),
                      );
                    },
                  );
                } else if (state is ScaleBackendError) {
                  return Center(
                      child: Text("Erro no servidor: ${state.message}"));
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
