import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_urls.dart';
import 'package:frontend/core/error_handling/exception.dart';
import 'package:frontend/core/infrastructure/shared_preferences_service.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/data/models/user/update_user_req.dart';
import 'package:frontend/service_locator.dart';

/// An abstract class that defines the API service for user-related operations.
abstract class UserApiService {
  /// Updates the user information based on the provided [UpdateUserReq].
  ///
  /// Throws an [UpdateUserException] if the update fails.
  Future<void> updateUser(UpdateUserReq req);
}

/// Implementation of the [UserApiService] interface.
///
/// This class interacts with the remote API to perform user-related operations.
class UserApiServiceImpl implements UserApiService {
  /// Updates the user information using the provided [UpdateUserReq].
  ///
  /// Retrieves the access token from shared preferences and makes a POST
  /// request to update the user role.
  ///
  /// Throws an [UpdateUserException] if the request fails.
  @override
  Future<void> updateUser(UpdateUserReq req) async {
    try {
      final accessToken = await sl<SharedPreferencesService>()
          .getToken(TokenKeys.accessTokenKey);
      await sl<DioClient>().post(
        ApiUrls.updateUserRoleUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: req.toMap(),
      );
    } on DioException catch (e) {
      throw UpdateUserException(message: e.response!.data['message']);
    }
  }
}
