import 'package:dio/dio.dart';

sealed class DataError implements Exception {
  const DataError({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;
}

final class ApiError extends DataError {
  const ApiError({
    required super.message,
    super.statusCode,
    this.errorCode,
    this.details,
  });

  final String? errorCode;
  final Map<String, dynamic>? details;
}

final class NetworkError extends DataError {
  const NetworkError({
    required super.message,
    super.statusCode,
    this.reason,
    this.type,
  });

  final String? reason;
  final DioExceptionType? type;
}
