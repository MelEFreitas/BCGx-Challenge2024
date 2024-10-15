import 'package:dio/dio.dart';
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
