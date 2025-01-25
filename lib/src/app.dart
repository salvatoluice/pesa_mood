import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: const Scaffold(body: Center(child: Text('M-Pesa Mood Ring'))),
    );
  }
}
