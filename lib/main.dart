import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/Controllers/home_controller.dart';
import 'splash_page.dart';
import 'theme_manager.dart';

void main() {
  return runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: ChangeNotifierProvider<HomeController>(
        create: (_) => HomeController(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) => MaterialApp(
        debugShowCheckedModeBanner: kDebugMode,
        title: 'Simulador Balança IP',
        theme: theme.getTheme(),
        home: SplashPage(),
      ),
    );
  }
}
