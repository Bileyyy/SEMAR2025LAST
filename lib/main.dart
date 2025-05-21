import 'package:flutter/material.dart';
import 'package:semar/screens/home_screen.dart';
import 'package:semar/widgets/navbar.dart';
import 'screens/start_screen.dart'; // Import StartScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    debugShowCheckedModeBanner: false,
    home: Navbar(),
    );
  }
}