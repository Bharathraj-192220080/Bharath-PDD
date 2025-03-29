import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Save user credentials (Sign Up)
  static Future<void> signUp(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
  }

  // Login function
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString(_keyEmail);
    String? savedPassword = prefs.getString(_keyPassword);

    if (savedEmail == email && savedPassword == password) {
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    }
    return false;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Logout function
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
