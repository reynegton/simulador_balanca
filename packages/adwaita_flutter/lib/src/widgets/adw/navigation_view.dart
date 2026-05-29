import 'package:adwaita_flutter/src/theme/adw_constants.dart';
import 'package:flutter/material.dart';

/// A single page inside an [AdwNavigationView].
class AdwNavigationPage extends StatelessWidget {
  const AdwNavigationPage({
    super.key,
    required this.child,
    this.title,
  });

  /// The content of the page.
  final Widget child;

  /// Optional title for the page.
  final String? title;
  
  @override
  Widget build(BuildContext context) => child;
}

/// A simplified declarative navigation stack mirroring AdwNavigationView.
/// 
/// Pushes and pops [AdwNavigationPage]s with horizontal slide animations
/// typical of the GNOME HIG.
class AdwNavigationView extends StatefulWidget {
  const AdwNavigationView({
    super.key,
    required this.pages,
    this.initialIndex = 0,
  });

  /// The list of available pages.
  final List<AdwNavigationPage> pages;

  /// The index of the page to show initially.
  final int initialIndex;

  @override
  State<AdwNavigationView> createState() => AdwNavigationViewState();

  static AdwNavigationViewState of(BuildContext context) {
    return context.findAncestorStateOfType<AdwNavigationViewState>()!;
  }
}

class AdwNavigationViewState extends State<AdwNavigationView> {
  late List<int> _stack;

  @override
  void initState() {
    super.initState();
    _stack = [widget.initialIndex];
  }

  /// Pushes a new page by its index in the [pages] list.
  void push(int index) {
    setState(() {
      _stack.add(index);
    });
  }

  /// Pops the topmost page.
  void pop() {
    if (_stack.length > 1) {
      setState(() {
        _stack.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _stack.last;
    
    return AnimatedSwitcher(
      duration: AdwConstants.defaultDuration,
      switchInCurve: AdwConstants.defaultCurve,
      switchOutCurve: AdwConstants.defaultCurve,
      transitionBuilder: (child, animation) {
        final slideIn = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);

        final slideOut = Tween<Offset>(
          begin: const Offset(-0.3, 0),
          end: Offset.zero,
        ).animate(animation);

        // Very basic slide transition simulating push/pop stack
        if (child.key == ValueKey(currentIndex)) {
          return SlideTransition(position: slideIn, child: child);
        } else {
          return SlideTransition(position: slideOut, child: child);
        }
      },
      child: KeyedSubtree(
        key: ValueKey(currentIndex),
        child: widget.pages[currentIndex],
      ),
    );
  }
}
