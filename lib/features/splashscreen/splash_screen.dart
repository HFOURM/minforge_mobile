import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindforge/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mindforge/features/auth/presentation/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isFirstTime;

  const SplashScreen({super.key, required this.isFirstTime});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() {
    Timer(const Duration(seconds: 3), _navigateToNext);
  }

  void _navigateToNext() {
    if (!mounted) return;

    if (widget.isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
    
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/mindforge.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}