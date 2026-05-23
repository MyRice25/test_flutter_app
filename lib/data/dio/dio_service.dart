import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/secure_storage/secure_storage_service.dart';
import 'error/error_exception_type.dart';
import 'interceptor/dio_interceptor.dart';

/// 토큰 타입 (헤더에 넣어줄지를 결정하는 타입)
enum TokenType {
  none,
  access,
  refresh,
  both,
}

abstract class BaseURLs {
  static const String dev =
      'http://ec2-15-164-248-13.ap-northeast-2.compute.amazonaws.com:3000/';
  static const String deepLink = 'https://trillow.kr';
}

/// 네트워크 서비스
class DioService {
  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;

  late final Dio _dio;
  final SecureStorageService _storage = SecureStorageService();

  // 생성자 (외부에서 인스턴스를 생성할 수 없음)
  DioService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: BaseURLs.dev,
        connectTimeout: const Duration(seconds: 45),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // TODO: - 실제 서비스 출시 전에는 코드 제거 (디버그 환경에서만 호출되는 것이 아님)
    _dio.interceptors.add(
      LogInterceptor(
        logPrint: (o) => debugPrint(o.toString()),
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    );

    // 토큰 인터셉터
    _dio.interceptors.add(
      DioInterceptor(storage: _storage),
    );
  }

  // GET 요청
  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? parameters,
    Options? options,
    TokenType tokenType = TokenType.none,
  }) async {
    try {
      // 토큰 타입에 따라 옵션 추가
      final Options? mergedOptions = _mergeOptionsWithTokenType(
        options: options,
        tokenType: tokenType,
      );

      final response = await _dio.get(
        path,
        queryParameters: parameters,
        options: mergedOptions,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST 요청
  Future<T> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? parameters,
    Options? options,
    TokenType tokenType = TokenType.none,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      // 토큰 타입에 따라 옵션 추가
      final Options? mergedOptions = _mergeOptionsWithTokenType(
        options: options,
        tokenType: tokenType,
      );

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: parameters,
        options: mergedOptions,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT 요청
  Future<T> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? parameters,
    Options? options,
    TokenType tokenType = TokenType.none,
  }) async {
    try {
      // 토큰 타입에 따라 옵션 추가
      final Options? mergedOptions = _mergeOptionsWithTokenType(
        options: options,
        tokenType: tokenType,
      );

      final response = await _dio.put(
        path,
        data: data,
        queryParameters: parameters,
        options: mergedOptions,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH 요청
  Future<T> patch<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? parameters,
    Options? options,
    TokenType tokenType = TokenType.none,
  }) async {
    try {
      // 토큰 타입에 따라 옵션 추가
      final Options? mergedOptions = _mergeOptionsWithTokenType(
        options: options,
        tokenType: tokenType,
      );

      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: parameters,
        options: mergedOptions,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE 요청
  Future<T> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? parameters,
    Options? options,
    TokenType tokenType = TokenType.none,
  }) async {
    try {
      // 토큰 타입에 따라 옵션 추가
      final Options? mergedOptions = _mergeOptionsWithTokenType(
        options: options,
        tokenType: tokenType,
      );

      final response = await _dio.delete(
        path,
        queryParameters: parameters,
        data: data,
        options: mergedOptions,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ///
  /// 토큰 타입에 따라 옵션 추가
  ///
  Options? _mergeOptionsWithTokenType({
    Options? options,
    required TokenType tokenType,
  }) {
    // 옵션이 없으면 새로운 옵션 생성
    final extra = Map<String, dynamic>.from(options?.extra ?? {});

    switch (tokenType) {
      case TokenType.access:
        extra['requiresAccessToken'] = true;
        break;
      case TokenType.refresh:
        extra['requiresRefreshToken'] = true;
        break;
      case TokenType.both:
        extra['requiresAccessToken'] = true;
        extra['requiresRefreshToken'] = true;
        break;
      case TokenType.none:
        return options;
    }

    return Options(
      method: options?.method,
      sendTimeout: options?.sendTimeout,
      receiveTimeout: options?.receiveTimeout,
      extra: extra,
      headers: options?.headers,
      responseType: options?.responseType,
      contentType: options?.contentType,
      validateStatus: options?.validateStatus,
      receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
      followRedirects: options?.followRedirects,
      maxRedirects: options?.maxRedirects,
      requestEncoder: options?.requestEncoder,
      responseDecoder: options?.responseDecoder,
    );
  }

  // 에러 핸들링
  Exception _handleError(DioException error) {
    // 토큰 누락 에러 처리
    if (error.error is TokenMissingException) {
      return error.error as TokenMissingException;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          '요청이 시간 초과했습니다. (잠시 후 다시 시도해주세요)',
        );

      case DioExceptionType.badResponse: // (200-299) 이외의 상태 코드 반환 시
        // 서버 응답에서 메시지 추출
        String responseMessage = '';

        try {
          final response = error.response?.data;
          if (response is Map<String, dynamic> && response['message'] != null) {
            responseMessage = response['message'].toString();
          }
        } catch (e) {
          responseMessage = '서버 오류가 발생했습니다. (잠시 후 다시 시도해주세요)';
        }

        return ServerException(
          responseMessage,
          statusCode: error.response?.statusCode,
        );
      default:
        return NetworkException(
          '네트워킹 오류가 발생했습니다. (잠시 후 다시 시도해주세요)',
        );
    }
  }
}
