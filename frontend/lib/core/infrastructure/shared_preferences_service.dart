import 'package:shared_preferences/shared_preferences.dart';

/// A service for managing user authentication tokens using shared preferences.
///
/// This class provides methods to save, retrieve, and delete authentication
/// tokens in a persistent manner, allowing for simple local storage of
/// user credentials.
///
/// Methods:
/// - [saveToken]: Saves a token associated with a specified key.
/// - [getToken]: Retrieves a token associated with a specified key.
/// - [deleteToken]: Deletes the token associated with a specified key.
class SharedPreferencesService {
  /// Saves a token in shared preferences.
  ///
  /// Takes a [token] as a string and a [tokenKey] to identify the token
  /// in storage. This method is asynchronous and will complete when the
  /// token is saved.
  Future<void> saveToken(String token, String tokenKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  /// Retrieves a token from shared preferences.
  ///
  /// Takes a [tokenKey] to identify the token in storage. Returns the
  /// token as a string, or null if the token is not found. This method
  /// is asynchronous and will complete when the token is retrieved.
  Future<String?> getToken(String tokenKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// Deletes a token from shared preferences.
  ///
  /// Takes a [tokenKey] to identify the token to be removed. This method
  /// is asynchronous and will complete when the token is deleted.
  Future<void> deleteToken(String tokenKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }
}
