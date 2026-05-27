import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/config_bloc/config_bloc.dart';
import '../bloc/config_bloc/config_event.dart';
import '../bloc/config_bloc/config_state.dart';
import '../bloc/weight_bloc/weight_bloc.dart';
import '../bloc/weight_bloc/weight_state.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_bloc.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_event.dart';
import '../../../../widgets/my_drawer_menu.dart';
import '../widgets/config_panel.dart';
import '../widgets/weight_panel.dart';
import '../widgets/log_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ConfigBloc>().add(LoadConfigEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador Balança (Clean Arch)'),
      ),
      drawer: const MyDrawerMenu(),
      body: BlocListener<WeightBloc, WeightState>(
        listener: (context, state) {
          // Whenever weight or tare changes, emit to backend!
          context.read<ScaleBackendBloc>().add(EmitWeightEvent(state.peso, state.tara));
        },
        child: BlocBuilder<ConfigBloc, ConfigState>(
          builder: (context, state) {
            if (state is ConfigLoading || state is ConfigInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ConfigError) {
              return Center(child: Text("Erro: ${state.message}"));
            }

            if (state is ConfigLoaded) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;

                  final mainContent = SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ConfigPanel(config: state.config),
                        const SizedBox(height: 16),
                        WeightPanel(config: state.config),
                      ],
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 4, child: mainContent),
                        const Expanded(flex: 2, child: LogPanel()),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 3, child: mainContent),
                        const Expanded(flex: 2, child: LogPanel()),
                      ],
                    );
                  }
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
