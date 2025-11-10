import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/data/errors/data_error.dart';

class HttpErrorTranslator {
  const HttpErrorTranslator();

  DataError fromDioException(DioException exception) {
    final statusCode = exception.response?.statusCode;

    if (exception.type == DioExceptionType.badResponse) {
      return ApiError(
        message: _messageFromPayload(exception.response?.data) ??
            _messageFromStatus(statusCode) ??
            'Error al procesar la solicitud.',
        statusCode: statusCode,
        errorCode: _errorCodeFromPayload(exception.response?.data),
        details: _detailsFromPayload(exception.response?.data),
      );
    }

    if (_isTimeout(exception.type)) {
      return NetworkError(
        message:
            'The request timed out. Check your connection and try again.',
        statusCode: statusCode,
        reason: 'timeout',
        type: exception.type,
      );
    }

    switch (exception.type) {
      case DioExceptionType.badCertificate:
        return NetworkError(
          message: 'Unable to establish a secure connection.',
          statusCode: statusCode,
          reason: 'bad_certificate',
          type: exception.type,
        );
      case DioExceptionType.cancel:
        return NetworkError(
          message: 'Operation cancelled by the user.',
          statusCode: statusCode,
          reason: 'cancelled',
          type: exception.type,
        );
      default:
        return NetworkError(
          message:
              'Unable to reach the service. Please try again later.',
          statusCode: statusCode,
          reason: exception.type.name,
          type: exception.type,
        );
    }
  }

  bool _isTimeout(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.connectionError;
  }

  String? _messageFromPayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      final Object? candidate =
          data['message'] ?? data['error'] ?? data['detail'];
      if (candidate is String && candidate.isNotEmpty) {
        return candidate;
      }
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return null;
  }

  String? _messageFromStatus(int? statusCode) {
    return switch (statusCode) {
      400 => 'Invalid request. Please verify the submitted data.',
      401 => 'Unauthorized. Please sign in again.',
      403 => 'You do not have permission to perform this action.',
      404 => 'Resource not found.',
      409 => 'Conflict with the submitted information.',
      422 => 'The data provided does not meet the requirements.',
      500 => 'Internal server error.',
      503 => 'Service temporarily unavailable.',
      _ => null,
    };
  }

  String? _errorCodeFromPayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      final Object? candidate = data['code'] ?? data['error_code'];
      if (candidate is String) {
        return candidate;
      }
    }
    return null;
  }

  Map<String, dynamic>? _detailsFromPayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      final Object? candidate = data['details'] ?? data['errors'];
      if (candidate is Map<String, dynamic>) {
        return Map<String, dynamic>.from(candidate);
      }
    }
    return null;
  }
}

final httpErrorTranslatorProvider = Provider<HttpErrorTranslator>((ref) {
  return const HttpErrorTranslator();
});
