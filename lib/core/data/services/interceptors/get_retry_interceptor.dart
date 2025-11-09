import 'package:dio/dio.dart';

/// Retries failed GET requests once when the error comes from transient issues.
class GetRequestRetryInterceptor extends Interceptor {
  GetRequestRetryInterceptor({
    required Dio client,
    this.maxRetries = 1,
  }) : _client = client;

  final Dio _client;
  final int maxRetries;

  static const _retryAttemptKey = 'retry_attempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final currentAttempt =
        (err.requestOptions.extra[_retryAttemptKey] as int?) ?? 0;

    if (currentAttempt >= maxRetries) {
      return handler.next(err);
    }

    err.requestOptions.extra[_retryAttemptKey] = currentAttempt + 1;

    try {
      final response = await _client.fetch(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (dioError) {
      handler.next(dioError);
    } catch (error) {
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: error,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  bool _shouldRetry(DioException err) {
    final request = err.requestOptions;
    if (request.method.toUpperCase() != 'GET') {
      return false;
    }

    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.unknown:
        return true;
      default:
        return false;
    }
  }
}
