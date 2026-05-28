import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindforge/features/splashscreen/splash_screen.dart'; 
// IMPORT KEDUA HALAMAN INI:
import 'package:mindforge/features/auth/presentation/login_screen.dart';
import 'package:mindforge/features/dashboard/presentation/dashbaord_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindforge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
      ),
      // Tetap gunakan SplashScreen sebagai halaman awal
      home: SplashScreen(isFirstTime: isFirstTime),
      
      // TAMBAHKAN REGISTER ROUTES DI SINI:
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}