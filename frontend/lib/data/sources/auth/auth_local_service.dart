import 'package:frontend/core/constants/api_urls.dart';
import 'package:frontend/core/infrastructure/shared_preferences_service.dart';
import 'package:frontend/service_locator.dart';

/// An abstract class that defines the local authentication service operations.
abstract class AuthLocalService {
  /// Signs out the user by clearing the authentication tokens from local storage.
  Future<void> signOut();
}

/// Implementation of the [AuthLocalService] interface.
///
/// This class manages local user authentication operations such as signing out.
class AuthLocalServiceImpl implements AuthLocalService {
  /// Signs out the user by deleting the access and refresh tokens from local storage.
  ///
  /// This method clears the tokens stored in [SharedPreferencesService].
  @override
  Future<void> signOut() async {
    await sl<SharedPreferencesService>().deleteToken(TokenKeys.accessTokenKey);
    await sl<SharedPreferencesService>().deleteToken(TokenKeys.refreshTokenKey);
  }
}
