import 'package:dio/dio.dart';

import '../../common/constants.dart';
import '../exceptions/app_exception.dart';

class ApiService {
  ApiService({Dio? client})
      : _client = client ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.apiBaseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            );

  final Dio _client;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _client.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: _options(),
      );
      return response.data;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _client.post<dynamic>(
        path,
        data: data,
        options: _options(),
      );
      return response.data;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _client.put<dynamic>(
        path,
        data: data,
        options: _options(),
      );
      return response.data;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Future<void> delete(String path) async {
    try {
      await _client.delete<void>(
        path,
        options: _options(),
      );
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Options _options() {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return Options(headers: headers);
  }

  AppException _mapException(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = error.response?.data is Map
        ? (error.response!.data['message'] as String?)
        : error.message;

    return AppException(
      message: message ?? 'Une erreur réseau est survenue.',
      statusCode: statusCode,
    );
  }
}
