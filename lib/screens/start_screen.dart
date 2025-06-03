import 'package:flutter/material.dart';
import 'package:semar/widgets/navbar.dart';
import 'dart:async';
import 'package:semar/screens/splash_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();

    // Delay 1 frame untuk push agar context tersedia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SplashScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDF0D4),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
