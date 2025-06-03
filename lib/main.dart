import 'package:flutter/material.dart';
import 'package:semar/screens/start_screen.dart'; // StartScreen akan handle Splash

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const StartScreen(), // StartScreen sebagai entry point
    );
  }
}
