import 'package:flutter/material.dart';
import 'package:mpesa_mood_ring/src/app/root_layout.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pesa Pulse',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B894), // Your primary color
          brightness: Brightness.light,
          primary: const Color(0xFF00B894),
          secondary: const Color(0xFF0984E3),
          surface: Colors.white,
          background: Colors.white,
          onSurface: Colors.black87,
        ),
      ),
      home: const RootLayout(),
    );
  }
}
