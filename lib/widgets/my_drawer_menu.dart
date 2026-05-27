import 'package:flutter/material.dart';
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
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Simulador Balança"),
                      Text(snapPackageInfo.data?.version ?? ""),
                      Expanded(child: Container()),
                      const Text('Criado por Reynegton Nunes'),
                    ],
                  ),
                ),
                ListTile(
                  title: Consumer<ThemeNotifier>(
                    builder: (context, theme, child) => InkWell(
                      onTap: () => !theme.boDarkMode
                          ? theme.setDarkMode()
                          : theme.setLightMode(),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.08),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Modo Escuro",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Icon(
                                theme.boDarkMode
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
