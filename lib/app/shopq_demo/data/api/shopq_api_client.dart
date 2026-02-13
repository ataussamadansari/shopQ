import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ShopqApiException implements Exception {
  ShopqApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ShopqApiClient {
  ShopqApiClient({String? baseUrl})
      : _baseUrl = baseUrl ?? _defaultBaseUrl {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
        headers: <String, String>{
          'Accept': 'application/json',
        },
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
        ),
      );
    }
  }

  final String _baseUrl;
  late final Dio _dio;
  String? _token;
  static const String _lanBaseUrl = 'http://192.168.1.6:8000/api/v1/';

  static String get _defaultBaseUrl {
    const definedBaseUrl = String.fromEnvironment('SHOPQ_API_BASE_URL');
    if (definedBaseUrl.isNotEmpty) {
      return definedBaseUrl;
    }

    if (kIsWeb) {
      return _lanBaseUrl;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _lanBaseUrl;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return _lanBaseUrl;
    }
  }

  String get baseUrl => _baseUrl;

  void setToken(String? token) {
    _token = token;
    if (token == null || token.isEmpty) {
      _dio.options.headers.remove('Authorization');
      return;
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool authRequired = false,
  }) async {
    _assertAuth(authRequired);
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return _asMap(response.data);
    } on DioException catch (error) {
      throw ShopqApiException(_resolveErrorMessage(error));
    }
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? data,
    bool authRequired = false,
  }) async {
    _assertAuth(authRequired);
    try {
      final response = await _dio.post<dynamic>(path, data: data);
      return _asMap(response.data);
    } on DioException catch (error) {
      throw ShopqApiException(_resolveErrorMessage(error));
    }
  }

  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? data,
    bool authRequired = false,
  }) async {
    _assertAuth(authRequired);
    try {
      final response = await _dio.patch<dynamic>(path, data: data);
      return _asMap(response.data);
    } on DioException catch (error) {
      throw ShopqApiException(_resolveErrorMessage(error));
    }
  }

  Future<Map<String, dynamic>> deleteJson(
    String path, {
    Map<String, dynamic>? data,
    bool authRequired = false,
  }) async {
    _assertAuth(authRequired);
    try {
      final response = await _dio.delete<dynamic>(path, data: data);
      return _asMap(response.data);
    } on DioException catch (error) {
      throw ShopqApiException(_resolveErrorMessage(error));
    }
  }

  void _assertAuth(bool authRequired) {
    if (!authRequired) {
      return;
    }
    if (_token == null || _token!.isEmpty) {
      throw ShopqApiException('Please login first.');
    }
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    return <String, dynamic>{};
  }

  String _resolveErrorMessage(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final directMessage = responseData['message'];
      if (directMessage is String && directMessage.trim().isNotEmpty) {
        return directMessage;
      }
      final errors = responseData['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstValue = errors.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          final first = firstValue.first;
          if (first is String && first.trim().isNotEmpty) {
            return first;
          }
        }
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.connectionError) {
      return 'Unable to reach backend. Check API URL and server status.';
    }

    return 'Request failed. Please try again.';
  }
}
