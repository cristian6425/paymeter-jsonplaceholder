sealed class Failure implements Exception {
  const Failure({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
    this.statusCode,
    this.isTimeout = false,
  });

  final int? statusCode;
  final bool isTimeout;
}

final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
    this.fieldErrors = const {},
  });

  final Map<String, List<String>> fieldErrors;
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

final class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}
