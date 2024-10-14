import 'package:frontend/core/infrastructure/shared_preferences_service.dart';
import 'package:frontend/service_locator.dart';

abstract class AuthLocalService {
  Future<void> signOut();
}

class AuthLocalServiceImpl implements AuthLocalService {
  @override
  Future<void> signOut() async {
    await sl<SharedPreferencesService>().deleteToken();
  }
}
