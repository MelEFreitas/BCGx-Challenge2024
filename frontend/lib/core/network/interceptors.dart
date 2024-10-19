import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_urls.dart';
import 'package:frontend/core/infrastructure/shared_preferences_service.dart';
import 'package:frontend/data/sources/auth/auth_local_service.dart';
import 'package:frontend/service_locator.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: false));

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    logger.e('${options.method} request ==> ${options.baseUrl}${options.path}');
    logger.e('*** Error ***\n'
        'Error: ${err.message}');
    if (err.response != null) {
      logger.e('Status Code: ${err.response?.statusCode}\n'
          'Error Data: ${err.response?.data}\n'
          'Error Headers: ${err.response?.headers}');
    }
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('${options.method} request ==> ${options.baseUrl}${options.path}');
    logger.i('*** Request ***\n'
        'Method: ${options.method}\n'
        'URL: ${options.uri}\n'
        'Headers: ${options.headers}\n'
        'Query Parameters: ${options.queryParameters}\n'
        'Request Body: ${options.data ?? "No Body"}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('*** Response ***\n'
        'Status Code: ${response.statusCode}\n'
        'Data: ${response.data}\n'
        'Headers: ${response.headers}');
    handler.next(response);
  }
}

class TokenInterceptor extends Interceptor {
  final Dio tokenDio = Dio();

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the error was a 401(Unauthorized) and the access token is expired
    if (err.response?.statusCode == 401) {
      final refreshToken = await sl<SharedPreferencesService>()
          .getToken(TokenKeys.refreshTokenKey);
      if (refreshToken != null) {
        final refreshResponse = await _refreshToken(refreshToken);
        if (refreshResponse != null) {
          await sl<SharedPreferencesService>().saveToken(
              refreshResponse['access_token'], TokenKeys.accessTokenKey);
          // Retry the original request with the new access token
          final clonedRequest = await _retryRequest(err.requestOptions);
          return handler.resolve(clonedRequest); // Return the retried request
        } else {
          sl<AuthLocalService>().signOut();
          return handler.reject(err);
        }
      }
    }
    // If it's not a 401 or no refresh token is available, just forward the error
    return super.onError(err, handler);
  }

  // Method to refresh the token
  Future<Map<String, dynamic>?> _refreshToken(String refreshToken) async {
    try {
      final response = await tokenDio.post(
        ApiUrls.refreshAccessTokenUrl,
        data: {
          'refresh_token': refreshToken,
        },
      );
      return response.data;
    } catch (e) {
      sl<AuthLocalService>().signOut();
      return null;
    }
  }

  // Method to retry the original request with the new token
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final accessToken =
        await sl<SharedPreferencesService>().getToken(TokenKeys.accessTokenKey);
    final newOptions = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    newOptions.headers!['Authorization'] = 'Bearer $accessToken';

    return await tokenDio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: newOptions,
    );
  }
}
