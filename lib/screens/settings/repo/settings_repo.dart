import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getAppearance() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('appearance') ?? 'Light';
  }

  Future<void> saveAppearance(String appearance) async {
    final prefs = await SharedPreferences.getInstance();

    final saved = await prefs.setString(
      'appearance',
      appearance,
    );

    if (!saved) {
      throw Exception('Could not save appearance.');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}