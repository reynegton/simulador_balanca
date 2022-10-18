import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:simulador_balanca/theme_manager.dart';

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
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Simulador Balança"),
                    Text(snapPackageInfo.data?.version ?? ""),
                    Expanded(child: Container()),
                    Text('Criado por Reynegton Nunes'),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Alterar Tema"),
                            SizedBox(width: 8),
                            Icon(theme.boDarkMode
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
