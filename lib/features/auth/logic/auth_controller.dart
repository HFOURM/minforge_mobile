import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // PENTING: Gunakan clientId Web kamu di sini
    clientId: '1020687520723-3bjvkuh17ql84g7lvur4vhlu25ja4p3f.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  GoogleSignIn get googleSignIn => _googleSignIn;
  final String _baseUrl = "http://localhost/mindforge/public/api";

  // Add this method inside your AuthController class
Future<bool> sendRawTokenToBackend(String idToken) async {
  final prefs = await SharedPreferences.getInstance();

  final response = await http.post(
    Uri.parse('$_baseUrl/auth/google'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'id_token': idToken, 
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    
    await prefs.setBool('isFirstTime', false);
    if (responseData.containsKey('token')) {
      await prefs.setString('auth_token', responseData['token']);
    }
    return true;
  } else {
    throw Exception("Backend PHP Error: ${response.statusCode} - ${response.body}");
  }
}
}