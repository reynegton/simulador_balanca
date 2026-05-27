import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/config_bloc/config_bloc.dart';
import '../bloc/config_bloc/config_event.dart';
import '../bloc/config_bloc/config_state.dart';
import '../bloc/weight_bloc/weight_bloc.dart';
import '../bloc/weight_bloc/weight_state.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_bloc.dart';
import '../../../scale_backend/presentation/bloc/scale_backend_event.dart';
import '../../../../widgets/my_drawer_menu.dart';
import '../widgets/config_panel.dart';
import '../widgets/weight_panel.dart';
import '../widgets/log_panel.dart';
import 'package:libadwaita/libadwaita.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlapController _flapController = FlapController()..isOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<ConfigBloc>().add(LoadConfigEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AdwScaffold(
      scaffoldKey: _scaffoldKey,
      flapController: _flapController,
      flapOptions: const FlapOptions(
        foldPolicy: FoldPolicy.always,
      ),
      title: Text(
        'Simulador Balança',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: AdwActions(
        onClose: () => appWindow.close(),
        onMaximize: () => appWindow.maximizeOrRestore(),
        onMinimize: () => appWindow.minimize(),
        onHeaderDrag: () => appWindow.startDragging(),
        onDoubleTap: () => appWindow.maximizeOrRestore(),
      ),
      start: [
        IconButton(
          icon: const Icon(Icons.menu, size: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          onPressed: () => _flapController.toggle(),
          tooltip: 'Menu',
        ),
      ],
      flap: (isDrawer) => const MyDrawerMenu(),
      body: BlocListener<WeightBloc, WeightState>(
        listenWhen: (previous, current) =>
            previous.peso != current.peso || previous.tara != current.tara,
        listener: (context, state) {
          context
              .read<ScaleBackendBloc>()
              .add(EmitWeightEvent(state.peso, state.tara));
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

                  final panels = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConfigPanel(config: state.config),
                      const SizedBox(height: 16),
                      WeightPanel(config: state.config),
                    ],
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: panels,
                          ),
                        ),
                        const Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 16.0, bottom: 16.0, right: 16.0),
                              child: LogPanel(),
                            )),
                      ],
                    );
                  } else {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          panels,
                          const SizedBox(height: 16),
                          const SizedBox(
                            height: 400,
                            child: LogPanel(),
                          ),
                        ],
                      ),
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
