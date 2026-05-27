import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import 'features/scale_frontend/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return EasySplashScreen(
      logo: Image.asset('assets/balanca.png'),
      title: Text(
        "Simulador de Balança",
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      showLoader: true,
      loaderColor: theme.colorScheme.primary,
      loadingText: Text(
        "Carregando Dados...",
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      navigator: const HomePage(),
      durationInSeconds: 3,
    );
  }
}
