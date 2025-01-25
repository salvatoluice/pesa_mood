import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpesa_mood_ring/src/features/mood_ring/mood_ring_screen.dart';
import 'package:mpesa_mood_ring/src/features/navigation/main_navigation.dart';

class RootLayout extends ConsumerWidget {
  const RootLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: _getCurrentScreen(currentIndex),
      floatingActionButton: const ModernNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: colors.background,
    );
  }

  Widget _getCurrentScreen(int index) {
    switch (index) {
      case 0:
        return const FinancialMoodScreen();
      case 1:
        return const FinancialMoodScreen(); // Create these screens
      case 2:
        return const FinancialMoodScreen(); // Create these screens
      default:
        return const FinancialMoodScreen();
    }
  }
}
