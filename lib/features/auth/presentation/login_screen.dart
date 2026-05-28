import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as gsi_web;
import '../logic/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = AuthController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Ambil instance plugin web yang sedang berjalan aktif
    final webPlugin = GoogleSignInPlatform.instance as gsi_web.GoogleSignInPlugin;

    // SOLUSI UTAMA: Dengarkan langsung stream data internal web plugin.
    // Stream ini dijamin terpicu saat [GSI_LOGGER] menerima response.
    webPlugin.userDataEvents?.listen((event) async {
      if (event == null) return;

      // Ambil idToken langsung dari event payload web
      final String? idToken = event.idToken;

      if (idToken != null) {
        setState(() => _isLoading = true);
        try {
          // Kirim langsung string token ke backend PHP Native kamu
          final bool isSuccess = await _authController.sendRawTokenToBackend(idToken);
          if (isSuccess && mounted) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error API / Sistem: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              const Text(
                'Ready to Take\nControl?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Start organizing your life with MindForge\ntoday.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.5),
                  height: 1.4,
                ),
              ),
              const Spacer(flex: 5),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.black))
                    : Center(
                        child: (GoogleSignInPlatform.instance as gsi_web.GoogleSignInPlugin)
                            .renderButton(),
                      ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}