import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_urls.dart';
import 'package:frontend/core/error_handling/exception.dart';
import 'package:frontend/core/infrastructure/shared_preferences_service.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/data/models/user/user.dart';
import 'package:frontend/service_locator.dart';

abstract class AuthApiService {
  Future<void> signIn(SignInReq req);
  Future<void> signUp(SignUpReq req);
  Future<UserModel> authUser();
}

class AuthApiServiceImpl implements AuthApiService {
  @override
  Future<void> signIn(SignInReq req) async {
    try {
      final response = await sl<DioClient>().post(ApiUrls.createTokenUrl,
          data: req.toMap(),
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ));
      final token = response.data['access_token'];
      if (token == null) {
        throw SignInException(message: "Failed to fetch the token");
      }
      await sl<SharedPreferencesService>().saveToken(token);
    } on DioException catch (e) {
      throw SignInException(message: e.response?.data['message']);
    } catch (e) {
      log("$e");
      rethrow;
    }
  }

  @override
  Future<void> signUp(SignUpReq req) async {
    try {
      await sl<DioClient>().post(ApiUrls.createUserUrl,
          data: req.toMap(),
          options: Options(
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
          ));
    } on DioException catch (e) {
      throw SignUpException(message: e.response?.data['message']);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserModel> authUser() async {
    try {
      final token = await sl<SharedPreferencesService>().getToken();
      final response = await sl<DioClient>().get(ApiUrls.authenticateUserUrl,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthUserException(message: e.response?.data['message']);
    } catch (e) {
      rethrow;
    }
  }
}
