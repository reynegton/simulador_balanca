import 'package:flutter/material.dart';
import 'package:adwaita_flutter/adwaita_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdwWindow.initialize(
    title: 'GNOME Workbench',
    defaultSize: const Size(1000, 700),
    minimumSize: const Size(600, 500),
  );
  runApp(const ShowcaseApp());
}

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Libadwaita Showcase',
      debugShowCheckedModeBanner: false,
      theme: AdwaitaThemeData.light(),
      darkTheme: AdwaitaThemeData.dark(),
      themeMode: _themeMode,
      home: ShowcaseHome(
        toggleTheme: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  final VoidCallback toggleTheme;
  final bool isDark;

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  double _spinValue = 50.0;
  bool _bannerRevealed = true;

  @override
  Widget build(BuildContext context) {
    return AdwToastOverlay(
      child: AdwPreferencesWindow(
        title: const Text('GNOME Workbench'),
        start: [],
        end: [
          AdwHeaderButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
        pages: [
          AdwPreferencesPage(
            title: 'Components',
            icon: Icons.widgets,
            name: 'components',
            children: [
              AdwBanner(
                title: 'Welcome to the Ultimate Showcase!',
                buttonLabel: 'Dismiss',
                isRevealed: _bannerRevealed,
                onButtonClicked: () {
                  setState(() {
                    _bannerRevealed = false;
                  });
                },
              ),
              AdwPreferencesGroup(
                title: 'Buttons & Controls',
                description: 'Showcasing various native buttons.',
                children: [
                  AdwActionRow(
                    title: 'Action Row',
                    subtitle: 'Standard row with a button',
                    end: AdwButton(
                      child: const Text('Click Me'),
                      onPressed: () {
                        AdwToastOverlay.of(context).addToast(
                          AdwToast(title: 'Button Clicked!'),
                        );
                      },
                    ),
                  ),
                  AdwActionRow(
                    title: 'Split Button',
                    end: AdwSplitButton(
                      onPressed: () {
                        AdwToastOverlay.of(context).addToast(
                          AdwToast(title: 'Primary Action Clicked!'),
                        );
                      },
                      menuItems: const [
                        PopupMenuItem(child: Text('Option 1')),
                        PopupMenuItem(child: Text('Option 2')),
                      ],
                      child: const Text('Split Action'),
                    ),
                  ),
                  AdwButtonRow(
                    title: 'Destructive Action',
                    startIcon: const Icon(Icons.delete),
                    destructive: true,
                    onPressed: () {
                      AdwToastOverlay.of(context).addToast(
                        AdwToast(title: 'Deleted successfully!'),
                      );
                    },
                  ),
                ],
              ),
              AdwPreferencesGroup(
                title: 'Toggles & Switches',
                children: [
                  AdwSwitchRow(
                    title: 'Enable Feature',
                    subtitle: 'Toggle this feature on or off',
                    value: true,
                    onChanged: (val) {
                      AdwToastOverlay.of(context).addToast(
                        AdwToast(title: val ? 'Enabled!' : 'Disabled!'),
                      );
                    },
                  ),
                ],
              ),
              AdwPreferencesGroup(
                title: 'Data & Display',
                children: [
                  AdwActionRow(
                    title: 'User Profile',
                    subtitle: 'AdwAvatar component',
                    start: AdwAvatar.text(
                      size: 48,
                      text: 'JD',
                      backgroundColor: AdwColors.blue,
                    ),
                  ),
                  const AdwStatusPage(
                    title: 'No Items Found',
                    description: 'Try adjusting your search criteria.',
                    icon: Icon(Icons.search_off),
                  ),
                ],
              ),
              AdwPreferencesGroup(
                title: 'Advanced Rows (Phase 3 & 4)',
                children: [
                  AdwEntryRow(
                    title: 'Username',
                    onChanged: (val) {},
                  ),
                  AdwPasswordEntryRow(
                    title: 'Password',
                    onChanged: (val) {},
                  ),
                  AdwComboRow(
                    title: 'Select Theme',
                    subtitle: 'Choose your preferred visual style',
                    choices: const ['System', 'Light', 'Dark'],
                    selectedIndex: 0,
                    onSelected: (val) {},
                  ),
                  AdwSpinRow(
                    title: 'Spin Row (Numeric Control)',
                    value: _spinValue,
                    min: 0,
                    max: 100,
                    step: 10,
                    onChanged: (val) {
                      setState(() {
                        _spinValue = val;
                      });
                    },
                  ),
                  AdwExpanderRow(
                    title: 'Advanced Settings',
                    subtitle: 'Expand for more options',
                    startIcon: const Icon(Icons.settings_applications),
                    children: [
                      const AdwActionRow(
                        title: 'Hidden Setting 1',
                        end: Text('Value 1'),
                      ),
                      const AdwActionRow(
                        title: 'Hidden Setting 2',
                        end: Text('Value 2'),
                      ),
                    ],
                  ),
                ],
              ),
              AdwPreferencesGroup(
                title: 'Carousel & Media',
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 150,
                      child: Column(
                        children: [
                          Expanded(
                            child: AdwCarousel(
                              children: [
                                Container(color: Colors.blue.withValues(alpha: 0.2), child: const Center(child: Text('Page 1'))),
                                Container(color: Colors.red.withValues(alpha: 0.2), child: const Center(child: Text('Page 2'))),
                                Container(color: Colors.green.withValues(alpha: 0.2), child: const Center(child: Text('Page 3'))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const AdwCarouselIndicator(
                            itemCount: 3,
                            currentIndex: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              AdwPreferencesGroup(
                title: 'Dialogs & Feedback',
                children: [
                  AdwActionRow(
                    title: 'Show Alert Dialog',
                    subtitle: 'Classic floating alert',
                    end: AdwButton(
                      child: const Text('Show'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AdwAlertDialog(
                            heading: 'Discard Changes?',
                            bodyText: 'Are you sure you want to discard your changes? This action cannot be undone.',
                            responses: [
                              AdwAlertDialogResponse(
                                id: 'cancel',
                                label: 'Cancel',
                              ),
                              AdwAlertDialogResponse(
                                id: 'discard',
                                label: 'Discard',
                                appearance: AdwAlertDialogResponseAppearance.destructive,
                              ),
                            ],
                          ),
                        ).then((value) {
                          if (value != null) {
                            AdwToastOverlay.of(context).addToast(
                              AdwToast(title: 'Dialog returned: $value'),
                            );
                          }
                        });
                      },
                    ),
                  ),
                  AdwActionRow(
                    title: 'Show Adaptive Dialog (Libadwaita 1.5)',
                    subtitle: 'Morphs into Bottom Sheet on narrow screens',
                    end: AdwButton(
                      child: const Text('Launch'),
                      onPressed: () {
                        AdwDialog.show(
                          context: context,
                          title: 'Adaptive Dialog',
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.rocket_launch, size: 64, color: Colors.blue),
                                const SizedBox(height: 16),
                                const Text(
                                  'Try resizing the window! If it gets narrow, I will snap to the bottom as a sheet.',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                AdwButtonRow(
                                  title: 'Got it!',
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              AdwPreferencesGroup(
                title: 'Responsive & Navigation Layouts',
                children: [
                  AdwActionRow(
                    title: 'AdwNavigationSplitView Demo',
                    subtitle: 'Launch a separate screen to test the split view',
                    end: AdwButton(
                      child: const Text('Launch'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NavigationSplitViewDemo(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AdwBreakpointBin(
                      breakpointWidth: 400,
                      narrowChild: Container(
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: const Text('Narrow Layout (Width < 400)', textAlign: TextAlign.center),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: const Text('Wide Layout (Width > 400)', textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
              AdwPreferencesGroup(
                title: 'Browser-Style Tabs & Squeezer',
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('AdwSqueezer (Resizes intelligently)', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          height: 60,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: AdwSqueezer(
                            children: const [
                              AdwSqueezerChild(
                                minWidth: 400,
                                child: Center(child: Text('Extra Wide Detailed View (>= 400px)')),
                              ),
                              AdwSqueezerChild(
                                minWidth: 200,
                                child: Center(child: Text('Medium View (>= 200px)')),
                              ),
                              AdwSqueezerChild(
                                minWidth: 0,
                                child: Center(child: Icon(Icons.star)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('AdwTabView', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          child: const AdwTabView(
                            tabs: [
                              AdwTab(
                                title: 'GNOME Web',
                                icon: Icon(Icons.public),
                                child: Center(child: Text('Web Content Here')),
                              ),
                              AdwTab(
                                title: 'Settings',
                                icon: Icon(Icons.settings),
                                child: Center(child: Text('Settings Content Here')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          AdwPreferencesPage(
            title: 'About',
            icon: Icons.info,
            name: 'about',
            children: [
              AdwPreferencesGroup(
                children: [
                  const AdwActionRow(
                    title: 'Version',
                    end: Text('1.0.0'),
                  ),
                  const AdwActionRow(
                    title: 'License',
                    end: Text('MIT'),
                  ),
                  AdwButtonRow(
                    title: 'Show AdwAboutWindow',
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (context, _, __) => const AdwAboutWindow(
                          appName: 'GNOME Workbench',
                          appVersion: '1.0.0',
                          appIcon: Icon(Icons.code, size: 64),
                        ),
                      );
                    },
                  ),
                  AdwButtonRow(
                    title: 'View on GitHub',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NavigationSplitViewDemo extends StatelessWidget {
  const NavigationSplitViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Split View')),
      body: AdwNavigationSplitView(
        sidebar: Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(child: Text('Sidebar (e.g. List of Chats)')),
        ),
        content: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Center(
            child: AdwButton(
              child: const Text('Go Back'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
    );
  }
}
