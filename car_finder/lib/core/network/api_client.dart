import 'package:dio/dio.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<Response?> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Centralized Error Handling
  void _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        print('Error: Connection Timeout with Server');
        break;
      case DioExceptionType.badResponse:
        print('Server Error: ${e.response?.statusCode}');
        break;
      case DioExceptionType.connectionError:
        print('Error: No Internet Connection');
        break;
      default:
        print('Unexpected Error: ${e.message}');
    }
  }
}
