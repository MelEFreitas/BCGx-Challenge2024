import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'access_token', value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: 'access_token');
  }
}
