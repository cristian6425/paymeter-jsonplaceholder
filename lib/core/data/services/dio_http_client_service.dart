import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/data/errors/http_error_translator.dart';
import 'package:paymeterjsonplaceholder/core/data/services/interceptors/get_retry_interceptor.dart';
import 'package:paymeterjsonplaceholder/core/utils/constants.dart';

class DioHttpClientService {
  DioHttpClientService({
    required String apiHost,
    required HttpErrorTranslator errorTranslator,
  })  : _dio = Dio(
          BaseOptions(
            baseUrl: apiHost,
            connectTimeout: const Duration(milliseconds: 10000),
            sendTimeout: const Duration(milliseconds: 30000),
            receiveTimeout: const Duration(milliseconds: 60000),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=utf-8',
            },
          ),
        ),
        _errorTranslator = errorTranslator {
    _setupInterceptors();
  }

  final Dio _dio;
  final HttpErrorTranslator _errorTranslator;

  Dio get client => _dio;

  void _setupInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final mappedError = _errorTranslator.fromDioException(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: mappedError,
            ),
          );
        },
      ),
    );

    _dio.interceptors.add(GetRequestRetryInterceptor(client: _dio));
  }
}

final dioHttpClientProvider = Provider<DioHttpClientService>((ref) {

  final errorTranslator = ref.watch(httpErrorTranslatorProvider);
  return DioHttpClientService(
    apiHost: Constants.apiHost,
    errorTranslator: errorTranslator,
  );
});

final dioProvider = Provider<Dio>((ref) {
  return ref.watch(dioHttpClientProvider).client;
});
