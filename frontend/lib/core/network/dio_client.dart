import 'package:dio/dio.dart';
import 'interceptors.dart';

/// A client for making HTTP requests using the Dio library.
///
/// The [DioClient] class provides methods for sending GET, POST, PUT, and DELETE
/// requests. It includes logging and token management via interceptors.
class DioClient {
  late final Dio _dio;

  /// Creates an instance of [DioClient].
  ///
  /// Initializes the Dio instance with default settings and adds the necessary
  /// interceptors for logging and token management.
  DioClient()
      : _dio = Dio(
          BaseOptions(
            responseType: ResponseType.json,
          ),
        )..interceptors.addAll([
            LoggerInterceptor(),
            TokenInterceptor(),
          ]);

  /// Sends a GET request to the specified [url].
  ///
  /// Optionally, you can include query parameters, custom options, a cancellation token,
  /// and a progress callback.
  ///
  /// Returns the response from the server.
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      // Handle any errors during the request
      rethrow;
    }
  }

  /// Sends a POST request to the specified [url].
  ///
  /// The request can include a request body, query parameters, custom options,
  /// and progress callbacks for upload and download.
  ///
  /// Returns the response from the server.
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      // Handle any errors during the request
      rethrow;
    }
  }

  /// Sends a PUT request to the specified [url].
  ///
  /// Optionally, you can include a request body, query parameters, custom options,
  /// a cancellation token, and progress callbacks.
  ///
  /// Returns the response from the server.
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      // Handle any errors during the request
      rethrow;
    }
  }

  /// Sends a DELETE request to the specified [url].
  ///
  /// Optionally, you can include a request body, query parameters, custom options,
  /// and a cancellation token.
  ///
  /// Returns the response data from the server.
  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      // Handle any errors during the request
      rethrow;
    }
  }
}
