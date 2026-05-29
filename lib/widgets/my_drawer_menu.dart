import 'package:flutter/material.dart';
import 'package:adwaita_flutter/adwaita_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../theme_manager.dart';

class MyDrawerMenu extends StatelessWidget {
  const MyDrawerMenu({super.key});

  Future<PackageInfo> get appPackageInfo async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: appPackageInfo,
      builder: (context, snapPackageInfo) {
        return SizedBox(
          width: 250,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Simulador Balança",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        snapPackageInfo.data?.version ?? "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Criado por Reynegton Nunes',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        height: 1,
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
                Consumer<ThemeNotifier>(
                  builder: (context, theme, child) => AdwSwitchRow(
                    title: 'Modo Escuro',
                    value: theme.boDarkMode,
                    onChanged: (_) => theme.boDarkMode
                        ? theme.setLightMode()
                        : theme.setDarkMode(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
