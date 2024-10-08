import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_urls.dart';
import 'package:frontend/core/error_handling/exception.dart';
// import 'package:frontend/core/infrastructure/secure_storage_service.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/data/models/auth/auth_user_req.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/data/models/user/user.dart';
import 'package:frontend/service_locator.dart';

abstract class AuthApiService {
  Future<String> signIn(SignInReq req);
  Future<void> signUp(SignUpReq req);
  Future<UserModel> authUser(AuthUserReq req);
}

class AuthApiServiceImpl implements AuthApiService {
  @override
  Future<String> signIn(SignInReq req) async {
    try {
      final response = await sl<DioClient>().post(ApiUrls.tokenUrl,
          data: req.toMap(),
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ));
      final token = response.data['access_token'];
      if (token == null) {
        throw SignInException(message: "Failed to fetch the token");
      }

      return token;
      //await sl<SecureStorageService>().saveToken(token);
    } on DioException catch (e) {
      throw SignInException(message: e.response!.data['message']);
    } catch (e) {
      log("$e");
      rethrow;
    }
  }

  @override
  Future<void> signUp(SignUpReq req) async {
    try {
      await sl<DioClient>().post(ApiUrls.registerUrl,
          data: req.toMap(),
          options: Options(
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
          ));
    } on DioException catch (e) {
      throw SignUpException(message: e.response!.data['message']);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserModel> authUser(AuthUserReq req) async {
    try {
      //final String? token = await sl<SecureStorageService>().getToken();
      final response = await sl<DioClient>().get(ApiUrls.userUrl,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${req.token}',
            },
          ));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthUserException(message: e.response!.data['message']);
    } catch (e) {
      rethrow;
    }
  }
}
