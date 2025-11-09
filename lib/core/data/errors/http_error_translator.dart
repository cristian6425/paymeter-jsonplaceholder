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
            'La solicitud tardó demasiado tiempo. Verifica tu conexión e inténtalo de nuevo.',
        statusCode: statusCode,
        reason: 'timeout',
        type: exception.type,
      );
    }

    switch (exception.type) {
      case DioExceptionType.badCertificate:
        return NetworkError(
          message: 'No se pudo establecer una conexión segura.',
          statusCode: statusCode,
          reason: 'bad_certificate',
          type: exception.type,
        );
      case DioExceptionType.cancel:
        return NetworkError(
          message: 'Operación cancelada por el usuario.',
          statusCode: statusCode,
          reason: 'cancelled',
          type: exception.type,
        );
      default:
        return NetworkError(
          message:
              'No fue posible comunicarse con el servicio. Inténtalo más tarde.',
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
      400 => 'Solicitud inválida. Revisa los datos enviados.',
      401 => 'No autorizado. Inicia sesión nuevamente.',
      403 => 'No tienes permisos para realizar esta acción.',
      404 => 'Recurso no encontrado.',
      409 => 'Conflicto con la información enviada.',
      422 => 'Los datos enviados no cumplen con los requisitos.',
      500 => 'Error interno del servidor.',
      503 => 'Servicio no disponible temporalmente.',
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
