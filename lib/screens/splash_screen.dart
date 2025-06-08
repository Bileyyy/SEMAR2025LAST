import 'dart:async';
import 'package:flutter/material.dart';
import 'package:semar/widgets/navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  String emarText = '';
  int emarIndex = 0;

  late AnimationController sController;
  late Animation<double> sScaleAnim;
  late Animation<Offset> sSlideAnim;

  late AnimationController emarOpacityController;
  late Animation<double> emarOpacityAnim;

  late AnimationController imageOpacityController;
  late Animation<double> imageOpacityAnim;

  @override
  void initState() {
    super.initState();

    sController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    sScaleAnim = Tween<double>(begin: 2.5, end: 1.0).animate(
      CurvedAnimation(parent: sController, curve: Curves.easeInOutExpo),
    );

    sSlideAnim = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0)).animate(
      CurvedAnimation(parent: sController, curve: Curves.easeInOutExpo),
    );

    emarOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    emarOpacityAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: emarOpacityController, curve: Curves.easeIn),
    );

    imageOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imageOpacityAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: imageOpacityController, curve: Curves.easeIn),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      sController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      _startTyping();
    });

    emarOpacityController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        imageOpacityController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 4000), () {
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
    imageOpacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0D4),
      body: Column(
        children: [
          const Spacer(), // Mendorong semua ke tengah
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    AnimatedBuilder(
                      animation: sScaleAnim,
                      builder: (_, child) {
                        return Transform.scale(
                          scale: sScaleAnim.value,
                          child: const Text(
                            'S',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2A6171),
                              fontFamily: 'Poppins',
                              height: 1.0,
                            ),
                          ),
                        );
                      },
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
                          height: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
          const Spacer(), // Mendorong logo ke bagian bawah layar
          FadeTransition(
            opacity: imageOpacityAnim,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset(
                'assets/bg/powered by .png',
                width: 180,
                height: 180,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
