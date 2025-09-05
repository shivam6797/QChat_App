import 'package:dio/dio.dart';
import 'package:qchat_app/core/errors/api_exception.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({String? baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? "",
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            "Content-Type": "application/json",
          },
        ));

  Future<dynamic> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response =
          await _dio.get(url, queryParameters: queryParameters, options: Options(headers: headers));
      return response.data;
    } catch (error) {
      throw ApiException.fromDioError(error);
    }
  }

  Future<dynamic> post(String url,
      {Map<String, dynamic>? data, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(url,
          data: data, options: Options(headers: headers));
      return response.data;
    } catch (error) {
      throw ApiException.fromDioError(error);
    }
  }
}
