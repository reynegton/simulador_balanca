import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_page.dart';
import 'theme_manager.dart';
import 'Utils/shared_preferences_helper.dart';

import 'features/scale_backend/domain/formatters/protocol_strategy.dart';
import 'features/scale_backend/data/repositories/scale_server_repository_impl.dart';
import 'features/scale_backend/presentation/bloc/scale_backend_bloc.dart';

import 'features/scale_frontend/data/repositories/scale_config_repository_impl.dart';
import 'features/scale_frontend/presentation/bloc/config_bloc/config_bloc.dart';
import 'features/scale_frontend/presentation/bloc/weight_bloc/weight_bloc.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => ScaleServerRepositoryImpl()),
        RepositoryProvider(create: (_) => ScaleConfigRepositoryImpl(SharedPreferencesHelper.instance)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ScaleBackendBloc(
              repository: context.read<ScaleServerRepositoryImpl>(),
              protocolStrategy: DefaultProtocolStrategy(),
            ),
          ),
          BlocProvider(
            create: (context) => ConfigBloc(
              repository: context.read<ScaleConfigRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => WeightBloc(),
          ),
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, theme, child) => MaterialApp(
            debugShowCheckedModeBanner: kDebugMode,
            title: 'Simulador Balança IP',
            theme: theme.getTheme(),
            home: const SplashPage(),
          ),
        ),
      ),
    );
  }
}
