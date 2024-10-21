import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_urls.dart';
import 'package:frontend/core/error_handling/exception.dart';
import 'package:frontend/core/infrastructure/shared_preferences_service.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/data/models/user/user.dart';
import 'package:frontend/service_locator.dart';

/// An abstract class that defines the API service operations for authentication.
abstract class AuthApiService {
  /// Signs in the user with the given [req].
  ///
  /// Throws a [SignInException] if the sign-in fails.
  Future<void> signIn(SignInReq req);

  /// Signs up a new user with the given [req].
  ///
  /// Throws a [SignUpException] if the sign-up fails.
  Future<void> signUp(SignUpReq req);

  /// Authenticates the current user.
  ///
  /// Returns a [UserModel] if authentication is successful.
  /// Throws an [AuthUserException] if authentication fails.
  Future<UserModel> authUser();
}

/// Implementation of the [AuthApiService] interface.
///
/// This class manages authentication-related API calls such as signing in, signing up, and authenticating users.
class AuthApiServiceImpl implements AuthApiService {
  /// Signs in the user with the given [req].
  ///
  /// Retrieves access and refresh tokens from the API and stores them in [SharedPreferencesService].
  /// Throws a [SignInException] if the sign-in process encounters an error.
  @override
  Future<void> signIn(SignInReq req) async {
    try {
      final response = await sl<DioClient>().post(ApiUrls.createTokensUrl,
          data: req.toMap(),
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ));
      final accessToken = response.data[TokenKeys.accessTokenKey];
      final refreshToken = response.data[TokenKeys.refreshTokenKey];
      await sl<SharedPreferencesService>()
          .saveToken(accessToken, TokenKeys.accessTokenKey);
      await sl<SharedPreferencesService>()
          .saveToken(refreshToken, TokenKeys.refreshTokenKey);
    } on DioException catch (e) {
      throw SignInException(
          message: e.response?.data['detail'],
          statusCode: e.response?.statusCode);
    }
  }

  /// Signs up a new user with the given [req].
  ///
  /// Sends the user data to the API for registration.
  /// Throws a [SignUpException] if the sign-up process encounters an error.
  @override
  Future<void> signUp(SignUpReq req) async {
    try {
      await sl<DioClient>().post(ApiUrls.createUserUrl,
          data: req.toMap(),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
    } on DioException catch (e) {
      throw SignUpException(
          message: e.response?.data['detail'],
          statusCode: e.response?.statusCode);
    }
  }

  /// Authenticates the current user.
  ///
  /// Retrieves the user's information from the API using the stored access token.
  /// Returns a [UserModel] if authentication is successful.
  /// Throws an [AuthUserException] if authentication fails.
  @override
  Future<UserModel> authUser() async {
    try {
      final accessToken = await sl<SharedPreferencesService>()
          .getToken(TokenKeys.accessTokenKey);
      if (accessToken == null) {
        throw AuthUserException();
      }
      final response = await sl<DioClient>().get(ApiUrls.authenticateUserUrl,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthUserException(
          message: e.response?.data['detail'],
          statusCode: e.response?.statusCode);
    }
  }
}
