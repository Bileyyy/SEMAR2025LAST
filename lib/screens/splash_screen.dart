import 'dart:async';
import 'package:flutter/material.dart';
import 'package:semar/widgets/navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool showLogo = true;
  String emarText = '';
  int emarIndex = 0;

  late AnimationController sController;
  late Animation<double> sSizeAnim;
  late Animation<Offset> sOffsetAnim;

  late AnimationController emarOpacityController;
  late Animation<double> emarOpacityAnim;

  @override
  void initState() {
    super.initState();

    sController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    sSizeAnim = Tween<double>(begin: 100, end: 40).animate(
      CurvedAnimation(parent: sController, curve: Curves.easeOutExpo),
    );

    sOffsetAnim = Tween<Offset>(begin: Offset.zero, end: const Offset(-0.35, 0))
        .animate(CurvedAnimation(parent: sController, curve: Curves.easeOutExpo));

    emarOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    emarOpacityAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: emarOpacityController, curve: Curves.easeIn),
    );

    // Tunda 1 detik, lalu mulai animasi
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => showLogo = false);
      sController.forward();
      _startTyping();
    });

    // Navigasi ke home (Navbar) setelah 4 detik
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Navbar(selectedIndex: 0)),
      );
    });
  }

  void _startTyping() {
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (emarIndex < 4) {
        setState(() {
          emarText += 'EMAR'[emarIndex];
          emarIndex++;
        });
      } else {
        timer.cancel();
        emarOpacityController.forward();
      }
    });
  }

  @override
  void dispose() {
    sController.dispose();
    emarOpacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0D4), // Background sesuai desain
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLogo)
              Image.asset(
                'assets/logo_semar.png',
                width: 150,
              )
            else
              Row(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.baseline,
  textBaseline: TextBaseline.alphabetic,
  children: [
    SlideTransition(
      position: sOffsetAnim,
      child: AnimatedBuilder(
        animation: sSizeAnim,
        builder: (_, child) {
          double offsetAdjust = (100 - sSizeAnim.value) * 0.15;
          return Transform.translate(
            offset: Offset(offsetAdjust, 0),
            child: Text(
              'S',
              style: TextStyle(
                fontSize: sSizeAnim.value,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2A6171),
                fontFamily: 'Poppins',
                height: 0.9, // Reduced line height
              ),
            ),
          );
        },
      ),
    ),
    AnimatedOpacity(
      opacity: emarText.isNotEmpty ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Text(
        emarText,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2A6171),
          fontFamily: 'Poppins',
          height: 0.9, 
        ),
      ),
    ),
  ],
),
const SizedBox(height: 4),
            FadeTransition(
              opacity: emarOpacityAnim,
              child: const Text(
                'Seputar Semarang',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2A6171),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
