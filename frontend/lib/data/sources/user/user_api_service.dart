import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_urls.dart';
import 'package:frontend/core/error_handling/exception.dart';
import 'package:frontend/core/infrastructure/shared_preferences_service.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/data/models/user/update_user_req.dart';
import 'package:frontend/service_locator.dart';

abstract class UserApiService {
  Future<void> updateUser(UpdateUserReq req);
}

class UserApiServiceImpl implements UserApiService {
  @override
  Future<void> updateUser(UpdateUserReq req) async {
    try {
      final token = await sl<SharedPreferencesService>().getToken();
      final response = await sl<DioClient>().post(ApiUrls.updateUserRoleUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: req.toMap(),
      );
    } on DioException catch (e) {
      throw UpdateUserException(message: e.response!.data['message']);
    } catch (_) {
      rethrow;
    }
  }
  
}