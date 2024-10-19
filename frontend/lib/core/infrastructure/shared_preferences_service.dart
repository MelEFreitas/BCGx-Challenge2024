import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> saveToken(String token, String tokenKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<String?> getToken(String tokenKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> deleteToken(String tokenKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }
}
