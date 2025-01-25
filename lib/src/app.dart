import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpesa_mood_ring/src/config/theme/app_theme.dart';
import 'package:mpesa_mood_ring/src/features/mood_ring/mood_ring_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: appTheme,
        home: const FinancialMoodScreen(),
      ),
    );
  }
}
